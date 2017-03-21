function play --description 'play music in iTunes. Use "-h" for more info.'
	# Check that $argv is not empty
	if test (count $argv) -eq 0;
		set action 'tell application "iTunes" to play'
	else
		set condition " where id > 0 "
		#getopts -ab1 --foo=bar baz | while read -l key value
		getopts $argv | while read -l key value
		    switch $key
		        #case _ #default
		            #echo "$value" # baz
		        case s
								set condition "$condition" " and name contains \"$value\""
		        case a
								set condition "$condition" " and artist contains \"$value\""
		        case A
								set condition "$condition" " and album contains \"$value\""
		        case g
								set condition "$condition" " and genre contains \"$value\""
		        case p
								set playlist "\"$value\""
		        case h
		            echo "
Control iTunes in fish!!!!

-s  song name
-a  artist name
-A  album name
-g  genre
-p  playlist
								"
								return
		    end
		end
		#echo $condition
		set actionSetup  "
		tell application \"iTunes\"
			if user playlist \"fish\" exists then
				try
					delete tracks of user playlist \"fish\"
				end try
			else
				make new user playlist with properties {name:\"fish\"}
			end if
			set plist to user playlist \"fish\"
		"

		if test (count $playlist) -eq 1;
			set actionCondition  "
				set libr to playlist $playlist
				set results to (every track of libr)
			"
		else
			set actionCondition  "
				set libr to playlist \"Library\"
				set results to (every track of libr $condition)
			"
		end

		set actionFinalize  "
			repeat with t in results
				duplicate t to plist
			end repeat
			play plist
		end tell
		"
		set action  "
		$actionSetup 
		$actionCondition
		$actionFinalize 
		"
	end

	#echo $action
	osascript -e "try
									$action
								end try"
	playing
end

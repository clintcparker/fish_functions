

function itunes --description 'itunes control. use -h for help'
	return
end

function play -d "play music in iTunes. Use \"-h\" for more info."
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
		        case h
		            echo "
Control iTunes in fish!!!!

-s  song name
-a  artist name
-A  album name
-g	genre
								"
								return
		    end
		end
		#echo $condition
		set action  "
		tell application \"iTunes\"
			if user playlist \"fish\" exists then
				try
					delete tracks of user playlist \"fish\"
				end try
			else
				make new user playlist with properties {name:\"fish\"}
			end if

			set plist to user playlist \"fish\"
			set libr to playlist \"Library\"
			set results to (every track of libr $condition)
			repeat with t in results
				duplicate t to plist
			end repeat
			play plist
		end tell
		"
	end

	#echo $action
	osascript -e "try
									$action
								end try"
	playing
end

function next -d "skip to next track in iTunes"
	osascript -e "
	tell application \"iTunes\"
		next track
	end tell
	"
	playing
end

function back -d "go back to start of current track in iTunes"
	osascript -e "
	tell application \"iTunes\"
		back track
	end tell
	"
	playing
end

function pause -d "pause iTunes playback"
	osascript -e "
	tell application \"iTunes\"
		pause
	end tell
	"
	playing
end

function prev -d "revisit the previous track in iTunes"
	osascript -e "
	tell application \"iTunes\"
		previous track
	end tell
	"
	playing
end



function playing -d "get info about the current song in iTunes"
	set title (osascript -e 'tell application "iTunes"
	set sname to get name of current track
	set sart to get artist of current track
	set cur to sname & " by " & sart
								end tell')
	echo $title

end

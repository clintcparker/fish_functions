# a fish function that wraps git-quick-stats
# takes named parameters for since, until, branch, output file
function gqs
    function _generate_csv -S
        set output_file (realpath $output_file)

        echo "Generating CSV file: $output_file"
        # strip the 1st two lines of the temp file
        #cat $temp_file | sed '1,2d' 
        sed -i '' '1,2d' $temp_file

        # strip the last 5 lines of the temp file and save as the same file
        sed -i '' -e :a -e '$d;N;2,5ba' -e 'P;D' $temp_file

        #overwrite the output file if it exists
        if test -f $output_file
            rm $output_file
        end
        # Create the CSV file and write the header
        echo "Author,Insertions,Deletions,Files,Commits,Lines Changed,First Commit,Last Commit" >$output_file

        # Process the input data and append to the CSV file
        cat $temp_file | awk '
        /<.*@.*>/ {
            if (author != "") {
                print author "," insertions "," deletions "," files "," commits "," lines_changed "," first_commit "," last_commit
            }
            author = $0
            sub(/^[[:space:]]*/, "", author)
            insertions = deletions = files = commits = lines_changed = first_commit = last_commit = ""
        }
        /insertions:/ { insertions = $2 }
        /deletions:/ { deletions = $2 }
        /files:/ { files = $2 }
        /commits:/ { commits = $2 }
        /lines changed:/ { lines_changed = $3 }
        /first commit:/ { first_commit = substr($0, index($0,$3)) }
        /last commit:/ { last_commit = substr($0, index($0,$3)) }
        END {
            if (author != "") {
                print author "," insertions "," deletions "," files "," commits "," lines_changed "," first_commit "," last_commit
            }
        }' >> $output_file
        echo "CSV file generated: $output_file"
        functions -e _generate_csv
    end

    #unfortunately, git-quick-statts does not support the --since and --until flags, and they have to be set as environment variables
    argparse --ignore-unknown 'since=' 'until=' 'branch=' 'csv' 'file=' 'o/open' -- $argv
    if test -n "$_flag_since"
        set -x _GIT_SINCE $_flag_since
    end
    if test -n "$_flag_until"
        set -x _GIT_UNTIL $_flag_until
    end
    if test -n "$_flag_branch"
        set -x _GIT_BRANCH $_flag_branch
    end
    set -l temp_file ~/gqs.txt
    #run git-quick-stats -T and store the output in a text file
    git-quick-stats -T > $temp_file
    #count the number of lines in the output
    set -l lines (cat $temp_file | wc -l)
    echo "Number of lines: " $lines
    #set the default output file
    set -l output_file ~/gqs.csv
    #check if the csv flag is set
    if test -n "$_flag_csv"
        #check if the file flag is set, if not, use the default
        if test -n "$_flag_file"
            set output_file $_flag_file
        end
        _generate_csv
        if test -n "$_flag_open"
            open $output_file
        end
    else
        echo "since:" $_flag_since
        echo "until:" $_flag_until
        echo "branch:" $_flag_branch
        cat $temp_file
    end

    #clear the environment variables
    set -e _GIT_SINCE
    set -e _GIT_UNTIL
    set -e _GIT_BRANCH

end

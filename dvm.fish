# this function gets or sets the version of dotnet to use
function dvm --description "get or set the version of dotnet to use (dvm -h for help)"
    # if there are no arguments, just print the current version
    if test (count $argv) -eq 0
        dotnet --version
    else
        # if the argument is "clear", remove the global.json file
        if test $argv[1] = "clear"
            rm global.json
            return
        end
        #if the argument is "list", list the installed sdks
        if test $argv[1] = "list"
            __get_dotnet_sdks
            return
        end
        # if the argument is "help" or "-h", print the help
        if test $argv[1] = "-h"
            __print_help
            return
        end
        if test $argv[1] = "help"
            __print_help
            return
        end
        # otherwise, set the version using the global.json file
        # if the file doesn't exist, create it
        if not test -f global.json
            echo "{ \"sdk\": { \"version\": \"$argv[1]\" } }" > global.json
        else
            # otherwise, update the version
            # replace the just version number (dotnet --version) with the new one in the global.json file
            set -l current_version (dotnet --version)
            sed -i -e "s/$current_version/$argv[1]/g" global.json
        end
    end
end

function __print_help
    echo "dvm - get or set the version of dotnet to use"
    echo "usage: dvm [version]"
    echo "version: the version of dotnet to use"
    echo "if no version is specified, the current version is printed"
    echo "if the version is \"clear\", the global.json file is removed"
    echo "if the version is \"list\", the installed sdks are listed"
    echo "if the version is \"help\", this help is printed"
end


function __get_dotnet_sdks
    # this function gets the list of installed dotnet sdks
    dotnet --list-sdks | sed -n 's/\[.*\]//p'
end

# an array variable is helpful for completions
set -l __dotnet_sdks ( __get_dotnet_sdks | tr '\n' ' ')

#completions for dvm should be valid installed sdk versions
complete -c dvm -x -n "not __fish_seen_subcommand_from $__dotnet_sdks" -a "$__dotnet_sdks"
#completions for dvm shouldn't include files
complete -c dvm -f
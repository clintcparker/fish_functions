function update --description "tool for updating global tools"
    
    function __update_brew --description "update global homebrew packages"
        set -l info "Runs `brew bundle --global`
        which installs packages from $HOME/.Brewfile"
        if [ (count $argv) = 1 ]
            if [ "--info" = "$argv[1]" ]
                echo $info
                return
            end
        end
        if [ (count $argv) = 1 ]
            if [ "--list" = "$argv[1]" ]
                set -l listCommand "brew bundle list --all --global"
                echo $listCommand
                eval $listCommand
                return
            end
        end
        if [ (count $argv) = 2 ]
            if [ "--update" = "$argv[1]" ]; and [ "--update" = "$argv[2]" ]
                set -l listCommand "brew bundle --global"
                echo $listCommand
                eval $listCommand
                return
            end
        end
        functions -e __update_brew
    end

    function __update_dnt --description "update global dotnet packages"
        set -l funcCode (functions dnt-update)
        set -l info "Runs `dnt update` : "
        if [ (count $argv) = 1 ]
            if [ "--info" = "$argv[1]" ]
                echo $info
                functions dnt-update
                return
            end
        end
        if [ (count $argv) = 1 ]
            if [ "--list" = "$argv[1]" ]
                cat ~/.config/.dotnet-tool-versions | while read -l pkg ver
                    echo $pkg
                end
                return
            end
        end
        if [ (count $argv) = 2 ]
            if [ "--update" = "$argv[1]" ]; and [ "--update" = "$argv[2]" ]
                set -l listCommand "dnt-update"
                echo $listCommand
                eval $listCommand
                return
            end
        end
        functions -e __update_dnt
    end

    function __update_asdf --description "update global asdf plugins"
        set -l info "for each tool in $HOME/.tool-versions
            updates the plguin for the tool
            then install the latest version of the tool
            and set it as the global version"
        if [ (count $argv) = 1 ]
            if [ "--info" = "$argv[1]" ]
                echo $info
                return
            end
        end
        if [ (count $argv) = 1 ]
            echo "asdf plugins:"
            if [ "--list" = "$argv[1]" ]
                cat ~/.tool-versions | while read -l pkg ver
                    echo $pkg
                end
                return
            end
        end
        if [ (count $argv) = 2 ]
            if [ "--update" = "$argv[1]" ]; and [ "--update" = "$argv[2]" ]
                cat ~/.tool-versions | while read -l pkg ver
                    asdf plugin update $pkg
                    asdf install $pkg latest
                    asdf global $pkg latest
                end
                return
            end
        end
        functions -e __update_asdf
    end

    function __update_gem --description "update global ruby gems"
        set -l info "updates RubyGems and all gems
            gem update --system
            bundle update"
        if [ (count $argv) = 1 ]
            if [ "--info" = "$argv[1]" ]
                echo $info
                return
            end
        end
        if [ (count $argv) = 1 ]
            if [ "--list" = "$argv[1]" ]
                bundle list
                return
            end
        end
        if [ (count $argv) = 2 ]
            if [ "--update" = "$argv[1]" ]; and [ "--update" = "$argv[2]" ]
                gem update --system
                bundle update
                return
            end
        end
        functions -e __update_gem
    end

    function read_confirm
        while true
          read -l -P 'Do you want to continue? [y/N] ' confirm
      
          switch $confirm
            case Y y
              return 0
            case '' N n
              return 1
          end
        end
        functions -e read_confirm
    end

    function __update_all
        echo "This will update all global tools"
        if read_confirm
            echo "Updating all global tools"
            update brew
            update asdf
            update gem
            update dnt
        else
            echo "Aborting"
        end
        functions -e __update_all
    end

    set -l toolManagers brew asdf gem dnt
    set -l thisHelp "Update global tools
        Usage: update [tool manager]
            Example: update brew
        use 'update --list-all' to list all tool managers
        use 'update --info [tool manager]' to print info about a tool manager
        use 'update --help' to print this help"

    #if there is only one argument, print info about that tool manager
    if [ (count $argv) = 1 ]
        if [ "--help" = "$argv[1]" ]
            echo $thisHelp
            return
        end
        if [ "--list-all" = "$argv[1]" ]
            echo "List of tool managers:"
            # print each tool manager $toolManagers and its description in on its own line
            for tool in $toolManagers
                set -l tooldesc (desc __update_$tool)
                echo (string replace __update_ "" $tooldesc)
            end
            return
        end
        if [ "$argv[1]" = "--info" ]; or [ "$argv[1]" = "--list" ]
            echo "Error: no tool manager specified"
            echo "Usage: update $argv[1] [tool]"
            echo "Example: update $argv[1] brew"
            return
        end
        if [ "$argv[1]" = "--all" ];
            __update_all
            return
        end
        #if $argv[1] is in the $toolManagers list, call the function
        if contains $argv[1] $toolManagers
            eval "__update_$argv[1] --update --update"
            return
        end
    end

    if [ (count $argv) = 2 ]
        if [ "--info" = "$argv[1]" ]; or [ "--list" = "$argv[1]" ]
            if contains $argv[2] $toolManagers
                eval "__update_$argv[2] $argv[1]"
                return
            end
        end
        if contains $argv[1] $toolManagers
            if [ "--info" = "$argv[2]" ]; or [ "--list" = "$argv[2]" ]
                eval "__update_$argv[1] $argv[2]"
                return
            end
        end
    end
    
    #if $argv is empty, print help
    if [ -z "$argv" ]
        echo $thisHelp
        return
    end

    #if we haven't returned yet, we have arguments we don't understand
    echo "Error: unknown arguments"
    echo $argv

    
end


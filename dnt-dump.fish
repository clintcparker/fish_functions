function dnt-dump
    set -l file "$HOME/.config/.dotnet-tool-versions"
    dotnet tool list --global | while read -l pkg ver cmd
        if test $ver
            if [ $pkg = Package ]
                rm -f $file
            else
                printf '%s\t%s\n' $pkg $ver >>$file
            end
        end
    end
    cat $file
end

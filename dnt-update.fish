function dnt-update
    cat ~/.config/.dotnet-tool-versions | while read -l pkg ver
        dotnet tool update $pkg --global
    end
    dnt-dump
end

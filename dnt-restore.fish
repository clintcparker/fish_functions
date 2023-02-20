function dnt-restore
    cat ~/.config/.dotnet-tool-versions | while read -l pkg ver
        dotnet tool install $pkg --version $ver --global
    end
end

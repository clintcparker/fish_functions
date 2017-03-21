function bl --description 'list all apps installed via homebrew & cask'
	echo "Brews"
    echo "--------------"
    brew list
    echo ""
    echo "Casks"
    echo "--------------"
    brew cask list
end

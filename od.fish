function od --description 'octopress deploy'
	set -gx JEKYLL_ENV 'production'
    octopress deploy
    set -gx JEKYLL_ENV 'development'
end

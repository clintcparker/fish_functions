function od --description 'Deploy an octopress site in production configuration'
	set -gx JEKYLL_ENV 'production'
    jekyll build
    octopress deploy
    set -gx JEKYLL_ENV 'development'
end

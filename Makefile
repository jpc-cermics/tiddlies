
all:
	bundle exec jekyll serve 


production:
	JEKYLL_ENV=production bundle exec jekyll build -d public
	rm -fr ../../gitlab/cermics.git/public
	mv public ../../gitlab/cermics.git/public


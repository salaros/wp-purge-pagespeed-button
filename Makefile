PLUGIN_FILE = wp-pagespeed-purge.php

GITHUB_REPO = http://github.com/salaros/wp-purge-pagespeed-button
GIT_TAGS_DIR = ../tags
GIT_TAGS	:= $(shell git tag)
GIT_TAG 	:= $(shell echo $$(git tag | sort -n | tail -1) | perl -pe 's/^((\d+\.)*)(\d+)(.*)$$/$$1.($$3+1).$$4/e')

WP_VER		:= 0.0.0
WP_API_URL  = https://api.wordpress.org/core/version-check/1.7/

TEXTBOLD	:=$(shell tput bold)
TEXTRESET 	:=$(shell tput sgr0)

all: git_tag wp_ver bump

git_tag:
	@printf "Setting plugin version to: $(TEXTBOLD)$(GIT_TAG)$(TEXTRESET)\n"
	@sed -i 's/Stable tag: .*$$/Stable tag: $(GIT_TAG)/g' readme.txt
	@sed -i 's/Version:     .*$$/Version:     $(GIT_TAG)/g' $(PLUGIN_FILE)
	
wp_ver:
	$(eval WP_VER := $(shell curl -s '$(WP_API_URL)' | \
            			python3 -c 'import sys, json; print(json.load(sys.stdin)["offers"][0]["current"])'))
	@printf "Updating WordPress version to: $(TEXTBOLD)$(WP_VER)$(TEXTRESET)\n"
	@sed -i 's/Tested up to: .*$$/Tested up to: $(WP_VER)/g' readme.txt

bump:
	@git add -f readme.txt
	@git add -f $(PLUGIN_FILE)
	@git commit -m "bumping plugin version to $(GIT_TAG)"

sync_tags:
	@{ \
		GIT_TAGS_SYNCHED=0																						;\
		for git_tag in $$(git tag)																				;\
		do																										 \
			if [ ! -d $(GIT_TAGS_DIR)/$${git_tag} ]; then														 \
				printf "\nGit tag $${git_tag} doesn't not exist in SVN tags folder!\n"							;\
				fetch --repo="$(GITHUB_REPO)" --tag="$${git_tag}" --source-path="/" $(GIT_TAGS_DIR)/$${git_tag}	;\
				GIT_TAGS_SYNCHED=$$(expr $$GIT_TAGS_SYNCHED + 1)												;\
			fi																									;\
		done																									;\
		if [ $$GIT_TAGS_SYNCHED -eq 0 ]; then																	 \
			printf "No Git tags to synchronize. Nothing to do, exiting!"										;\
		else																									 \
			printf "\nSynchronized $${GIT_TAGS_SYNCHED} Git tags to SVN, you can run 'svn update' now!"			;\
		fi																										;\
	}

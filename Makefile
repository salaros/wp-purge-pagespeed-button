PLUGIN_FILE = wp-pagespeed-purge.php

WP_VER		:= 0.0.0
WP_API_URL  = https://api.wordpress.org/core/version-check/1.7/

TEXTBOLD		:=$(shell tput bold)
TEXTRESET 		:=$(shell tput sgr0)
SVN_REPO_SLUG	:=$(shell basename $(TRAVIS_BUILD_DIR))

plugin_ver:
	@printf "Setting plugin version to: $(TEXTBOLD)$(TRAVIS_TAG)$(TEXTRESET)\n"
	@sed -i 's/Stable tag: .*$$/Stable tag: $(TRAVIS_TAG)/g' readme.txt
	@sed -i 's/Version:     .*$$/Version:     $(TRAVIS_TAG)/g' $(PLUGIN_FILE)

wp_ver:
	$(eval WP_VER := $(shell curl -s '$(WP_API_URL)' | \
            			python3 -c 'import sys, json; print(json.load(sys.stdin)["offers"][0]["current"])'))
	@printf "Updating WordPress version to: $(TEXTBOLD)$(WP_VER)$(TEXTRESET)\n"
	@sed -i 's/Tested up to: .*$$/Tested up to: $(WP_VER)/g' readme.txt

svn_clone:
	@mkdir -pv $(TRAVIS_BUILD_DIR)/svn
	@svn co -q https://plugins.svn.wordpress.org/$(SVN_REPO_SLUG)/ $(TRAVIS_BUILD_DIR)/svn/$(SVN_REPO_SLUG)

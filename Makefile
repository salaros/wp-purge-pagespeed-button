PLUGIN_FILE = wp-pagespeed-purge.php

WP_VER		:= 0.0.0
WP_API_URL  = https://api.wordpress.org/core/version-check/1.7/

ifeq ($(strip $(TRAVIS_BUILD_DIR)),)
TRAVIS_BUILD_DIR :=$(shell pwd -L)
endif

ifeq ($(strip $(TRAVIS_TAG)),)
TRAVIS_TAG :=$(shell git describe --tags `git rev-list --tags --max-count=1` )
endif

TEXTBOLD	:=$(shell tput bold)
TEXTRESET	:=$(shell tput sgr0)
PLUGIN_SLUG	:=$(shell basename $(TRAVIS_BUILD_DIR))

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
	@svn co -q https://plugins.svn.wordpress.org/$(PLUGIN_SLUG)/ $(TRAVIS_BUILD_DIR)/svn/$(PLUGIN_SLUG)

gettext:
	# Generating ./languages/$(PLUGIN_SLUG).pot
	@git ls-files | grep -e \.php$ | xargs xgettext \
		-k_e -k__ -ktranslate -kappend -kesc_attr_ -kesc_attr__ -kesc_attr_e -kesc_attr_x -kesc_attr_x:1,2c -kesc_html__ -kesc_html_e -kesc_html_x \
		--from-code utf-8 --omit-header -o - -L PHP --no-wrap | tee ./languages/${PLUGIN_SLUG}.pot

	@echo -e '\n'
	# Refreshing .po files using .pot file
	@find . -name \*.po -execdir sh -c 'echo $$0; msgmerge -N -o "$$0" "$$0" ${PLUGIN_SLUG}.pot' '{}' \;

	@echo -e '\n'
	# Compiling .po files with gettext
	@find . -name \*.po -execdir sh -c 'echo $$0; msgfmt --verbose "$$0" -o `basename $$0 .po`.mo' '{}' \;

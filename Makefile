PLUGIN_FILE = wp-pagespeed-purge.php

GIT_TAG 	:= $(shell git tag | sort -n | tail -1)

WP_VER		:= 0.0.0
WP_API_URL  = https://api.wordpress.org/core/version-check/1.7/

TEXTBOLD	:=$(shell tput bold)
TEXTRESET 	:=$(shell tput sgr0)

all: git_tag wp_ver

git_tag:
	@printf "Setting plugin version to: $(TEXTBOLD)$(GIT_TAG)$(TEXTRESET)\n"
	@sed -i 's/Stable tag: .*$$/Stable tag: $(GIT_TAG)/g' readme.txt
	@sed -i 's/Version:     .*$$/Version:     $(GIT_TAG)/g' $(PLUGIN_FILE)
	
wp_ver:
	$(eval WP_VER := $(shell curl -s '$(WP_API_URL)' | \
            			python3 -c 'import sys, json; print(json.load(sys.stdin)["offers"][0]["current"])'))
	@printf "Updating WordPress version to: $(TEXTBOLD)$(WP_VER)$(TEXTRESET)\n"
	@sed -i 's/Tested up to: .*$$/Tested up to: $(WP_VER)/g' readme.txt

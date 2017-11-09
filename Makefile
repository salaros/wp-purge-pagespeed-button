GIT_TAG		:= $(shell git tag | sort -n | tail -1)
WP_VER		:= $(shell curl -s 'https://api.wordpress.org/core/version-check/1.7/' | \
            			python3 -c 'import sys, json; print(json.load(sys.stdin)["offers"][0]["current"])')
TEXTBOLD	:=$(shell tput bold)
TEXTRESET 	:=$(shell tput sgr0)

all: git_tag wp_ver

git_tag:
	@printf "Setting plugin version to: $(TEXTBOLD)$(GIT_TAG)$(TEXTRESET)\n"
	@sed -i 's/Tested up to: .*$$/Tested up to: $(GIT_TAG)/g' readme.txt

wp_ver:
	@printf "Updating WordPress version to: $(TEXTBOLD)$(WP_VER)$(TEXTRESET)\n"
	@sed -i 's/Stable tag: .*$$/Stable tag: $(WP_VER)/g' readme.txt

#!/usr/bin/make -f
PREFIX=$(HOME)
PACKAGES=$(shell find lib opt usr -mindepth 1 -maxdepth 1 -type d)
VERBOSITY=1
STOW=stow --verbose=$(VERBOSITY) --target=$(PREFIX)

.PHONY: help
help:  ## This.
	@perl -ne 'print if /^[a-zA-Z_-]+:.*## .*$$/' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

etc/init:
	make update
	touch $(@)

.PHONY: install
install: etc/init  ## Symlink packages into your ${HOME} and ${DFC} directories
	@for package in $(PACKAGES); do \
		filename=$$(echo $$package | sed 's/\/$$//; s/^.*\///'); \
		directory=$$(echo $$package | sed 's/\/$$//; s/\/.*$$//'); \
		$(STOW) --restow --dir=$$directory $$filename; \
	done

.PHONY: uninstall
uninstall:  ## Remove symlinked packages from your ${HOME} and ${DFC} directories
	@for package in $(PACKAGES); do \
		filename=$$(echo $$package | sed 's/\/$$//; s/^.*\///'); \
		directory=$$(echo $$package | sed 's/\/$$//; s/\/.*$$//'); \
		$(STOW) --delete --dir=$$directory $$filename; \
	done

.PHONY: update
update:  ## Update the core code and all submodules
	git fetch origin --prune
	git rebase origin/dev
	git submodule init
	git submodule update --recursive

#!/usr/bin/make -f
PREFIX=$(HOME)
SHELL=sh
PACKAGES=$(shell grep -v '^\#' .requirements/stow.txt)
VERBOSITY=1
STOW=stow --verbose=$(VERBOSITY) --target=$(PREFIX)

.PHONY: backup
backup:  ## Backup common configuration files
	mkdir $(HOME)/.config/backup
	mv -f $(HOME)/.bashrc $(HOME)/.bash_profile $(HOME)/.bash_history $(HOME)/.bash_logout $(HOME)/.profile $(HOME)/.config/backup/ || true

.PHONY: install
install:  ## Stow/symlinked packages into your ${HOME} directory
	@for package in $(PACKAGES); do \
		filename=$$(echo $$package | sed 's/\/$$//; s/^.*\///'); \
		$(STOW) --restow $$filename; \
	done

.PHONY: install.update-requirements
install.update-requirements:  # Update the list of stowed packages to match directory contents
	find . -maxdepth 1 -mindepth 1 -type d ! -path '.\/.*' | sed 's/^..//' | sort > .requirements/stow.txt

.PHONY: uninstall
uninstall:  ## Remove symlinked packages from your ${HOME} and ${DFC} directories
	@for package in $(PACKAGES); do \
		filename=$$(echo $$package | sed 's/\/$$//; s/^.*\///'); \
		$(STOW) --delete $$filename; \
	done

.PHONY: update
update:  ## Update the core code and all submodules
	git fetch origin --prune
	git rebase origin/master
	git submodule init
	git submodule update --recursive

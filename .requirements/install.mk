#!/usr/bin/make -f
SHELL=sh
PACKAGES=$(shell grep -v '^\#' .requirements/stow.txt)
STOW=stow
_install_xdg_paths=XDG_DESKTOP_DIR XDG_DOWNLOAD_DIR XDG_TEMPLATES_DIR XDG_PUBLICSHARE_DIR XDG_DOCUMENTS_DIR XDG_MUSIC_DIR XDG_PICTURES_DIR XDG_VIDEOS_DIR
BACKUP_PATHS=$(HOME)/.config/user-dirs.dirs $(HOME)/.config/user-dirs.locale $(HOME)/Downloads $(HOME)/Desktop $(HOME)/Templates $(HOME)/Music $(HOME)/Videos $(HOME)/Pictures $(HOME)/Public $(HOME)/Documents $(HOME)/.dmrc $(HOME)/.wget-hsts $(HOME)/.bash_history $(HOME)/.sudo_as_admin_successful

.PHONY: backup
backup:  ## Backup common configuration files
	mkdir $(HOME)/.config/backup || true
	mv -f $(BACKUP_PATHS) $(HOME)/.bashrc $(HOME)/.bash_profile $(HOME)/.bash_history $(HOME)/.bash_logout $(HOME)/.profile $(HOME)/.config/backup/ || true

.PHONY: install
install:  ## Stow/symlinked packages into your ${HOME} directory
	@for package in $(PACKAGES); do \
		filename=$$(echo $$package | sed 's/\/$$//; s/^.*\///'); \
		$(STOW) --restow $$filename || exit 1; \
	done
	@make install.user-dirs

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
	git fetch origin --prune || true
	git rebase origin/master
	git submodule init
	git submodule update --recursive

.PHONY: install.user-dirs
install.user-dirs:  ## Create untracked user directories
	. shells/.config/sh/xdg \
	&& for path in $(_install_xdg_paths); do \
		eval 'test -e $$'$${path} || eval 'mkdir -p $$'$${path}; \
	done \
	&& for path in sh bash zsh; do \
		if [ ! -e $${XDG_STATE_HOME}/$${path} ]; then \
			mkdir -p $${XDG_STATE_HOME}/$${path}; \
		fi \
	done \
	&& for path in less; do \
		if [ ! -e $${XDG_CACHE_HOME}/$${path} ]; then \
			mkdir -p $${XDG_CACHE_HOME}/$${path}; \
		fi \
	done \
	&& for path in freecad; do \
		if [ ! -e $${XDG_CONFIG_HOME}/$${path} ]; then \
			mkdir -p $${XDG_CONFIG_HOME}/$${path}; \
		fi \
	done \
	;

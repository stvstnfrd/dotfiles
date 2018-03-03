#!/usr/bin/make -f
PREFIX=$(HOME)
PACKAGES=$(shell find . -maxdepth 1 -mindepth 1 -type d ! -path '.\/.*' | sed 's/^..//' | sort)
VERBOSITY=1
STOW=stow --verbose=$(VERBOSITY) --target=$(PREFIX)
SUDO=sudo
DOTFILES=/home/vagrant/dotfiles
APT_PACKAGES=python-dev python-setuptools git zsh curl stow python-pip build-essential virtualenvwrapper

.PHONY: help
help:  ## This.
	@perl -ne 'print if /^[a-zA-Z_-]+:.*## .*$$/' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: install
install:  ## Stow/symlinked packages into your ${HOME} directory
	@for package in $(PACKAGES); do \
		filename=$$(echo $$package | sed 's/\/$$//; s/^.*\///'); \
		$(STOW) --restow $$filename; \
	done

.PHONY: system
system:  ## Install system packages (linux only)
	$(SUDO) apt-get update
	$(SUDO) apt-get install -y $(APT_PACKAGES)
	$(SUDO) apt-get autoremove -y

.PHONY: uninstall
uninstall:  ## Remove symlinked packages from your ${HOME} and ${DFC} directories
	@for package in $(PACKAGES); do \
		filename=$$(echo $$package | sed 's/\/$$//; s/^.*\///'); \
		$(STOW) --delete $$filename; \
	done

.PHONY: update
update:  ## Update the core code and all submodules
	git fetch origin --prune
	git rebase origin/v1
	git submodule init
	git submodule update --recursive

.PHONY: vagrant
vagrant:  ## Perform vagrant tasks
	rm /home/vagrant/.profile || true
	rm /home/vagrant/.bashrc || true
	rm /home/vagrant/.bash_logout || true
	usermod -s /usr/bin/zsh vagrant
	hostname dotfiles
	cd $(DOTFILES) && sudo -u vagrant -H make install

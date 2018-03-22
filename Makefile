#!/usr/bin/make -f
PREFIX=$(HOME)
PACKAGES=$(shell find . -maxdepth 1 -mindepth 1 -type d ! -path '.\/.*' | sed 's/^..//' | sort)
VERBOSITY=1
STOW=stow --verbose=$(VERBOSITY) --target=$(PREFIX)
APT_PACKAGES=curl git pass stow zsh python-dev python-setuptools python-pip build-essential virtualenv
BREW_PACKAGES=curl git pass stow zsh
PYTHON_PACKAGES=ansible ptpython virtualenvwrapper

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

.PHONY: nix
nix:  # Install nix package manager
	sh .requirements/nix.sh
	. ~/.nix-profile/etc/profile.d/nix.sh
	nix-env -i git vim curl stow zsh bash

.PHONY: python
python:  ## Install python packages
	virtualenv $(HOME)/.local
	pip install --upgrade pip
	pip install $(PYTHON_PACKAGES)

.PHONY: ubuntu
ubuntu:  ## Install system packages (linux only)
	apt-get update
	apt-get install -y $(APT_PACKAGES)
	apt-get autoremove -y

.PHONY: mac
mac:  ## Install MacOS packages via brew
	brew update
	brew install $(BREW_PACKAGES)

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

.PHONY: vagrant
vagrant: ubuntu  ## Perform vagrant tasks
	rm -f /home/vagrant/.profile
	rm -f /home/vagrant/.bashrc
	rm -f /home/vagrant/.bash_logout
	rm -f /home/vagrant/.sudo_as_admin_successful
	usermod -s /usr/bin/zsh vagrant
	sudo -u vagrant -H make -C /home/vagrant/.dotfiles install

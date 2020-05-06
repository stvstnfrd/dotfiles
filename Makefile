#!/usr/bin/make -f
PREFIX=$(HOME)
PACKAGES=$(shell find . -maxdepth 1 -mindepth 1 -type d ! -path '.\/.*' | sed 's/^..//' | sort)
VERBOSITY=1
STOW=stow --verbose=$(VERBOSITY) --target=$(PREFIX)
APT_PACKAGES=$(shell cat .requirements/apt.txt)
BREW_CASKS=$(shell cat .requirements/cask.txt)
NIX_PACKAGES=$(shell cat .requirements/nix.txt)
PIP_PACKAGES=$(shell cat .requirements/pip.txt)
# gfortran ## needed for scipy
# https://download.virtualbox.org/virtualbox/5.2.24/VirtualBox-5.2.24-128163-OSX.dmg
# nixpkgs.newsboat

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
	nix-env -iA $(NIX_PACKAGES)

.PHONY: python
python:  ## Install python packages
	curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
	python /tmp/get-pip.py --user
	pip install --upgrade pip
	pip install --user $(PIP_PACKAGES)

UNAME_S := $(shell uname -s)
.PHONY: system
system: python  ## Install system packages
# Ideally, we'd branch on command availability
ifeq ($(UNAME_S),Darwin)
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
	brew update
	brew install caskroom/cask/brew-cask 2> /dev/null
	brew cask install $(BREW_CASKS)
else
	apt-get update --yes
	apt-get upgrade --yes
	apt-get dist-upgrade --yes
	apt-get install --yes $(APT_PACKAGES)
	apt-get autoremove --yes
endif

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

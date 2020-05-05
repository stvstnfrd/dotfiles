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

APT_EXISTS=$(shell command -v apt 2>&1 >/dev/null && echo 1 || echo 0)
BREW_EXISTS=$(shell command -v brew 2>&1 >/dev/null && echo 1 || echo 0)
NIX_EXISTS=$(shell test -e /nix 2>&1 >/dev/null && echo 1 || echo 0)
PIP_EXISTS=$(shell command -v pip 2>&1 >/dev/null && echo 1 || echo 0)
UNAME_S := $(shell uname -s)

.PHONY: help
help:  ## This.
	@perl -ne 'print if /^[a-zA-Z_.-]+:.*## .*$$/' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: backup
backup:  ## Backup common configuration files
	mkdir $(HOME)/.config/backup
	mv -f $(HOME)/.bashrc $(HOME)/.bash_profile $(HOME)/.bash_history $(HOME)/.bash_logout $(HOME)/.profile $(HOME)/.config/backup/ || true

.PHONY: docker
docker:  ## Build a docker container
	docker build -t dotfiles:latest .

docker-bash: docker  ## Start a container in a bash shell
	docker run --rm -it --name dotfiles dotfiles:latest bash --login

docker-zsh: docker  ## Start a container in a zsh shell
	docker run --rm -it --name dotfiles dotfiles:latest zsh --login

docker-sh: docker  ## Start a container in a POSIX shell
	docker run --rm -it --name dotfiles dotfiles:latest sh --login

.PHONY: install
install:  ## Stow/symlinked packages into your ${HOME} directory
	@for package in $(PACKAGES); do \
		filename=$$(echo $$package | sed 's/\/$$//; s/^.*\///'); \
		$(STOW) --restow $$filename; \
	done

.PHONY: system
system: system.apt  ## Bootstrap and install system packages
	make system.brew
	make system.nix
	make system.pip

.PHONY: system.apt
system.apt:  ## Install apt packages
ifeq ($(APT_EXISTS),1)
	apt-get update --yes
	apt-get upgrade --yes
	apt-get dist-upgrade --yes
	apt-get install --yes $(APT_PACKAGES)
	apt-get autoremove --yes
endif

.PHONY: system.brew
system.brew: system.brew.bootstrap  ## Install brew packages
ifeq ($(UNAME_S),Darwin)
	brew update
	brew install caskroom/cask/brew-cask 2> /dev/null
	brew cask install $(BREW_CASKS)
endif

.PHONY: system.brew.bootstrap
system.brew.bootstrap:  ## Bootstrap brew packages
ifeq ($(UNAME_S),Darwin)
ifeq ($(BREW_EXISTS),0)
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
endif
endif

.PHONY: system.nix
system.nix: system.nix.bootstrap  ## Install nix packages
	. $(HOME)/.nix-profile/etc/profile.d/nix.sh && nix-env -iA $(NIX_PACKAGES)

.PHONY: system.nix.bootstrap
system.nix.bootstrap:  ## Bootstrap nix packages
ifeq ($(NIX_EXISTS),0)
	test -e /nix || mkdir -m 0755 /nix && chown root /nix
	groupadd -r nixbld
	for n in $$(seq 1 10); do \
	    useradd -c "Nix build user $$n" \
	    -d /var/empty -g nixbld -G nixbld -M -N -r -s "$$(which nologin)" nixbld$$n; done
	curl -L https://nixos.org/nix/install | sudo sh
endif
	. $(HOME)/.nix-profile/etc/profile.d/nix.sh

.PHONY: system.pip
system.pip: system.pip.bootstrap  ## Install pip packages
	pip install --upgrade pip
	pip install --user $(PIP_PACKAGES)

.PHONY: system.pip.bootstrap
system.pip.bootstrap:  ## Bootstrap pip packages
ifeq ($(PIP_EXISTS),0)
	curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
	python3 /tmp/get-pip.py --user
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

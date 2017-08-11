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

.PHONY: prerequisites
prerequisites:  ## Install required system packages
	$(SUDO) apt-get update
	$(SUDO) apt-get install -y $(APT_PACKAGES)
	$(SUDO) apt-get autoremove -y
	rm /home/vagrant/.profile || true
	rm /home/vagrant/.bashrc || true
	rm /home/vagrant/.bash_logout || true
	test -e $(HOME)/dotfiles || \
		sudo -u vagrant -H git clone --recursive https://github.com/stvstnfrd/dotfiles.git $(DOTFILES)
	cd $(DOTFILES) && sudo -u vagrant -H git checkout v1
	cd $(DOTFILES) && sudo -u vagrant -H git submodule init
	cd $(DOTFILES) && sudo -u vagrant -H git submodule update --recursive
	cd $(DOTFILES) && sudo -u vagrant -H make install
	hostname demo
	usermod -s /usr/bin/zsh vagrant
	# $(SUDO) pip install --upgrade pip
	# $(SUDO) pip install --upgrade virtualenv virtualenvwrapper
	# $(SUDO) pip install --upgrade ansible
	# easy_install pip
	# sudo -u vagrant -H git clone https://github.com/alanctkc/dotfiles.git /home/vagrant/.config/dotfiles
	# pushd /home/vagrant/.config/dotfiles
	# sudo -u vagrant -H ./bootstrap.sh --no-i3 --git-name "Vagrant User" --git-email vagrant@example.com
	# sudo -u vagrant -H ./bootstrap.sh --delete-backups
	# popd

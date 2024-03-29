#!/usr/bin/make -f
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
# https://download.virtualbox.org/virtualbox/5.2.24/VirtualBox-5.2.24-128163-OSX.dmg
BREW_CASKS ?= alfred caskroom/versions/firefox-developer-edition docker robo-3t save-hollywood sequel-pro slack spectacle thunderbird vlc zoomus
BREW_EXISTS=$(shell command -v brew 2>&1 >/dev/null && echo 1 || echo 0)

.PHONY: system.brew
system.brew: system.brew.bootstrap  ## Install brew packages
	brew update
	brew install caskroom/cask/brew-cask 2> /dev/null
	brew cask install $(BREW_CASKS)

.PHONY: system.brew.bootstrap
system.brew.bootstrap:  ## Bootstrap brew packages
ifeq ($(BREW_EXISTS),0)
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
endif
else
.PHONY: system.brew
system.brew:  ## Install brew packages
	-echo 'Nothing to do on non-OSX systems...'
endif

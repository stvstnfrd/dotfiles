#!/usr/bin/make -f
NIX_EXISTS=$(shell test -e /nix 2>&1 >/dev/null && echo 1 || echo 0)
NIX_PACKAGES=nixpkgs.myPackages
# NIX_DAEMON ?= --no-daemon  # uncomment to enable single-user
NIX_DAEMON ?= --daemon  # default to multi-user

.PHONY: system.nix
system.nix: system.nix.bootstrap  ## Install nix packages
ifeq (,$(wildcard $(HOME)/.config/nixpkgs/config.nix))
	mkdir -p $(HOME)/.config/nixpkgs
	cp nix/.config/nixpkgs/config.nix $(HOME)/.config/nixpkgs/config.nix
endif
	PATH="$${HOME}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$${PATH}" \
	nix-env -iA $(NIX_PACKAGES)

.PHONY: system.nix.bootstrap
system.nix.bootstrap:  ## Bootstrap nix packages
ifeq ($(NIX_EXISTS),0)
	curl -L https://nixos.org/nix/install > /tmp/nix-install.sh
	sh /tmp/nix-install.sh $(NIX_DAEMON)
endif

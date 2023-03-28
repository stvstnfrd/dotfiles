#!/usr/bin/make -f
NIX_EXISTS=$(shell test -e /nix 2>&1 >/dev/null && echo 1 || echo 0)
NIX_PACKAGES=$(shell grep -v '^\#' .requirements/nix.txt)
# NIX_DAEMON ?= --no-daemon  # uncomment to enable single-user
NIX_DAEMON ?= --daemon  # default to multi-user

.PHONY: system.nix
system.nix: system.nix.bootstrap  ## Install nix packages
	NIXPKGS_ALLOW_UNFREE=1 nix-env -iA $(NIX_PACKAGES)

.PHONY: system.nix.bootstrap
system.nix.bootstrap:  ## Bootstrap nix packages
ifeq ($(NIX_EXISTS),0)
	curl -L https://nixos.org/nix/install > /tmp/nix-install.sh
	sh /tmp/nix-install.sh $(NIX_DAEMON)
endif

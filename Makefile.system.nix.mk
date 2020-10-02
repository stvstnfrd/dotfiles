#!/usr/bin/make -f
NIX_EXISTS=$(shell test -e /nix 2>&1 >/dev/null && echo 1 || echo 0)
NIX_PACKAGES=$(shell cat .requirements/nix.txt)

.PHONY: system.nix
system.nix: system.nix.bootstrap  ## Install nix packages
	. $(HOME)/.nix-profile/etc/profile.d/nix.sh && nix-env -iA $(NIX_PACKAGES)

.PHONY: system.nix.bootstrap
system.nix.bootstrap:  ## Bootstrap nix packages
ifeq ($(NIX_EXISTS),0)
	curl -L https://nixos.org/nix/install > /tmp/nix-install.sh
	sh /tmp/nix-install.sh
endif
	. $(HOME)/.nix-profile/etc/profile.d/nix.sh

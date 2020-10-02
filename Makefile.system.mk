#!/usr/bin/make -f
.PHONY: system
system: system.apt  ## Bootstrap and install system packages
	make system.brew
	make system.nix
	make system.pip

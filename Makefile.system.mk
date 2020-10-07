#!/usr/bin/make -f
.PHONY: system
system:  ## Bootstrap and install system packages
	sudo make system.apt
	make system.brew
	make system.nix
	make system.pip

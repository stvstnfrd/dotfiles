#!/usr/bin/make -f
.PHONY: configure.harden
configure.harden:  ## Harden local configuration
	sudo systemctl disable lightdm.service || true
	sudo systemctl disable lightdm || true
	sudo ufw enable || true

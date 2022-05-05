#!/usr/bin/make -f
.PHONY: configure.harden
configure.harden:  ## Harden local configuration
	sudo ufw enable || true
	sudo ufw allow ssh comment 'ssh' || true
	sudo ufw allow proto tcp from 192.168.0.0/24 port 24800 to 192.168.0.0/24 port 24800 comment 'barrier-kvm' || true
	sudo ufw allow proto tcp from port 8123 to port 8123 comment 'home-assistant' || true
	sudo systemctl disable lightdm.service || true
	sudo systemctl disable lightdm || true
	sudo systemctl set-default multi-user.target || true
	sudo sed -i.bak 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*$/# &/' /etc/default/grub || true
	echo 'GRUB_CMDLINE_LINUX_DEFAULT="text"' \
	| sudo tee -a /etc/default/grub GRUB_CMDLINE_LINUX_DEFAULT="text" || true
	sudo update-grub || true

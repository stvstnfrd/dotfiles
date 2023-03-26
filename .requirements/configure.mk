#!/usr/bin/make -f
.PHONY: configure.harden
configure.harden:  ## Harden local configuration
	sudo ufw enable || true
	sudo systemctl disable lightdm.service || true
	sudo systemctl disable lightdm || true
	sudo systemctl set-default multi-user.target || true
	sudo sed -i.bak 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*$/# &/' /etc/default/grub || true
	echo 'GRUB_CMDLINE_LINUX_DEFAULT="text"' \
	| sudo tee -a /etc/default/grub GRUB_CMDLINE_LINUX_DEFAULT="text" || true
	sudo update-grub || true

configure.hardware:  ## Configure hardware
ifneq (,$(wildcard /etc/udev/hwdb.d))
	make /etc/udev/hwdb.d/90-thinkpad-keys.hwdb
	sudo udevadm hwdb --update
endif

/etc/udev/hwdb.d/90-thinkpad-keys.hwdb: root/etc/udev/hwdb.d/90-thinkpad-keys.hwdb
	sudo cp "$(<)" "$(@)"

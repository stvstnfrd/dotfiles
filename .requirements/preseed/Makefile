ISO_INPUT=$(HOME)/.local/share/downloads/xubuntu-20.04.2.0-desktop-amd64.iso
MOUNT_POINT_RO=mnt/ro
MOUNT_POINT_TARGET=$(MOUNT_POINT_RO)/ubuntu
MOUNT_POINT_RW=mnt/rw
MOUNT_POINT_RW_TARGET=$(MOUNT_POINT_RW)/ubuntu
ISO_OUTPUT=dist/disc.iso
SEED_OUTPUT=$(MOUNT_POINT_RW)/preseed/unattended.seed
TXT_CFG_OUTPUT=$(MOUNT_POINT_RW)/isolinux/txt.cfg
GRUB_CFG_OUTPUT=$(MOUNT_POINT_RW)/boot/grub/grub.cfg
ISOLINUX_CFG_OUTPUT=$(MOUNT_POINT_RW)/isolinux/isolinux.cfg

$(ISO_OUTPUT): $(SEED_OUTPUT) $(ISOLINUX_CFG_OUTPUT)
	@mkisofs \
		-r \
		-V "Custom Xubuntu Install CD" \
		-cache-inodes \
		-quiet \
		-J \
		-l \
		-b isolinux/isolinux.bin \
		-c isolinux/boot.cat \
		-no-emul-boot \
		-boot-load-size 4 \
		-boot-info-table \
		-o "$(@)" \
		"$(MOUNT_POINT_RW)" \
	;
	@printf '\n\n'
	@printf 'Username: %s\n' "$(USERNAME)"
	@printf 'Password: %s\n' "$(PASSWORD)"

USERNAME:=dude
PASSWORD:=$(shell apg | head -1)
PASSWORD_ENC:=$(shell printf "$(PASSWORD)" | mkpasswd -m sha-512 --stdin)

$(SEED_OUTPUT): src/preseed.cfg $(MOUNT_POINT_RW_TARGET)
	sed 's/{{user}}/$(USERNAME)/g; s@{{password}}@$(PASSWORD_ENC)@g' src/preseed.cfg > $(@)

$(ISOLINUX_CFG_OUTPUT): src/isolinux.cfg $(MOUNT_POINT_RW_TARGET)
	cp src/isolinux.cfg $(@)

$(TXT_CFG_OUTPUT): src/txt.cfg $(MOUNT_POINT_RW_TARGET)
	cp src/txt.cfg $(@)

$(GRUB_CFG_OUTPUT): src/grub.cfg $(MOUNT_POINT_RW_TARGET)
	cp src/grub.cfg $(@)

$(MOUNT_POINT_TARGET):
	test -d "$(MOUNT_POINT_RO)" || mkdir -p "$(MOUNT_POINT_RO)"
	test -d "$(@)" || sudo mount -o loop "$(ISO_INPUT)" $(MOUNT_POINT_RO)

$(MOUNT_POINT_RW_TARGET): $(MOUNT_POINT_TARGET)
	test -d "$(MOUNT_POINT_RW)" || mkdir -p "$(MOUNT_POINT_RW)"
	cd "$(MOUNT_POINT_RO)" && \
		tar cf - . | \
		(cd "../rw"; tar xfp -)
	sudo chown -R "$(USER)" "$(MOUNT_POINT_RW)"
	chmod -R u+w "$(MOUNT_POINT_RW)"

.PHONY: clean
clean:
	test -d "$(MOUNT_POINT_TARGET)" && sudo umount "$(MOUNT_POINT_RO)" || true
	test -d "$(MOUNT_POINT_TARGET)" && rm -rf "$(MOUNT_POINT_RW)" || true
	test -e "$(ISO_OUTPUT)" && rm "$(ISO_OUTPUT)" || true

SHELL=bash
OPENEDX_RELEASE=open-release/koa.master
URL_GIT_BASE=https://raw.githubusercontent.com/edx/configuration/nedbat/better-decoding
URL_INSTALL_BASE=$(URL_GIT_BASE)/util/install
URL_NATIVE_SH=$(URL_INSTALL_BASE)/native.sh
URL_GENERATE_PASSWORDS=$(URL_INSTALL_BASE)/generate-passwords.sh
URL_ANSIBLE_BOOTSTRAP=$(URL_INSTALL_BASE)/ansible-bootstrap.sh
URL_PASSWORDS_YML=$(URL_GIT_BASE)/playbooks/sample_vars/passwords.yml
INSTALL_SCRIPTS=bin/native.sh bin/ansible-bootstrap.sh bin/generate-passwords.sh
INSTALL_ETC=etc/config.yml etc/my-passwords.yml
LMS_BASE=127.0.0.1
CMS_BASE=studio.$(LMS_BASE)
define CONFIG_YML
EDXAPP_LMS_BASE: '$(LMS_BASE)'
EDXAPP_CMS_BASE: '$(CMS_BASE)'
endef
export CONFIG_YML

.PHONY: all
build: bin
	vagrant up --provision

.PHONY: clean
clean:
	vagrant halt
	vagrant destroy --force
	rm -f -- $(INSTALL_SCRIPTS)

.PHONY: stop
stop:
	vagrant halt

.PHONY: ssh
ssh:
	vagrant ssh

.PHONY: bin
bin: $(INSTALL_SCRIPTS)

bin/ansible-bootstrap.sh:
	wget "$(URL_ANSIBLE_BOOTSTRAP)" -O "$(@)" || rm "$(@)"

bin/generate-passwords.sh:
	wget "$(URL_GENERATE_PASSWORDS)" -O "$(@)" || rm "$(@)"

bin/native.sh:
	wget "$(URL_NATIVE_SH)" -O "$(@)" || rm "$(@)"

.PHONY: etc
etc:
	test -d etc || mkdir etc
	$(MAKE) $(INSTALL_ETC)

etc/config.yml:
	test -d etc || mkdir etc
	echo "$${CONFIG_YML}" > "$(@)"

etc/my-passwords.yml: etc/passwords.yml
	test -d etc || mkdir etc
	while IFS= read -r line; do \
		[ "$${line}" = *SECRET_KEY* ] && length=100 || length=35; \
		REPLACE=$$(LC_ALL=C < /dev/urandom tr -dc 'A-Za-z0-9' | head -c$${length}); \
		echo "$${line}" | sed "s/\!\!null.*/\'$${REPLACE}\'/"; \
	done < "$(^)" > "$(@)"

etc/passwords.yml:
	wget -q "$(URL_PASSWORDS_YML)" -O "$(@)" || rm "$(@)"

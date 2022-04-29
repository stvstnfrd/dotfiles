#!/usr/bin/make -f
# gfortran needed for scipy
ALL_CFG=$(wildcard .requirements/deb/*-*.cfg)
ALL_DEB=$(addsuffix _all.deb,$(addprefix .requirements/deb/its-package_$(CURRENT_VERSION)~,$(notdir $(basename $(ALL_CFG)))))
lsb_release = $(shell $(SHELL) -c '. /etc/os-release; echo "$$$(1)"')
OS=$(call lsb_release,ID)
VERSION=$(call lsb_release,VERSION_CODENAME)
CURRENT_VERSION=$(shell \
	grep '^Version:' .requirements/deb/package.cfg \
	| sed 's/^.*: *//' \
)
APT_META_PACKAGE=its-package_$(CURRENT_VERSION)~$(OS)-$(VERSION)_all.deb
APT_EXISTS=$(shell command -v apt 2>&1 >/dev/null && echo 1 || echo 0)
ifeq ($(APT_EXISTS),1)
APT_INSTALL ?= 1
APT_PACKAGES=$(shell grep -v '^\#' .requirements/apt.txt)
APT_PACKAGES_GUI=$(shell grep -v '^\#' .requirements/apt.gui.txt)
ifneq ($(DISPLAY),)
APT_INSTALL_GUI ?= 1
else
APT_INSTALL_GUI ?= 0
endif
APT_UPDATE ?= 0
CURL=curl
EUID ?= $(shell id -u)
ifneq ($(EUID),0)
SUDO=sudo
else
SUDO=
endif

.PHONY: system.apt
system.apt: $(ALL_DEB)  ## Install apt packages
	$(SUDO) apt-get update --yes
ifeq ($(APT_UPDATE),1)
	$(SUDO) apt-get upgrade --yes
	$(SUDO) apt-get dist-upgrade --yes
endif
ifeq ($(APT_INSTALL),1)
	$(SUDO) apt-get remove its-package --yes || true
	cd .requirements/deb && $(SUDO) apt-get install --yes ./'$(APT_META_PACKAGE)'
endif
ifeq ($(APT_INSTALL_GUI),1)
	$(SUDO) apt-get install --yes $(APT_PACKAGES_GUI)
endif
ifeq ($(APT_INSTALL),1)
	$(SUDO) apt-get autoremove --yes
endif

.requirements/deb/package.cfg: .requirements/packages.tsv .requirements/apt.mk
	package_version="$$( \
		git log --oneline -- "$(<)" \
		| ./shells/.local/bin/conventional-commits-to-semantic-version \
		| tail -1 \
		| awk '{ print $$1 }' \
	)"; \
	sed "s/^Version:.*\$$/Version: $${package_version}/" "$(@)" \
	>'$(@).new'; \
	if [ "$(CURRENT_VERSION)" != "$${package_version}" ]; \
	then \
		mv '$(@).new' '$(@)'; \
	else \
		rm '$(@).new'; \
	fi

$(ALL_CFG): .requirements/packages.tsv .requirements/deb/package.cfg
	@get_column() { \
		cat "$${1}" \
			| grep "^$${2}	" \
			| sed "s/^$${2}	//" \
			| cut -d'	' -f$${3} \
			| grep -v '^[ \t]*\$$' \
			| xargs \
			| tr ' ' ',' \
		; \
	} ; \
	basename=$(basename $(notdir $(@))); \
	os="$$(echo "$${basename}" | cut -d'-' -f1)"; \
	version="$$(echo "$${basename}" | cut -d'-' -f2)"; \
	ini_column=1; \
	if [ "$${version}" = 'impish' ]; then ini_column=2; fi ; \
	if [ "$${version}" = 'jammy' ]; then ini_column=2; fi ; \
	if [ "$${version}" = 'sid' ]; then ini_column=2; fi ; \
	if [ "$${version}" = 'bionic' ]; then ini_column=1; fi ; \
	if [ "$${version}" = 'bullseye' ]; then ini_column=1; fi ; \
	if [ "$${version}" = 'buster' ]; then ini_column=1; fi ; \
	shall_packages="$$(get_column $(<) SHALL $${ini_column})"; \
	should_packages="$$(get_column $(<) SHOULD $${ini_column})"; \
	may_packages="$$(get_column $(<) MAY $${ini_column})"; \
	sed \
		-e "s/^Depends:.*$$/Depends: $${shall_packages}/" \
		-e "s/^Recommends:.*$$/Recommends: $${should_packages}/" \
		-e "s/^Suggests:.*$$/Suggests: $${may_packages}/" \
		-e "s/^Version:.*$$/&~$${os}-$${version}/" \
		.requirements/deb/package.cfg \
		>"$(@)" \
	;
	@echo "Rebuilt: $(@)"

.requirements/deb/its-package_$(CURRENT_VERSION)~%_all.deb: .requirements/deb/%.cfg .requirements/apt.mk
	cd "$(dir $(@))" && equivs-build "$(notdir $(<))"

.PHONY: system.apt.deb
system.apt.deb: $(ALL_DEB)
	@echo "Built $(ALL_DEB)"

endif

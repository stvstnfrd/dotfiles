#!/usr/bin/make -f
APT_EXISTS=$(shell command -v apt 2>&1 >/dev/null && echo 1 || echo 0)
ifeq ($(APT_EXISTS),1)
APT_PACKAGES ?= its-package its-package-dev its-package-gui
EUID ?= $(shell id -u)
ifneq ($(EUID),0)
SUDO=sudo
else
SUDO=
endif

/etc/apt/sources.list.d/its-package.list:
	. /etc/os-release \
	&& curl https://raw.githubusercontent.com/stvstnfrd/its-package/master/dist/$${ID}/Bootstrap.sh \
	> bootstrap.sh
	. bootstrap.sh
endif

.PHONY: system.apt
system.apt: /etc/apt/sources.list.d/its-package.list  ## Install apt packages
ifeq ($(APT_EXISTS),1)
	$(SUDO) apt-get update --yes
	$(SUDO) DEBIAN_FRONTEND=noninteractive apt-get install --yes $(APT_PACKAGES)
	$(SUDO) usermod -aG docker "${USER}"
endif

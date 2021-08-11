#!/usr/bin/make -f
# gfortran needed for scipy
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
DOCKER_EXISTS=$(shell command -v docker 2>&1 >/dev/null && echo 1 || echo 0)
EUID ?= $(shell id -u)
ifneq ($(EUID),0)
SUDO=sudo
else
SUDO=
endif

.PHONY: system.apt
system.apt:  ## Install apt packages
ifeq ($(APT_UPDATE),1)
	$(SUDO) apt-get update --yes
	$(SUDO) apt-get upgrade --yes
	$(SUDO) apt-get dist-upgrade --yes
endif
ifeq ($(APT_INSTALL),1)
	$(SUDO) apt-get install --yes $(APT_PACKAGES)
	make system.apt.docker
endif
ifeq ($(APT_INSTALL_GUI),1)
	$(SUDO) apt-get install --yes $(APT_PACKAGES_GUI)
endif
ifeq ($(APT_INSTALL),1)
	$(SUDO) apt-get autoremove --yes
endif

system.apt.docker:  # Install docker apt packages
ifeq ($(DOCKER_EXISTS),0)
	curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
	$(SUDO) sh /tmp/get-docker.sh
endif
	$(SUDO) usermod -aG docker "${USER}"
endif

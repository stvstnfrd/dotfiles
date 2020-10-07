#!/usr/bin/make -f
# gfortran ## needed for scipy
APT_EXISTS=$(shell command -v apt 2>&1 >/dev/null && echo 1 || echo 0)
ifeq ($(APT_EXISTS),1)
APT_INSTALL ?= 1
APT_PACKAGES=$(shell grep -v '^\#' .requirements/apt.txt)
APT_UPDATE ?= 0
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
	$(SUDO) apt-get autoremove --yes
endif
endif

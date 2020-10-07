#!/usr/bin/make -f
# gfortran ## needed for scipy
APT_EXISTS=$(shell command -v apt 2>&1 >/dev/null && echo 1 || echo 0)
ifeq ($(APT_EXISTS),1)
APT_INSTALL ?= 1
APT_PACKAGES=$(shell grep -v '^\#' .requirements/apt.txt)
APT_UPDATE ?= 0
EUID ?= $(shell id -u)

.PHONY: system.apt
system.apt:  ## Install apt packages
ifneq ($(EUID),0)
	echo "Please run as root"
	exit 1
endif
ifeq ($(APT_UPDATE),1)
	apt-get update --yes
	apt-get upgrade --yes
	apt-get dist-upgrade --yes
endif
ifeq ($(APT_INSTALL),1)
	apt-get install --yes $(APT_PACKAGES)
	apt-get autoremove --yes
endif
endif

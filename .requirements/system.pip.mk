#!/usr/bin/make -f
PIP_EXISTS=$(shell command -v pip 2>&1 >/dev/null && echo 1 || echo 0)
PIP_PACKAGES ?= base58 ptpython

.PHONY: system.pip
system.pip:  ## Install pip packages
	PATH="$${HOME}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$${PATH}" \
	pip install --user $(PIP_PACKAGES)

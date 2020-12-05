#!/usr/bin/make -f
PIP_EXISTS=$(shell command -v pip 2>&1 >/dev/null && echo 1 || echo 0)
PIP_PACKAGES=$(shell grep -v '^\#' .requirements/pip.txt)

.PHONY: system.pip
system.pip:  ## Install pip packages
	pip install --user $(PIP_PACKAGES)

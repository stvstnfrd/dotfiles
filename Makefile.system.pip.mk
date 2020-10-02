#!/usr/bin/make -f
PIP_EXISTS=$(shell command -v pip 2>&1 >/dev/null && echo 1 || echo 0)
PIP_PACKAGES=$(shell cat .requirements/pip.txt)

.PHONY: system.pip
system.pip: system.pip.bootstrap  ## Install pip packages
	pip install --user $(PIP_PACKAGES)

.PHONY: system.pip.bootstrap
system.pip.bootstrap:  ## Bootstrap pip packages
ifeq ($(PIP_EXISTS),0)
	curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
	python3 /tmp/get-pip.py --user
	pip install --upgrade pip
endif

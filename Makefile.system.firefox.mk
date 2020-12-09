#!/usr/bin/make -f
FIREFOX_PACKAGES=$(shell grep -v '^\#' .requirements/firefox.txt)

.PHONY: system.firefox.addons
system.firefox.addons:
	@for package in $(FIREFOX_PACKAGES); do \
		echo $$package; \
		filename=$$(echo $$package | sed 's/\/$$//; s/^.*\///'); \
		wget -O "/tmp/addon.xpi" "$$package"; \
		firefox /tmp/addon.xpi; \
		sleep 20s; \
	done

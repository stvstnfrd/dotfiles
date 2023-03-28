#!/usr/bin/make -f
.PHONY: from-scratch
from-scratch:  ## Bootstrap the system from scratch
	$(MAKE) update
	$(MAKE) system
	$(MAKE) backup
	$(MAKE) install
	$(MAKE) configure.harden || true
	$(MAKE) configure.hardware || true

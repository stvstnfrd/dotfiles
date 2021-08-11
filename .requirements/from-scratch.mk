#!/usr/bin/make -f
.PHONY: from-scratch
from-scratch:  ## Bootstrap the system from scratch
	./.requirements/bootstrap.sh

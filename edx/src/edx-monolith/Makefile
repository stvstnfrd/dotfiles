#!/usr/bin/make -f

.PHONY: help
help:  ## This.
	@perl -ne 'print if /^[a-zA-Z_.-]+:.*## .*$$/' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

-include *.mk

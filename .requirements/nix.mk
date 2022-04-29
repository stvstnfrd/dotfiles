#!/usr/bin/make -f
NIX_EXISTS=$(shell test -e /nix 2>&1 >/dev/null && echo 1 || echo 0)
ifneq (,$(wildcard $(HOME)/.config/nixpkgs/config.nix))
NIX_PACKAGES=nixpkgs.myPackages
else ifneq(,$(wildcard nix/.config/nixpkgs/config.nix))
NIX_PACKAGES=$(shell cat nix/.config/nixpkgs/config.nix | awk 'in_paths == 1 && $$0 ~ /^[-_. \ta-zA-Z0-9]+$$/{ print $$1 } /^[ \t]*paths = \[/ {in_paths=1}; /^[ \t]*\]/{in_path=0};')
else
NIX_PACKAGES=nixpkgs.coreutils-full
endif
NIX_DAEMON=--no-daemon  # default to off/single-user
# NIX_DAEMON=--daemon  # uncomment line to enable

.PHONY: system.nix
system.nix: system.nix.bootstrap  ## Install nix packages
	NIXPKGS_ALLOW_UNFREE=1 nix-env -iA $(NIX_PACKAGES)

.PHONY: system.nix.bootstrap
system.nix.bootstrap:  ## Bootstrap nix packages
ifeq ($(NIX_EXISTS),0)
	curl -L https://nixos.org/nix/install > /tmp/nix-install.sh
	sh /tmp/nix-install.sh $(NIX_DAEMON)
endif

.requirements/config.nix: .requirements/packages.tsv
	@get_column() { \
		cat "$${1}" \
			| grep "^$${2}	" \
			| sed "s/^$${2}	//" \
			| cut -d'	' -f$${3} \
			| grep -v '^[ \t]*$$' \
			| tr ' ' ',' \
			| sed 's/^/        &/g' \
			| sed 's/nixpkgs\.//g' \
		; \
	} ; \
	packages=$$({ \
		get_column "$(<)" SHALL 3; \
		get_column "$(<)" SHOULD 3; \
		get_column "$(<)" MAY 3; \
	} \
	| sort \
	); \
	awk \
		--assign packages="$${packages}" \
	' \
	BEGIN { \
		in_paths=0; \
		if (packages == "") { \
			packages="coreutils-full"; \
		} \
	} \
	in_paths == 0 { \
		print \
	} \
	/^[ \t]*paths = \[/{ \
		in_paths=1; \
	} \
	/\];[ \t]*$$/ { \
		in_paths=0; \
		split(packages, _packages); \
		for (i in _packages) { \
			print "        " _packages[i]; \
		} \
		print; \
	} \
	' '$(@)' \
	>'$(@).new' \
	; \
	mv '$(@).new' '$(@)'

nix/.config/nixpkgs/config.nix: .requirements/config.nix
	cp '$(<)' '$(@)'

#!/usr/bin/make -f
FIND_FILES=( \
	find . -type f \
		! -path './.git/*' \
		! -path './mozilla/*' \
		! -path './autoenv/src/*' \
		! -path './cd/src/*' \
		! -path './diff-so-fancy/.config/diff-so-fancy/test/*' \
		! -path './git-hub/src/*' \
		! -path './git-hub/.local/*' \
		! -path './nvm/.config/*' \
		! -path './completion/*' \
		! -path '*/completion.d/*' \
		-print0 \
	| sed --null-data 's/^\.\///' \
)
FIND_FILES_SHEBANG=( \
	$(FIND_FILES) \
	| xargs -0 \
		grep \
			-l \
			--null \
			'^\#!/bin/\(ba\)\?sh' \
)
FIND_FILES_EXTENSION=( \
	$(FIND_FILES) \
	| grep \
		--null-data \
		--null \
		'.*\.\(ba\)\?sh$$' \
)
FIND_FILES_ALL=( \
	( \
		$(FIND_FILES_SHEBANG); \
		$(FIND_FILES_EXTENSION); \
	) \
	| sort --zero-terminated --uniq \
)
LINT_SH_ALL=$(FIND_FILES_ALL) | $(XARGS_SHELLCHECK)
XARGS_SHELLCHECK = xargs -0 --no-run-if-empty shellcheck --external-sources

.PHONY: lint
lint:  ## Run the linter against all files
	$(LINT_SH_ALL)

#!/usr/bin/make -f
FIND_FILES=( \
	find . -type f \
		! -path './.git/*' \
		! -path './.requirements/preseed/*' \
		! -path './completion/*' \
		! -path '*/completion.d/*' \
		! -path './languages/.config/nvm/*' \
		! -path './mozilla/*' \
		! -path './shells/src/z/*' \
		! -path './shells/src/autoenv/*' \
		! -path './shells/.config/dotfiles.d/interactive.d/fzf.*' \
		! -path './version-control/.config/diff-so-fancy/test/*' \
		! -path './version-control/.local/bin/bash+*' \
		! -path './version-control/.local/bin/json*' \
		! -path './version-control/.local/bin/git-hub*' \
		! -path './version-control/src/*' \
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

#!/usr/bin/make -f
FIND_FILES=( \
	find . -type f \
		! -path './.git/*' \
		! -path './.requirements/preseed/*' \
		! -path './mozilla/*' \
		! -path './autoenv/src/*' \
		! -path './cd/src/*' \
		! -path './diff-so-fancy/.config/diff-so-fancy/test/*' \
		! -path './git/.config/diff-so-fancy/test/*' \
		! -path './git/.local/bin/bash+*' \
		! -path './git/.local/bin/json*' \
		! -path './git/.local/bin/git-hub*' \
		! -path './git/src/*' \
		! -path './javascript/.config/nvm/*' \
		! -path './completion/*' \
		! -path '*/completion.d/*' \
		! -path '*/shells/src/z/*' \
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

ifneq (,$(wildcard utils/.local/bin/awk-lint))
AWK_LINT=utils/.local/bin/awk-lint
else ifneq (,$(shell command -v awk-lint 2>/dev/null))
AWK_LINT=awk-lint
endif

.PHONY: lint-awk
lint-awk: $(AWK_FILES)
ifeq (,$(AWK_LINT))
	@echo "Helper script 'lint-awk' missing; cannot continue."
	@exit 1
else
	grep \
		--recursive \
		--binary-files=without-match \
		--files-with-match \
		'^\#!\/usr\/bin\/awk' \
		--null \
	| xargs -0 \
		-n 1 \
		--no-run-if-empty \
		$(AWK_LINT) \
	;
endif

.PHONY: lint
lint: lint-awk  ## Run the linter against all files
	$(LINT_SH_ALL)

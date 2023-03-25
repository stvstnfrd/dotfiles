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

AWK_LINT=$(shell command -v awk-lint >/dev/null 2>&1 && echo awk-lint || echo "echo '\n\ta b c\td ef\n\ng' | awk -f")
AWK_FILES=$(shell grep \
    --recursive \
    --files-with-match \
    '^\#!\/usr\/bin\/awk' \
)

.PHONY: lint-awk
lint-awk: $(AWK_FILES)

.PHONY: $(AWK_FILES)
$(AWK_FILES):
	@$(AWK_LINT) "$(@)"

.PHONY: lint
lint: lint-awk  ## Run the linter against all files
	$(LINT_SH_ALL)

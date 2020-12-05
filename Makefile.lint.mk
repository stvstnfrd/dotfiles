#!/usr/bin/make -f
FIND_ARGS_EXCLUDE = ! -path '*/src/*' ! -path './git-hub/.local/*' !  -path '*/.cache/*' ! -path './nvm/.config/nvm/*' ! -path '*/.git/*' !  -path '*/completion.d/*'
## FIND_ARGS_INCLUDE = \( -name '*.sh' -o -name '*.bash' \)
SH_FILES_DIFF = git diff --name-only -z --diff-filter=AMd $(TRAVIS_BRANCH) HEAD | grep --null --null-data '\.\(ba\)\?sh$$'
## SH_FILES_EXTENSION = find . -type f $(FIND_ARGS_EXCLUDE) $(FIND_ARGS_INCLUDE) -print0
SH_FILES_SHEBANG = find . -type f $(FIND_ARGS_EXCLUDE) -print0 | xargs -0 grep -l --null --null-data '^\#!/bin/\(ba\)\?sh'
XARGS_SHELLCHECK = xargs -0 --no-run-if-empty shellcheck --external-sources
LINT_SH_DIFF = $(SH_FILES_DIFF) | $(XARGS_SHELLCHECK)
## LINT_SH_EXTENSION = $(SH_FILES_EXTENSION) | $(XARGS_SHELLCHECK)
LINT_SH_SHEBANG = $(SH_FILES_SHEBANG) | $(XARGS_SHELLCHECK)

.PHONY: lint
lint:  ## Run the linter against all files
	$(LINT_SH_SHEBANG)

TRAVIS_BRANCH ?= origin/master
.PHONY: lint.diff
lint.diff:  ## Run the linter against files changed since master
	$(LINT_SH_DIFF)

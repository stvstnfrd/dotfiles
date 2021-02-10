#!/bin/zsh
# `export debug=1` to trace who sources who
if [ -n "${debug}" ]; then
    echo 'funk:zsh:profile'
fi
# Pull in the default sh/posix login script
if [ -s "${HOME}/.profile" ]; then
	old_cdm_spawn="${CDM_SPAWN}"
	export CDM_SPAWN=no
	# shellcheck source=shells/.profile
	. "${HOME}/.profile"
	export CDM_SPAWN="${old_cdm_spawn}"
fi
# Perform any zsh-only login tasks here
if [ -e "${HOME}/.config/sh/display" ]; then
	# shellcheck source=shells/.config/sh/display
	. "${HOME}/.config/sh/display"
fi

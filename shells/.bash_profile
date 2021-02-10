#!/bin/bash
if [ -s "${HOME}/.profile" ]; then
	old_cdm_spawn="${CDM_SPAWN}"
    export CDM_SPAWN=no
    # shellcheck source=shells/.profile
    . "${HOME}/.profile"
    export CDM_SPAWN="${old_cdm_spawn}"
fi
if [ -s "${HOME}/.config/bash/environment" ]; then
    # shellcheck source=shells/.config/bash/environment
    . "${HOME}/.config/bash/environment"
fi
if [ -n "${PS1}" ]; then
    if [ -s "${HOME}/.config/bash/interactive" ]; then
        # shellcheck source=shells/.config/bash/interactive
        . "${HOME}/.config/bash/interactive"
    fi
fi
if [ -e "${HOME}/.config/sh/display" ]; then
	# shellcheck source=shells/.config/sh/display
	. "${HOME}/.config/sh/display"
fi

#!/bin/bash
if [ -s "${HOME}/.profile" ]; then
    dm_pid=${ITSDM_PID}
    ITSDM_PID=dummy
    # shellcheck source=shells/.profile
    . "${HOME}/.profile"
    ITSDM_PID=${dm_pid}
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

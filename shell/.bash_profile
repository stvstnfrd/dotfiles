#!/bin/bash
if [ -s "${HOME}/.profile" ]; then
    # shellcheck source=shell/.profile
    ITSDM_PID=dummy . "${HOME}/.profile"
fi
if [ -s "${HOME}/.config/bash/environment" ]; then
    # shellcheck source=shell/.config/bash/environment
    . "${HOME}/.config/bash/environment"
fi
if [ -n "${PS1}" ]; then
    if [ -s "${HOME}/.config/bash/interactive" ]; then
        # shellcheck source=shell/.config/bash/interactive
        . "${HOME}/.config/bash/interactive"
    fi
fi
if [ -e "${HOME}/.local/etc/itsdm/startup" ]; then
	# shellcheck source=display-manager/.local/etc/itsdm/startup
	. "${HOME}/.local/etc/itsdm/startup"
fi

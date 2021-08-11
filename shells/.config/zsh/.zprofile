#!/bin/zsh
# `export debug=1` to trace who sources who
if [ -n "${debug}" ]; then
    echo 'funk:zsh:profile'
fi
# Pull in the default sh/posix login script
if [ -s "${HOME}/.profile" ]; then
    dm_pid=${ITSDM_PID}
    ITSDM_PID=dummy
	# shellcheck source=shells/.profile
	. "${HOME}/.profile"
    ITSDM_PID=${dm_pid}
fi
# Perform any zsh-only login tasks here
if [ -e "${HOME}/.local/etc/itsdm/startup" ]; then
	# shellcheck source=display-manager/.local/etc/itsdm/startup
	. "${HOME}/.local/etc/itsdm/startup"
fi

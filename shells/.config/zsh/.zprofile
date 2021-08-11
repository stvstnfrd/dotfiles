#!/bin/zsh
# `export debug=1` to trace who sources who
if [ -n "${debug}" ]; then
    echo 'funk:zsh:profile'
fi
# Pull in the default sh/posix login script
if [ -s "${HOME}/.profile" ]; then
	# shellcheck source=shells/.profile
	ITSDM_PID=dummy . "${HOME}/.profile"
fi
# Perform any zsh-only login tasks here
if [ -e "${HOME}/.local/etc/itsdm/startup" ]; then
	# shellcheck source=display-manager/.local/etc/itsdm/startup
	. "${HOME}/.local/etc/itsdm/startup"
fi

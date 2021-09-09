#!/bin/zsh
if [ -s "${HOME}/.profile" ]; then
	# shellcheck source=shell/.profile
	ITSDM_PID=dummy . "${HOME}/.profile"
fi
if [ -s "${HOME}/.config/zsh/login" ]
then
	. "${HOME}/.config/zsh/login"
fi

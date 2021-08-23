#!/bin/zsh
if [ -s "${HOME}/.profile" ]; then
	# shellcheck source=shells/.profile
	ITSDM_PID=dummy . "${HOME}/.profile"
fi
if [ -s "${HOME}/.config/zsh/login" ]
then
	. "${HOME}/.config/zsh/login"
fi

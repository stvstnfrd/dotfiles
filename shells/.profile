#!/bin/sh
# shellcheck source=shells/.config/sh/environment
. "${HOME}/.config/sh/environment"
# shellcheck source=shells/.config/sh/login
. "${HOME}/.config/sh/login"

if [ -e "${HOME}/.config/sh/display" ]; then
	# shellcheck source=shells/.config/sh/display
	. "${HOME}/.config/sh/display"
fi

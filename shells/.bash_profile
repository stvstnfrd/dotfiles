#!/bin/bash
if [ -s "${HOME}/.profile" ]; then
    # shellcheck source=shells/.profile
    . "${HOME}/.profile"
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

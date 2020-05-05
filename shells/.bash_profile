#!/bin/bash
if [ -s "${HOME}/.profile" ]; then
    . "${HOME}/.profile"
fi
if [ -s "${HOME}/.config/bash/environment" ]; then
    . "${HOME}/.config/bash/environment"
fi
if [ -n "${PS1}" ]; then
    if [ -s "${HOME}/.config/bash/interactive" ]; then
        . "${HOME}/.config/bash/interactive"
    fi
fi

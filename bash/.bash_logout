#!/bin/bash
if [ -n "${debug}" ]; then
    echo 'funk:bash:logout'
fi
if [ -s "${HOME}/.config/sh/logout" ]; then
    . "${HOME}/.config/sh/logout"
fi

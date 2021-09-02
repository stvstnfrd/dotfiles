#!/bin/bash
if [ -s "${HOME}/.config/sh/logout" ]; then
    # shellcheck source=shell/.config/sh/logout
    . "${HOME}/.config/sh/logout"
fi

#!/bin/sh
if [ -e "${HOME}/src/autoenv/activate.sh" ]; then
    # shellcheck source=autoenv/src/autoenv/activate.sh
    . "${HOME}/src/autoenv/activate.sh"
fi

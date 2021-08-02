#!/bin/sh
if [ -e "${HOME}/src/autoenv/activate.sh" ]; then
    # shellcheck source=autoenv/src/autoenv/activate.sh
    # shellcheck disable=SC1091
    . "${HOME}/src/autoenv/activate.sh"
fi

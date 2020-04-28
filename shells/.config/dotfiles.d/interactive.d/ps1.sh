#!/bin/sh
if [ -z "${ZSH_VERSION}" -a -z "${BASH_VERSION}" ]; then
    PS1=""
    PS1="${PS1}
# "
    export PS1
fi

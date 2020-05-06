#!/bin/sh
curl() {
    _flags=
    if [ -e "${NETRC}" ]; then
        _flags="--netrc-file ${NETRC}"
    fi
    command curl ${_flags} ${@}
}

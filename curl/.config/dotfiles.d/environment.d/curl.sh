#!/bin/sh
curl() {
    _flags=
    if [ -e "${NETRC}" ]; then
        _flags="--netrc-file ${NETRC}"
    fi
    # shellcheck disable=SC2086
    command curl ${_flags} "${@}"
}

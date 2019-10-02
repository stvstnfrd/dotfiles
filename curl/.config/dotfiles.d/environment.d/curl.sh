#!/bin/sh
curl() {
    if [ -n "${NETRC}" ]; then
        _flags="--netrc-file '${NETRC}"
    fi
    command curl ${_flags} ${@}
}

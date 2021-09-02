#!/bin/sh
CDPATH="${HOME}/src"
CDPATH="${HOME}/src/edx:${CDPATH}"
CDPATH="${HOME}/projects:${CDPATH}"
CDPATH=".:${CDPATH}"
export CDPATH
_path=
_name=.
for _ in $(seq 1 3); do
    _path="${_path}../"
    _name="${_name}."
    # shellcheck disable=SC2139
    alias ${_name}="cd $_path && ls"
done

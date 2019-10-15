#!/bin/sh
CDPATH="${HOME}/src"
CDPATH="${HOME}/src/edx:${CDPATH}"
CDPATH="${HOME}/src/edx/xblocks:${CDPATH}"
CDPATH="${HOME}/projects:${CDPATH}"
CDPATH=".:${CDPATH}"
export CDPATH
_path=
_name=.
for i in {1..3}; do
    _path="${_path}../"
    _name="${_name}."
    alias ${_name}="cd $_path && ls"
done

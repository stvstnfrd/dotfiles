#!/bin/sh
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS=
export WORKON_HOME=${HOME}/.local/venvs
_get_virtualenv_path() {
    venv_name=${1:-$(basename $(pwd))}
    if [ -z "${venv_name}" ]; then
        echo
        exit 1
    fi
    venv_path="${WORKON_HOME}/${venv_name}"
    echo "${venv_path}"
}
lsvirtualenv() {
    find "${WORKON_HOME}" -maxdepth 1 -mindepth 1 -type d | \
        xargs -n1 basename
}
mkvirtualenv() {
    venv_path="$(_get_virtualenv_path ${1})"
    if [ -z "${venv_path}" ]; then return 1; fi
    if [ -n "${VIRTUAL_ENV}" ]; then
        return
        if [ "${VIRTUAL_ENV}" != "${venv_path}" ]; then
            deactivate
        else
            return
        fi
    fi
    if [ ! -e "${venv_path}" ]; then
        python3 -m venv ${VIRTUALENVWRAPPER_VIRTUALENV_ARGS} "${venv_path}"
    fi
    . "${venv_path}/bin/activate"
}
rmvirtualenv() {
    if [ -n "${VIRTUAL_ENV}" ]; then
        echo 'You must deactivate the virtualenv first'
        return 1
    fi
    venv_path="$(_get_virtualenv_path)"
    if [ -z "${venv_path}" ]; then return 1; fi
    rm -rf "${venv_path}"
}
workon() {
    venv_path="$(_get_virtualenv_path ${1})"
    if [ -z "${venv_path}" ]; then return 1; fi
    . "${venv_path}/bin/activate"
}

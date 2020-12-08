#!/bin/sh
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS=

_get_virtualenv_path() {
    venv_name=${1:-$(basename "$(pwd)")}
    if [ -z "${venv_name}" ]; then
        echo
        exit 1
    fi
    venv_path="${WORKON_HOME}/${venv_name}"
    echo "${venv_path}"
}

lsvirtualenv() {
    find "${WORKON_HOME}" -maxdepth 1 -mindepth 1 -type d -print0 | \
        xargs -0 -n1 --no-run-if-empty basename
}

mkvirtualenv() {
    venv_path="$(_get_virtualenv_path "${1}")"
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
        # shellcheck disable=SC2086
        python3 -m venv ${VIRTUALENVWRAPPER_VIRTUALENV_ARGS} "${venv_path}"
    fi
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

deactivate () {
    # reset old environment variables
    unset VIRTUAL_ENV
    if [ -n "${_OLD_VIRTUAL_PATH:-}" ] ; then
        PATH="${_OLD_VIRTUAL_PATH:-}"
        export PATH
        unset _OLD_VIRTUAL_PATH
    fi
    if [ -n "${BASH:-}" ] || [ -n "${ZSH_VERSION:-}" ] ; then
        hash -r
    fi
}

workon() {
    deactivate
    venv_path="$(_get_virtualenv_path "${1}")"
    if [ -z "${venv_path}" ]; then return 1; fi
    _OLD_VIRTUAL_PATH="${PATH}"
    export VIRTUAL_ENV="${venv_path}"
    export PATH="${VIRTUAL_ENV}/bin:${PATH}"
    if [ -n "${BASH:-}" ] || [ -n "${ZSH_VERSION:-}" ] ; then
        hash -r
    fi
}

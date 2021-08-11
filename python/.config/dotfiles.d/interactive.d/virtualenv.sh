#!/bin/sh
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS=

_get_virtualenv_path() {
    venv_name=${1:-$(basename "${PWD}")}
    if [ -z "${venv_name}" ]; then
        echo
        exit 1
    fi
    venv_path="${WORKON_HOME}/${venv_name}"
    echo "${venv_path}"
}

venv() {
    if [ ${#} -eq 0 ]
    then
        lsvirtualenv
    else
        if [ "${1}" = '-d' ]
        then
            deactivate
        elif [ "${1}" = '-D' ]
        then
            shift
            deactivate
            rmvirtualenv "${@}"
        else
            venv_path="$(_get_virtualenv_path "${@}")"
            if [ -z "${venv_path}" ]; then return 1; fi
            if [ ! -e "${venv_path}" ]
            then
                mkvirtualenv "${@}" || return 1
            fi
            workon "${@}"
        fi
    fi
}

lsvirtualenv() {
    find "${WORKON_HOME}" -maxdepth 1 -mindepth 1 -type d -print0 \
    2>/dev/null \
    | xargs -0 -n1 --no-run-if-empty basename \
    | sort \
    ;
}

mkvirtualenv() {
    venv_path="$(_get_virtualenv_path "${@}")"
    if [ -z "${venv_path}" ]; then return 1; fi
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
    venv_path="$(_get_virtualenv_path "${@}")"
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
    venv_path="$(_get_virtualenv_path "${@}")"
    if [ -z "${venv_path}" ]; then return 1; fi
    _OLD_VIRTUAL_PATH="${PATH}"
    export VIRTUAL_ENV="${venv_path}"
    export PATH="${VIRTUAL_ENV}/bin:${PATH}"
    if [ -n "${BASH:-}" ] || [ -n "${ZSH_VERSION:-}" ] ; then
        hash -r
    fi
}

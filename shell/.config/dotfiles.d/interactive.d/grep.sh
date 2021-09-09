#!/bin/sh
# shellcheck disable=SC2086
# shellcheck disable=SC2089
# shellcheck disable=SC2090
_GREP_OPTIONS='--color=always --binary-files=without-match --recursive'
_LESS_OPTIONS='--quit-if-one-screen --RAW-CONTROL-CHARS --chop-long-lines'
_ignored_directories='.cvs .git .hg .svn __pycache__ test_root dist node_modules coverage htmlcov cover'
_ignored_files='*.po *.mo'
grep_flag_available() {
    echo | grep "${1}" "" >/dev/null 2>&1
}
if grep_flag_available --exclude-dir=.cvs; then
    # added in grep 2.5.3
    for PATTERN in ${_ignored_directories}; do
        _GREP_OPTIONS="${_GREP_OPTIONS} --exclude-dir=${PATTERN}"
    done
elif grep_flag_available --exclude=.cvs; then
    for PATTERN in ${_ignored_directories}; do
        _GREP_OPTIONS="${_GREP_OPTIONS} --exclude=${PATTERN}"
    done
fi
if grep_flag_available "--exclude='*.po'"; then
    for PATTERN in ${_ignored_files}; do
        _GREP_OPTIONS="${_GREP_OPTIONS} --exclude='${PATTERN}'"
    done
fi
unset _ignored_directories
unset _ignored_files
unset grep_flag_available
rg() {
    grep \
        ${_GREP_OPTIONS} \
        "${@}" \
    | less ${_LESS_OPTIONS}
}
rgl() {
    grep \
        ${_GREP_OPTIONS} \
        --files-with-matches \
        "${@}" \
    ;
}
rgl0() {
    rgl \
        --null \
        --color=never \
        "${@}" \
    ;
}
rg_each() {
    EDITOR=${EDITOR:-vim}
    rgl0 \
        "${@}" \
    | xargs -0 "${EDITOR}"
}
rg_docs() {
    grep \
        --include='*.markdown' \
        --include='*.md' \
        --include='*.rst' \
        --include='*.txt' \
        ${_GREP_OPTIONS} \
        "${@}" \
    | less ${_LESS_OPTIONS}
}
rg_py() {
    grep \
        --include='*.py' \
        ${_GREP_OPTIONS} \
        "${@}" \
    | less ${_LESS_OPTIONS}
}
rg_web() {
    grep \
        --include='*.html' \
        --include='*.jsx?' \
        --include='*.s?css' \
        ${_GREP_OPTIONS} \
        "${@}" \
    | less ${_LESS_OPTIONS}
}
# export GREP_COLOR='1;32'

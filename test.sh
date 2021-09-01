#!/bin/sh
#h NAME:
#h SYNOPSIS:
#h DESCRIPTION:
#h EXAMPLES:
#h OVERVIEW:
#h OPTIONS:
#h DEFAULTS:
#h EXIT STATUS:
#h ENVIRONMENT:
#h FILES:
#h SEE ALSO:
#h HISTORY:
#h BUGS:
#h USAGE:
while getopts ":h" option; do case ${option} in h) grep '^#h' "${0}" | sed 's/^#h \?//g'; exit;; *) ;; esac; done
find_shadowed_path() {
    command_name=${1}
    dir_name=$(dirname "${command_name}")
    exe_name=$(basename "${command_name}")
    PATH2=$(echo "${PATH}" | sed 's@\(^\|:\)'${dir_name}'\(:\|$\)@:@;
(^:\+\)\|\(:\+$\)@@')
    PATH=${PATH2} command -v "${exe_name}" 2>/dev/null
}
find_shadowed_path "${0}"
exit 1

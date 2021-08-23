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
while getopts ":h" option
do
    case ${option} in
        h)
            grep '^#h' "${0}" \
            | sed 's/^#h \?//g'
            exit
        ;;
        *)
        ;;
    esac
done

get_current_rotation() {
    connected_display="${1}"
    xrandr \
    | grep "^${connected_display}" \
    | cut -d' ' -f5 \
    ;
}
get_next_rotation() {
    current_rotation="${1}"
    if echo "${current_rotation}" | grep -q '^('
    then
        current_rotation=normal
    fi
    case "${current_rotation}" in
        left)
            next_rotation=inverted
        ;;
        inverted)
            next_rotation=right
        ;;
        right)
            next_rotation=normal
        ;;
        normal)
            next_rotation=left
        ;;
        *)
            next_rotation=normal
        ;;
    esac
    echo "${next_rotation}"
}
_rotate_display() {
    connected_display="${1}"
    next_rotation="${2}"
    xrandr --output "${connected_display}" --rotate "${next_rotation}"
}
rotate_display() {
    connected_display="${1}"
    current_rotation=$(get_current_rotation "${connected_display}")
    next_rotation=$(get_next_rotation "${current_rotation}")
    _rotate_display "${connected_display}" "${next_rotation}"
}
get_connected_displays() {
    connected_displays=$(
        xrandr \
       | grep '^[^ ]\+ connected' \
       | cut -d' ' -f1 \
       ;
    )
    printf '%s' "${connected_displays}"
}
get_connected_display() {
    head -n1
}
get_connected_display_count() {
    wc -l
}
main() {
    connected_displays=$(get_connected_displays)
    # This _should_ be inside `get_connected_displays`, but it munges the trailing newline.
    if [ -n "${connected_displays}" ]
    then
        connected_displays="${connected_displays}
    "
    fi
    count_connected_displays=$(printf '%s' "${connected_displays}" | get_connected_display_count)
    if [ "${count_connected_displays}" -eq 0 ]
    then
        xrandr --auto
    elif [ "${count_connected_displays}" -eq 1 ]
    then
        connected_display=$(printf '%s' "${connected_displays}" | get_connected_display)
        rotate_display "${connected_display}"
    fi
}

main "${@}"

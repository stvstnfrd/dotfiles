#!/bin/sh
#h NAME:
#h 	i3-exit
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
#h 	Adopted from:
#h 		https://faq.i3wm.org/question/1262/exiting-i3-without-mouse-click.1.html
#h HISTORY:
#h BUGS:
#h USAGE:
#h 	Integrate with i3wm like:
#h 		bindsym $mod+Shift+e exec ~/.config/i3/exit.sh

while getopts ":h" option; do case ${option} in h) grep '^#h' "${0}" | sed 's/^#h \?//g'; exit;; *) ;; esac; done
while [ "$select" != "NO" ] && [ "$select" != "YES" ]; do
    select=$(
        printf 'NO\nYES' \
        | dmenu \
            -nb '#151515' \
            -nf '#999999' \
            -sb '#f00060' \
            -sf '#000000' \
            -fn '-*-*-medium-r-normal-*-*-*-*-*-*-100-*-*' \
            -i \
            -p "Do you really want to exit i3? This will end your X session." \
        ;
    )
    [ -z "$select" ] && exit 0
done
[ "$select" = "NO" ] && exit 0
i3-msg exit

#!/bin/sh
#h NAME:
#h 	**PROGRAM-NAME**
#h
#h SYNOPSIS:
#h 	**PROGRAM-NAME** **-h**
#h
#h 	See complete help with `PROGRAM-NAME -h`.
#h
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

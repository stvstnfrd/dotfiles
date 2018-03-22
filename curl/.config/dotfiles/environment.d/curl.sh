#!/bin/sh
curl() {
    command curl --netrc-file "${HOME}/.netrc" ${@}
}

#!/bin/sh
ssh () {
    command ssh -F ${XDG_CONFIG_HOME}/ssh/config ${@}
}

#!/bin/sh
ptpython () {
    command ptpython --config-dir ${XDG_CONFIG_HOME}/ptpython ${@}
}

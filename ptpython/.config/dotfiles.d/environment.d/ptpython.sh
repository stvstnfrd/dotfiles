#!/bin/sh
ptpython () {
    command ptpython --vi --config-dir ${XDG_CONFIG_HOME}/ptpython ${@}
}

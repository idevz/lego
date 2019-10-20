#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 10:44:25 2019/10/20
# Description:       funcs for deploy pvms
# deploy          o pvm deploy::echo
#
# Environment variables that control this script:
#
### END ###

set -e
BASE_DIR=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))

function pvm::deploy::echo() {
    echo "pvm::deploy::echo---->"
}

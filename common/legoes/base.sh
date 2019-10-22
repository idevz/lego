#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 11:04:59 2019/10/20
# Description:       common base funcs
# base          source ./base.sh
#
# Environment variables that control this script:
#
### END ###

set -e
BASE_DIR=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))

function base::do() {
    echo ""
}

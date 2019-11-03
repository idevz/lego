#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 13:13:07 2019/10/26
# Description:       pvm hepler funcs
# helper          . ./hepler.sh && func args
#
# Environment variables that control this script:
#
### END ###

set -e
BASE_DIR=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))

function init_venv() {
    echo "pvm->ok"
}

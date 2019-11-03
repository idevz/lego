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

# pip freeze to requirements.txt
function pip_freeze() {
    local proj_root=${1:-"./"}
    $(command -v pip3) freeze "${proj_root}/requirements.txt"
}

# pip unfreeze from requirements.txt
function pip_unfreeze() {
    local proj_root=${1:-"./"}
    $(command -v pip3) -r "${proj_root}/requirements.txt"
}

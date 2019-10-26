#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 09:54:59 2019/10/20
# Description:       helper funcs
# helpers          source helpers.sh
#
# Environment variables that control this script:
#
### END ###

# set -e
LEGO_ROOT=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))
COMMON_LEGO_ROOT=${LEGO_ROOT}/common/legoes/

add() {
    lego::base::call_func "lego::base::create_module" "vendor" "$@"
}

xadd() {
    lego::base::call_func "lego::base::create_module" "sys" "$@"
}

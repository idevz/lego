#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 11:45:45 2019/10/20
# Description:       lego runX demo
# test          o demo test::echo
#
# Environment variables that control this script:
#
### END ###

set -e
BASE_DIR=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))

function demo::test::echo() {
    h::fn_exists demo::test::echo2
    echo "------>demo::test::echo" $(h::call_func demo::test::do_call)
}

function demo::test::do_call() {
    echo "ok->do_call"
}

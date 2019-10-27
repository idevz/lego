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

set -e
LEGO_ROOT=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))
COMMON_LEGO_ROOT=${LEGO_ROOT}/common/legoes/

cmd_curl=$(command -v curl)

# create a vendor module
function add() {
    lego::base::call_func "lego::base::create_module" "vendor" "$@"
}

# create a sys module
function xadd() {
    lego::base::call_func "lego::base::create_module" "sys" "$@"
}

function curl() {
    ${cmd_curl} -w '\nstatistics:\n\ntime_namelookup=%{time_namelookup}\ntime_appconnect=%{time_appconnect}\ntime_connect=%{time_connect}\ntime_redirect=%{time_redirect}\ntime_pretransfer=%{time_pretransfer}\ntime_starttransfer=%{time_starttransfer}\ntime_total=%{time_total}\n\n' "$@"
}

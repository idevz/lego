#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 09:39:31 2019/10/20
# Description:       this is a lego version for runX
# runX          o
#
# Environment variables that control this script:
#
### END ###

# set -e
LEGO_ROOT=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))

# must source to current action scope
source ${LEGO_ROOT}/common/legoes/helpers.sh && h::load_common || exit 1

do_what=${1}

case ${do_what} in
h | -h | --help)
    echo "
Usage:

        o [do_what] [funcs] [params]
        eg. o pvm deploy::echo
"
    ;;
*)
    fn="${do_what}::${2}"
    shift 2
    if [[ $(h::fn_exists "${fn}") == "false" ]]; then
        func_shell=$(h::fn_shell ${fn})
        lego_shell="${LEGO_ROOT}/${func_shell}"
        vendor_lego_shell="${LEGO_ROOT}/vendor/${func_shell}"
        [ -f "${lego_shell}" ] && source "${lego_shell}"
        [ -f "${vendor_lego_shell}" ] && source "${vendor_lego_shell}"
    fi

    ${fn} "$@" && echo "done." && exit 0
    ;;
esac

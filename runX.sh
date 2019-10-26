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

set -e
LEGO_ROOT=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))

# must source to current action scope
source ${LEGO_ROOT}/lego/legoes/base.sh && lego::base::load_common || exit 1

module_name=${1}

case ${module_name} in
h | -h | --help)
    echo "
Usage:

        o [module_name] [funcs] [params]
        eg. o pvm deploy::\${func?}
            o pvm dosomething
"
    ;;
*)
    # lego::base::get_this_ip
    ip=$(lego::base::get_this_ip) || ip="false"
    echo $ip
    exit 0
    # if there is a '::' in ${2}, then this call a function, like o pvm deploy::${func?}
    # if not, then its calling a export ablity from each 'helper.sh', like o pvm dosomething
    if [ "$(lego::base::has_str "${2}" "::")" = 'false' ]; then
        func_name=${2}
        shift 2
        func_shell="${module_name}/legoes/helpers.sh"
    else
        func_name="${module_name}::${2}"
        shift 2
        func_shell="$(lego::base::fn_shell "${func_name}")"
    fi

    lego_shell="${LEGO_ROOT}/${func_shell}"
    vendor_lego_shell="${LEGO_ROOT}/vendor/${func_shell}"

    [ -f "${lego_shell}" ] && source "${lego_shell}"
    [ -f "${vendor_lego_shell}" ] && source "${vendor_lego_shell}"

    if [ "$(lego::base::fn_exists "${func_name}")" != 'false' ]; then
        ${func_name} "$@" && echo "done." && exit 0
    else
        echo "none function ${func_name} found."
        exit 1
    fi
    ;;

esac

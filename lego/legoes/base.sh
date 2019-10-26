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

LEGO_ROOT=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))
COMMON_LEGO_ROOT=${LEGO_ROOT}/lego/legoes/

function lego::base::create_modules() {
    module_name=${1}
    func_file=${2}
    [[ -z "${module_name}" ]] &&
        echo "moudle name must be not empty." && exit 1
    module_legoes_path=${LEGO_ROOT}/${module_name}/legoes
    mkdir -p "${module_legoes_path}"
    [[ -z ${func_file} ]] && func_file="helpers"
    touch "${module_legoes_path}/${func_file}.sh"
}

function lego::base::load_common() {
    local common_lib_export="${COMMON_LEGO_ROOT}/export"
    while read line; do
        local common_lib="${COMMON_LEGO_ROOT}/${line}".sh
        [ -x "${common_lib}" ] &&
            source ${common_lib} || echo "error to source file: ${common_lib}"
    done <"${common_lib_export}"
}

function lego::base::fn_shell() {
    echo "${1}" | awk -F\:: '{print $1"/legoes/"$2".sh"}'
}

function lego::base::call_func() {
    func_name=${1}
    [ -z "${func_name}" ] && exit 1

    if [ "$(common::base::fn_exists "${func_name}")" = 'false' ]; then
        func_shell=$(h::fn_shell "${func_name}")
        lego_shell="${LEGO_ROOT}/${func_shell}"
        vendor_lego_shell="${LEGO_ROOT}/vendor/${func_shell}"
        [ -f "${lego_shell}" ] && source "${lego_shell}"
        [ -f "${vendor_lego_shell}" ] && source "${vendor_lego_shell}"
    fi

    ${func_name} "$@"
}

function lego::base::get_this_ip() {
    [ -z "${MACHINE_IP_DETECT_HOST}" ] &&
        echo "none MACHINE_IP_DETECT_HOST in current env." && return 1
    echo $(python -c "
import socket;
s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);
s.connect(('${MACHINE_IP_DETECT_HOST}', 80));
print(s.getsockname()[0])
")
}

function lego::base::sudo_write() {
    local content="${1}"
    local file_name="${2}"
    local if_add=
    [ ! -z "${3}" ] && if_add="-a"
    echo "${content}" | sudo tee ${if_add} "${file_name}" >/dev/null 2>&1
}

function lego::base::has_str() {
    echo "${1}" | grep -q "${2}" || echo "false"
    # return
}

function lego::base::fn_exists() {
    type "${1}" 2>/dev/null | grep -q 'function' || echo "false"
    # return
}

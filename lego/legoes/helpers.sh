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

function h::load_common() {
    local common_lib_export="${COMMON_LEGO_ROOT}/export"
    while read line; do
        local common_lib="${COMMON_LEGO_ROOT}/${line}".sh
        [ -x "${common_lib}" ] &&
            source ${common_lib} || echo "error to source file: ${common_lib}"
    done <"${common_lib_export}"
}

function h::fn_shell() {
    echo $(echo "${1}" | awk -F\:: '{print $1"/legoes/"$2".sh"}')
    return 0
}

function h::fn_exists() {
    $(type "${1}" 2>/dev/null | grep -q 'function') || echo "false"
    return $?
}

function h::call_func() {
    fn=${1}
    [ -z "${fn}" ] && exit 1

    if [[ $(h::fn_exists "${fn}") == "false" ]]; then
        func_shell=$(h::fn_shell ${fn})
        lego_shell="${LEGO_ROOT}/${func_shell}"
        vendor_lego_shell="${LEGO_ROOT}/vendor/${func_shell}"
        [ -f "${lego_shell}" ] && source "${lego_shell}"
        [ -f "${vendor_lego_shell}" ] && source "${vendor_lego_shell}"
    fi

    echo $(${fn} $@)
    return $?
}

function h::env_p_exists() {
    [ -z "${1}" ] && return 1
    return 0
}

function h::get_this_ip() {
    ! h::env_p_exists ${MACHINE_IP_DETECT_HOST} && return 1
    [ $(uname) != "Linux" ] && return 1
    echo $(python -c "
import socket;s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);
s.connect(('${MACHINE_IP_DETECT_HOST}',0));
print s.getsockname()[0]
")
}

function h::sudo_write() {
    local content="${1}"
    local file_name="${2}"
    local if_add=
    [ ! -z ${3} ] && if_add="-a"
    echo "${content}" | sudo tee ${if_add} "${file_name}" >/dev/null 2>&1
}

#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 11:04:59 2019/10/20
# Description:       common base funcs
# base          source ./base.sh
#
# Environment variables that control this script:
#
#   ██▓    ▓█████   ▄████  ▒█████
#  ▓██▒    ▓█   ▀  ██▒ ▀█▒▒██▒  ██▒
#  ▒██░    ▒███   ▒██░▄▄▄░▒██░  ██▒
#  ▒██░    ▒▓█  ▄ ░▓█  ██▓▒██   ██░
#  ░██████▒░▒████▒░▒▓███▀▒░ ████▓▒░
#  ░ ▒░▓  ░░░ ▒░ ░ ░▒   ▒ ░ ▒░▒░▒░
#  ░ ░ ▒  ░ ░ ░  ░  ░   ░   ░ ▒ ▒░
#    ░ ░      ░   ░ ░   ░ ░ ░ ░ ▒
#      ░  ░   ░  ░      ░     ░ ░
#
# this logo thanks to:
# http://patorjk.com/software/taag/#p=display&c=bash&f=Bloody&t=Lego
# http://asciiflow.com/
### END ###

set -e

LEGO_ROOT=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))
COMMON_LEGO_ROOT=${LEGO_ROOT}/lego/legoes/

function lego::base::load_common() {
    local common_lib_export="${COMMON_LEGO_ROOT}/export"
    while read line; do
        local common_lib="${COMMON_LEGO_ROOT}/${line}".sh
        [ -x "${common_lib}" ] &&
            source ${common_lib} || echo "error to source file: ${common_lib}"
    done <"${common_lib_export}"
}

function lego::base::create_module() {
    type=${2}
    shift 2
    local module_name=${1}
    local func_file=${2}

    if [ "$(lego::base::fn_exists "${module_name}")" != 'false' ]; then
        shift
        echo "Already had a command named '${module_name}', you should choise aonther one." && exit 1
    fi

    [[ -z "${module_name}" ]] &&
        echo "moudle name must be not empty." && exit 1
    local module_legoes_path=${LEGO_ROOT}/vendor/${module_name}/legoes
    [ "${type}" = 'sys' ] &&
        module_legoes_path=${LEGO_ROOT}/${module_name}/legoes
    mkdir -p "${module_legoes_path}"
    [[ -z ${func_file} ]] && func_file="helpers"
    touch "${module_legoes_path}/${func_file}.sh"
    cat <<HELPERS >"${module_legoes_path}/${func_file}.sh"
#!/usr/bin/env bash

### BEGIN ###
# Author: lego users
# Since: $(date +"%H:%M:%S %y/%m/%d")
# Description:  function about ${module_name}
# base          source ./${func_file}.sh
#
# Environment variables that control this script:
#
#   ██▓    ▓█████   ▄████  ▒█████
#  ▓██▒    ▓█   ▀  ██▒ ▀█▒▒██▒  ██▒
#  ▒██░    ▒███   ▒██░▄▄▄░▒██░  ██▒
#  ▒██░    ▒▓█  ▄ ░▓█  ██▓▒██   ██░
#  ░██████▒░▒████▒░▒▓███▀▒░ ████▓▒░
#  ░ ▒░▓  ░░░ ▒░ ░ ░▒   ▒ ░ ▒░▒░▒░
#  ░ ░ ▒  ░ ░ ░  ░  ░   ░   ░ ▒ ▒░
#    ░ ░      ░   ░ ░   ░ ░ ░ ░ ▒
#      ░  ░   ░  ░      ░     ░ ░
#
### END ###

set -e

LEGO_ROOT=\$(dirname \$(cd \$(dirname "\$0") && pwd -P)/\$(basename "\$0"))
COMMON_LEGO_ROOT=\${LEGO_ROOT}/lego/legoes/

function your_function() {
    echo "do something."
}
HELPERS
}

function lego::base::fn_shell() {
    echo "${1}" | awk -F\:: '{print $1"/legoes/"$2".sh"}'
}

function lego::base::call_func() {
    func_name=${1}
    [ -z "${func_name}" ] && exit 1

    if [ "$(lego::base::fn_exists "${func_name}")" = 'false' ]; then
        func_shell=$(lego::base::fn_shell "${func_name}")
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

function lego::base::logo() {
    echo "
   ██▓    ▓█████   ▄████  ▒█████  
  ▓██▒    ▓█   ▀  ██▒ ▀█▒▒██▒  ██▒
  ▒██░    ▒███   ▒██░▄▄▄░▒██░  ██▒
  ▒██░    ▒▓█  ▄ ░▓█  ██▓▒██   ██░
  ░██████▒░▒████▒░▒▓███▀▒░ ████▓▒░
  ░ ▒░▓  ░░░ ▒░ ░ ░▒   ▒ ░ ▒░▒░▒░ 
  ░ ░ ▒  ░ ░ ░  ░  ░   ░   ░ ▒ ▒░ 
    ░ ░      ░   ░ ░   ░ ░ ░ ░ ▒  
      ░  ░   ░  ░      ░     ░ ░  
"
}

# came from wtools create by qindi@weibo.com
function _lego_pcolumn() {
    echo -e "${1}" |
        awk -F'\t' '{
        if (length($1) < 36) {
            printf "%-36s:%s\n",$1,$2
        } else {
            print $1;
            printf "%-36s:%s\n", "", $2
        }
    }'
}

# came from wtools create by qindi@weibo.com
function _lego_ptitle() {
    length=${#1}
    prefix_count=$(((30 - length) / 2))
    for i in $(seq 0 ${prefix_count}); do
        echo -n '='
    done
    echo -n " ${1} "
    postfix_count=$((length % 2 != 0 ? prefix_count + 1 : prefix_count))
    for i in $(seq 0 ${postfix_count}); do
        echo -n '='
    done
    printf '\r\n'
}

# ability functions are only in hepers.sh
function _lego_ability() {
    local module="${1}"
    local func_shell="${2}"
    [ -z "${module}" ] && echo "empty module" && exit 1
    [ -z "${func_shell}" ] && echo "empty func_shell" && exit 1

    _lego_ptitle "${module}-ability-functions"
    # functions start with '_' are privite functions,which would never exported.
    grep -B 1 -E '^function ([^ _].*?)\(' "${func_shell}" |
        while read func_desp; do
            read func_name

            cmd=$(
                echo ${func_name} | awk -v m="${module}" '
                {
                    match($2,/(.*?)\(/,a)
                }{
                    if (m=="lego")
                    {
                        print a[1]
                    } else {
                        print m" "a[1]
                    }
                }
                '
            )

            desp="$(echo "${func_desp}" | cut -c 2-)"

            if [ "${cmd}" != "" ]; then
                _lego_pcolumn "${cmd}\t${desp}"
                echo "${cmd}" >>"${HOME}/.lego/cmds.cache"
            fi

            read _
        done
}

function _lego_module_funcs() {
    local module="${1}"
    local func_shell="${2}"
    [ -z "${module}" ] && echo "empty module" && exit 1
    [ -z "${func_shell}" ] && echo "empty func_shell" && exit 1

    _lego_ptitle "${module}-module-functions"

    # functions start with '_' are privite functions,which would never exported.
    grep -B 1 -E '^function ([^ _].*::.*?)\(' ${func_shell} |
        while read func_desp; do
            read func_name

            cmd=$(
                echo ${func_name} | awk -v m="${module}" '{match($2,/(.*?)::(.*?)::(.*?)\(/,a)}{print m" "a[2]"::"a[3]}'
            )

            desp="$(echo "${func_desp}" | cut -c 2-)"

            if [ "${cmd}" != "" ]; then
                _lego_pcolumn "${cmd}\t${desp}"
                echo "${cmd}" >>"${HOME}/.lego/cmds.cache"
            fi
            read _
        done
}

# ok
function lego::base::find_command() {
    for module in $(ls -l "${1}" | grep ^d | awk '{print $9}'); do
        local func_shell_path="${1}/${module}/legoes"
        if [ ! -d "${func_shell_path}" ]; then
            continue
        fi
        func_shell=$(ls -l "${func_shell_path}" | grep '.sh' | awk '{print $9}')
        if [ "${func_shell}" = "" ]; then
            continue
        fi

        _lego_ptitle "${module}"
        for file in ${func_shell}; do
            local tpm_shell_file="${func_shell_path}/${file}"
            if [ "${file}" = 'helpers.sh' ]; then
                _lego_ability "${module}" "${tpm_shell_file}" || echo ""
            else
                _lego_module_funcs "${module}" "${tpm_shell_file}" || echo ""
            fi
        done
        echo ''
    done
}

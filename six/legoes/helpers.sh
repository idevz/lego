#!/usr/bin/env bash

### BEGIN ###
# Author: lego users
# Since: 08:55:57 19/10/31
# Description:  function about six
# base          source ./helpers.sh
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

LEGO_ROOT=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))
COMMON_LEGO_ROOT=${LEGO_ROOT}/lego/legoes/
A6HOME=${A6H:-${A6HOME}}
export ETCDCTL_API=${EV:-"2"}

# reload apisix with clean
function reload() {
    cd "${A6HOME}"
    make stop clean run
    cd - >/dev/null 2>&1
}

# run apisix with clean
function run() {
    cd "${A6HOME}"
    make clean run
    cd - >/dev/null 2>&1
}

# stop apisix with clean
function stop() {
    cd "${A6HOME}"
    make stop
    cd - >/dev/null 2>&1
}

# list all keys
function all_keys() {
    printf "\nall keys:\n\n"
    etcdctl ls -r -p /apisix | grep -v '\/$'
    printf "\nall directories:\n\n"
    etcdctl ls -r -p /apisix | grep '\/$'
}

# get valuse by keys
function get_values() {
    for key in "$@"; do
        local v=
        v="$(etcdctl get --quorum "${key}" 2>/dev/null)"
        if [[ $? -eq 1 ]]; then
            echo "key: ${key} is not a exist key"
            continue
        else
            printf "\nkey: ${key} \nvaluse is:\n %s" \
                "$(echo "${v}" | jq .)"
        fi
    done
}

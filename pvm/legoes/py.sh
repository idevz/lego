#!/usr/bin/env bash

### BEGIN ###
# Author: lego users
# Since: 11:36:26 19/11/03
# Description:  function about pvm
# base          source ./py.sh
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
VENV_ROOT=${VR:-"${HOME}/.venvs"}

function _pvm_py_venv_must_have_venv_name() {
    local venv_name="${1}"
    if [[ -z ${venv_name} ]]; then
        echo "the virtualenv name must be given." >&2
        return 1
    else
        return 0
    fi
}

# init a virtualenv with venv path and python executable file
function pvm::py::init_venv() {
    local venv_name="${1}"
    local py_version="${2:-3}"
    _pvm_py_venv_must_have_venv_name "${venv_name}" || return 1
    command -v virtualenv ||
        sudo "$(command -v pip3)" install virtualenv

    virtualenv "${VENV_ROOT}/${venv_name}" -p "$(command -v "python${py_version}")" \
        --system-site-packages
}

# list all avaliable virtualenv name
function pvm::py::list_venv() {
    ls -l "${VENV_ROOT}" | grep '^d' | awk '{print $9}'
}

# output a virtualenv activate command, should exec as "$()" in the parents shell
function pvm::py::using_venv() {
    local venv_name=${1}
    _pvm_py_venv_must_have_venv_name "${venv_name}" || return 1
    echo "source ${VENV_ROOT}/${venv_name}/bin/activate"
}

# choice to output a virtualenv activate command
function pvm::py::choice_venv() {
    local venv_num=1
    declare -A venv_arr

    for venv in $(ls -l "${VENV_ROOT}" | grep '^d' | awk '{print $9}'); do
        printf "%s) \t %s\n" "${venv_num}" "${venv}"
        venv_arr[${venv_num}]="${venv}"
        # m=$[ m + 1]
        # m=`expr $m + 1`
        # m=$(($m + 1))
        # let m=m+1
        venv_num=$((venv_num + 1))
    done
    while (true); do
        local choice=
        read -r choice </dev/tty
        if [[ ${choice} -gt ${venv_num} ]]; then
            echo "invalidate input."
        fi
        echo "source ${VENV_ROOT}/${venv_arr[$choice]}/bin/activate"
        return 0
    done
}

# exit a virtualenv, should exec as "$()" in the parents shell
function pvm::py::exit_venv() {
    echo "deactivate"
}

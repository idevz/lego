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
COMMON_LEGO_ROOT=${LEGO_ROOT}/lego/legoes
MODULE_ROOT=${LEGO_ROOT}/pvm
SRCS_ROOT=${MODULE_ROOT}/srcs/py

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

# install conda
function pvm::py::install_conda() {
    if [ $(uname) = 'Darwin' ]; then
        brew cask install anaconda
        conda init zsh
        return 0
    fi
    local conda_install_sh="https://repo.continuum.io/miniconda/Miniconda3-4.7.12-Linux-x86_64.sh"
    local install_sh="${SRCS_ROOT}/Miniconda3-4.7.12-Linux-x86_64.sh"
    [ ! -d "${SRCS_ROOT}" ] && mkdir -p "${SRCS_ROOT}"
    [ -f "${install_sh}" ] || curl "${conda_install_sh}" >"${install_sh}"
    chmod +x "${install_sh}"
    sudo "${install_sh}" -b -p /usr/local/anaconda3
    export PATH=/usr/local/anaconda3/bin:$PATH
    conda init zsh
}

# https://zhuanlan.zhihu.com/p/32925500
# conda remove --name py35 --all
# conda info -e    # 环境列表
# conda list
# conda list -n py35
# conda search numpy
# 安装、更新、删除 某个环境的某个包
# conda install -n py35 numpy
# conda update -n py35 numpy
# conda remove -n py35 numpy
# conda update anaconda
# conda update conda
# conda update python
# 添加国内镜像
# conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
# conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
# conda config --set show_channel_urls yes# conda new a venv with venv name and python version
function pvm::py::conda_new_venv() {
    local venv_name=${1}
    local python_version=${2}
    if [ -z "${venv_name}" ] || [ -z "${python_version}" ]; then
        echo "venv name and python version must be given."
        return 1
    fi
    command -v conda || pvm::py::install_conda
    conda create -y --name "${venv_name}" python="${python_version}"
}

# using pyflame with python 3.6.5
function pvm::py::flame() {
    # Unexpected ptrace(2) exception:
    # Failed to PTRACE_PEEKDATA (pid xxx, addr 0x561664ad25a8): Input/output error
    command -v conda || pvm::py::conda_new_venv "py36" "3.6.5"
    # conda activate "py36"
    command -v pyflame || conda install -y -c eklitzke pyflame
    pyflame "$@"
}

# using python -m cProfile as python
# generate a cpu profile in /tmp/"$(basename "${1}")"
function pvm::py::cprof() {
    local prof_dir="/tmp"
    python -m cProfile -o ${prof_dir}/"$(basename "${1}")" $@
}

# using snakeviz to parse a cpu profile in /tmp/"$(basename "${1}")"
function pvm::py::cprof_v() {
    local prof_dir="/tmp"
    command -v snakeviz || pip install snakeviz
    snakeviz -s -H 0.0.0.0 ${prof_dir}/"$(basename "${1}")"
}

#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 10:44:25 2019/10/20
# Description:       funcs for deploy pvms
# deploy          o pvm deploy::echo
#
# base settings for pvm deploy
# 1. pvm::deploy::init_etc for no password root exec            exec on pvm
# 2. pvm::deploy::using_zsh change shell to zsh                 exec on pvm
# 3. pvm::deploy::init_ssh_path for no password login           exec on pvm
# 4. pvm::deploy::no_pass_login_to_pvm                          exec on mac
# 5. pvm::deploy::no_pass_login_to_mac no password login        exec on pvm
#
# Environment variables that control this script:
#
### END ###

set -e

LEGO_ROOT=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))

# 1. for no password root exec
#
# cd /media/psf/code/lego/
# ./runX.sh pvm deploy::init_etc
# . /etc/profile
# exit 0
# cd $LEGO
# ./o pvm deploy::using_zsh
#
# run `o pvm deploy::init_etc` command in pvm
# and manual source the two files make these works
# desp
function pvm::deploy::init_etc() {
    sudo cp "${LEGO_ROOT}/tpls/etc-profile" /etc/profile
    sudo cp "${LEGO_ROOT}/tpls/etc-sudoers" /etc/sudoers
}

# 2. change shell to zsh
# @TODO check runX.zshrc file and fix the runX.zshrc funcs
# desp
function pvm::deploy::using_zsh() {
    echo "change to zsh"
    sudo yum install -y zsh
    local zsh_location=$(which zsh)
    echo ${zsh_location} | sudo tee -a /etc/shells
    chsh -s ${zsh_location}
    sudo chsh -s ${zsh_location}
    cp "${LEGO_ROOT}/tpls/runX.zshrc" ~/.zshrc
    sudo cp "${LEGO_ROOT}/tpls/runX.zshrc" /root/.zshrc
}

# 3. for no password login
# desp
function pvm::deploy::init_ssh_path() {
    # $(h::call_func pvm::deploy::using_zsh)
    # sudo hostnamectl set-hostname ${HOST_NAME_SET}
    mkdir -m 700 -p ~/.ssh
    sudo mkdir -m 700 -p /root/.ssh
}

# 4. for no password login to pvm
# run `o pvm deploy::no_pass_login_to_pvm` command in mac
# desp
function pvm::deploy::no_pass_login_to_pvm() {
    local ip=${1}
    scp ~/.ssh/id_rsa.pub z@${ip}:~/.ssh/authorized_keys
    scp ~/.ssh/id_rsa.pub root@${ip}:~/.ssh/authorized_keys
}

# 5. for no password login to mac(or log out direct)
# run `o pvm deploy::no_pass_login_to_mac` command in pvm
# desp
function pvm::deploy::no_pass_login_to_mac() {
    ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ""
    cat ~/.ssh/id_rsa.pub
    echo "please append this id_rsa.pub to mac ~/.ssh/authorized_keys"
    echo "like cat >>~/.ssh/authorized_keys in mac ..."
}

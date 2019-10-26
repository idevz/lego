#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 18:07:28 2019/10/26
# Description:       online install lego
# get          ./get.sh
#
# Environment variables that control this script:
#
### END ###

set -ex

function logo() {
    echo "
   ██▓    ▓█████   ▄████  ▒█████  
  ▓██▒    ▓█   ▀  ██▒ ▀█▒▒██▒  ██▒
  ▒██░    ▒███   ▒██░▄▄▄░▒██░  ██▒
  ▒██░    ▒▓█  ▄ ░▓█  ██▓▒██   ██░
  ░██████▒░▒████▒░▒▓███▀▒░ ████▓▒░
  ░ ▒░▓  ░░░ ▒░ ░ ░▒   ▒ ░ ▒░▒░▒░ 
  ░ ░ ▒  ░ ░ ░  ░  ░   ░   ░ ▒ ▒░ 
    ░ ░      ░   ░ ░   ░ ░ ░ ░ ▒  
      ░  ░   ░  ░      ░     ░ ░"
}

function get_type() {
    echo "1 : Download and install to current folder"
    echo "2 : Download only"
    echo "q : Quit"
    local choice=
    while (true); do
        echo -n "Enter a value:"
        read choice </dev/tty
        if [ "$choice" = "q" ]; then exit 0; fi
        if [ "$choice" -gt "0" ] 2>/dev/null && [ "$choice" -lt "4" ] 2>/dev/null; then
            return $choice
        else
            echo "$choice is not valid option!"
        fi
    done
}

function do_download() {
    local fetch_dir=${1}
    if [ ! -d "$fetch_dir" ]; then
        echo "$fetch_dir is not vaild!"
        exit 1
    fi
    cd "$fetch_dir"
    test_exists "$fetch_dir"
    local has_git=
    type "git" >/dev/null 2>/dev/null || has_git=$?
    if [ "$has_git" -eq 0 ]; then
        echo "fetching source from github"
        do_fetch "$fetch_dir"
    else
        echo "can't locate git ,using archive mode."
        do_download_archive "$fetch_dir"
    fi
    echo "lego is downloaded to $fetch_dir/lego"
}

function do_download_archive() {
    mkdir lego && cd lego
    curl -L https://github.com/idevz/lego/tarball/master | tar -xf - --strip-components=1
}

function test_exists() {
    if [ -e o ] || [ -e runX.sh ]; then
        echo "$1/lego already exist!"
        local choice=
        while (true); do
            echo -n "(q)uit or (r)eplace?"
            read choice </dev/tty
            if [ "$choice" = "q" ]; then
                exit 0
            elif [ "$choice" = "r" ]; then
                rm -fr $1/lego
                break
            else
                echo "$choice is not valid!"
            fi
        done
    fi
}

function do_fetch() {
    local fetch_dir=$1
    if [ ! -d "$fetch_dir" ]; then
        echo "$fetch_dir is not vaild!"
        exit 1
    fi
    cd "$fetch_dir"
    test_exists lego
    git clone https://github.com/idevz/lego.git lego --depth=1
    cd lego
    return 0
}

function do_install() {
    echo '***install need sudo,please enter password***'
    sudo make install
    echo 'lego was installed to /usr/local/bin,have fun.'
}

function main() {
    logo
    local type=
    if [ "$1" = "install" ]; then
        type="1"
    elif [ "$1" = "download" ]; then
        type="2"
    else
        get_type || type=$?
    fi
    local current_folder=
    current_folder="$(pwd)"
    case "$type" in
    "1")
        echo "Launching lego installer..."
        do_download "${current_folder}"
        do_install
        ;;
    "2")
        echo "Start downloading lego ..."
        do_download "${current_folder}"
        ;;
    esac
    # @TODO add auto-complete
}
main "$@"

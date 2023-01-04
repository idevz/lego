#!/usr/bin/env bash

### BEGIN ###
# Author: lego users
# Since: 21:51:18 19/10/27
# Description:  function about hugo
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
BLOG_ROOT=${BROOT:-"${GIT}/idevz.org"}
HUGO_CMD="hugo"

# gen a hugo tile with '-'
function _h_title() {
    title=$*
    py=$(
        cat <<CODE
title="${title}.md";res="-".join(title.split(" "));print(res)
CODE
    )
    $(which python3) -c "${py}"
    # echo 'print("xxx")' | xargs -0 python -c
}

# new a hugo blog content
function new() {
    local title="${1}"
    cd "${BLOG_ROOT}"
    local content_file=
    content_file="$(_h_title "${title}")"
    $(command -v "${HUGO_CMD}") new "${content_file}" && echo "done"
    cd - >/dev/null 2>&1
}

# start the local hugo server
function start() {
    cd "${BLOG_ROOT}"
    $(command -v "${HUGO_CMD}") server "$@" &
    cd - >/dev/null 2>&1
}

# stop the local hugo server
function stop() {
    killall "${HUGO_CMD}"
}

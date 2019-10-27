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

# gen a hugo tile with '-'
function _h_title() {
    title=$*
    py=$(
        cat <<CODE
title="${title}.md";res="-".join(title.split(" "));print(res)
CODE
    )
    $(which python) -c "${py}"
    # echo 'print("xxx")' | xargs -0 python -c
}

# new hugo blog
function new() {
    local hugo_cmd="hugo"
    [ "$(uname)" = 'Darwin' ] && hugo_cmd="hugox"
    local title="${1}"
    local blog_root=${2:-"${GIT}/idevz.org"}
    cd "${blog_root}"
    local content_file=
    content_file="$(_h_title "${title}")"
    $(command -v "${hugo_cmd}") new "${content_file}" && echo "done"
    cd - >/dev/null 2>&1
}

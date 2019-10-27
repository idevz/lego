#!/bin/bash
### lego bash complete
function _lego_complete() {
    local pre cur opts
    COMPREPLY=()
    pre=${1}
    cur=${2}
    case "$cur" in
    *)
        cmds=$(cat $HOME/.lego/cmds.cache | xargs echo)
        COMPREPLY=($(compgen -W "$cmds" -- $cur))
        ;;
    esac
}
export -f _lego_complete
complete -F _lego_complete -A file o

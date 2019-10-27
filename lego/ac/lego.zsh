#!/bin/zsh
### lego zsh complete
function list_lego_completions() {
    reply=(
        $(cat $HOME/.lego/cmds.cache | xargs echo)
    )
}
compctl -K list_lego_completions o

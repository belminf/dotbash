#!/bin/bash

function tmux_ssh() {
  local finish_tmux_setup=false

  # Exit if I don't have args
  if [[ $# -lt 1 ]]; then

    tmux_cmd="new-window"
    while read -r line; do
      for h in $line; do
        tmux $tmux_cmd "ssh $h"
        tmux_cmd="split-window -h"
        finish_tmux_setup=true
      done
    done

  else

    tmux_cmd="new-window"
    for h in "$@"; do
      tmux $tmux_cmd "ssh $h"
      tmux_cmd="split-window -h"
      finish_tmux_setup=true
    done
  fi

  [[ $finish_tmux_setup ]] || return

  tmux command-prompt -p "window name:" "rename-window '%%'"
  tmux select-layout tiled
  tmux set-window-option synchronize-panes
}

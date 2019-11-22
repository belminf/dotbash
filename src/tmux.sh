#!/bin/bash

function tmux-ssh() {
  local tmux_cmd ssh_cmd finish_tmux_setup

  ssh_cmd="ssh"
  finish_tmux_setup=false

  # Exit if I don't have args
  if [[ $# -lt 1 ]]; then

    tmux_cmd="new-window"
    while read -r line; do
      for h in $line; do
        tmux $tmux_cmd "$ssh_cmd $h"
        tmux_cmd="split-window -h"
        finish_tmux_setup=true
      done
    done

  else

    tmux_cmd="new-window"
    for h in "$@"; do
      tmux $tmux_cmd "$ssh_cmd $h"
      tmux_cmd="split-window -h"
      finish_tmux_setup=true
    done
  fi

  [[ $finish_tmux_setup ]] || return

  tmux select-layout tiled
  tmux set-window-option window-status-format "#F:#I:mssh:%1"
  tmux set-window-option window-status-current-format "#F:#I:mssh:%1"
  tmux set-window-option synchronize-panes
}

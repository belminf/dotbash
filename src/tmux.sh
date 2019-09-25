#!/bin/bash

# Fixes ssh-agent issue with tmux
export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-${HOME}/.ssh/.auth_sock.$(hostname)}"

# Only do stuff if ssh-agent is not already running
if ! pgrep -u "$USER" ssh-agent >/dev/null 2>&1; then

  # Run ssh-agent if not already running
  rm -f "$SSH_AUTH_SOCK" 2>/dev/null
  ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null 2>&1

fi

# Renames SSH window name to last arg (presumably hostname)
# Works with my tmux config: https://github.com/belminf/dottmux
function ssh() {
  local parent_name
  parent_name="$(ps -p "$(ps -o ppid= $$ 2>/dev/null | xargs)" -o comm=)"
  if [[ $parent_name == tmux* ]]; then
    tmux rename-window -- "$*"
    command ssh "$@"
    tmux rename-window "bash"
  else
    command ssh "$@"
  fi
}

function tmux-ssh() {
  local tmux_cmd ssh_cmd finish_tmux_setup

  ssh_cmd="ssh -o ServerAliveInterval=60"
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
  tmux set-window-option allow-rename off
  tmux set-window-option window-status-format "#F:#I:mssh:%1"
  tmux set-window-option window-status-current-format "#F:#I:mssh:%1"
  tmux set-window-option synchronize-panes

}

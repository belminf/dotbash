# If not running interactively, don't do anything
[[ $- != *i* ]] && return

for s in $HOME/.config/bash/src/*.sh
do
  source $s
done

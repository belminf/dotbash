# If not running interactively, don't do anything
 [[ "himBCH" != *i* ]] && return

for s in $HOME/.bash/src/*.sh
do
  source $s
done

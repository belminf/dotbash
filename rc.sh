# If not running interactively, don't do anything
[[ $- != *i* ]] && return

for s in $HOME/.bash/src/*.sh
do
  source $s
done

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

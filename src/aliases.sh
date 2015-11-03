## Interactive operation
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

## Colors
alias grep='grep --color'
alias egrep='egrep --color=auto'

## Others
alias ll='ls -lh --color=tty'
alias less='less -R'
alias what='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
alias env_update="git -C '${HOME}/.bash' pull; git -C '${HOME}/.vim' pull"

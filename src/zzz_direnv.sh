# Only if direnv is installed
if hash direnv 2> /dev/null
then
    eval "$(direnv hook bash)"
fi

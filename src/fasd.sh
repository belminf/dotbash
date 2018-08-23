# Only if fasd exists
_FASD_TRACK_PWD=1
if hash fasd 2> /dev/null
then
  eval "$(fasd --init auto)"
 
  alias v='f -e vim' # quick opening files with vim
  alias c='fasd_cd -d'
fi

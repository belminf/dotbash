# Only if fasd exists
if hash fasd
then
  eval "$(fasd --init auto)"
 
  alias v='f -e vim' # quick opening files with vim
  alias c='fasd_cd -d'
fi

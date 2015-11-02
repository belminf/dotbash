# SSH pageant
if uname | grep CYGWIN > /dev/null 2>&1
then
  eval $(ssh-pageant -ra /.ssh-pageant)
fi

# SSH pageant
if uname | grep CYGWIN > /dev/null 2>&1
then
  eval $(/usr/local/bin/ssh-pageant -ra /.ssh-pageant)
fi

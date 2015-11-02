# Virtualenv
if which vritaulenvwrapper.sh > /dev/null 2>&1
then
  export WORKON_HOME=$HOME/.virtualenvs
  export PROJECT_HOME=$HOME/projects
  mkdir  2> /dev/null || true
  mkdir  2> /dev/null || true
  export PIP_VIRTUALENV_BASE=$WORKON_HOME
  source $(/usr/bin/virtualenvwrapper.sh)
fi

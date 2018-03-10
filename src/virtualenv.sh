# Virtualenv
if which virtualenvwrapper.sh > /dev/null 2>&1
then
  export WORKON_HOME=$HOME/.virtualenvs
  export PROJECT_HOME=$HOME/projects
  mkdir  $WORKON_HOME 2> /dev/null || true
  mkdir  $PROJECT_HOME 2> /dev/null || true
  export PIP_VIRTUALENV_BASE=$WORKON_HOME
  source $(which virtualenvwrapper_lazy.sh)
fi

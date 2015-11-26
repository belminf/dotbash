# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

for s in $HOME/.bash/src/*.sh
do
  source $s
done

# Installing

## Useful packages
* direnv - directory environments
* fzf - fuzzy search
* fasd - autojump-like
* tmux - terminal multiplexer
* pipenv - Python virtual environments

## Distro-specific
### Arch
```
yay -S direnv fzf fasd tmux python-pipenv
```

### macOS
```
brew install direnv fzf fasd tmux pipenv
```
## Clone config
```
git clone git@github.com:belminf/dotbash.git ~/.bash

# Link .bashrc
mv ~/.bashrc ~/.bashrc.original
ln -s ~/.bash/rc.sh ~/.bashrc
```

# Local config
Keep in `src/local.sh`.

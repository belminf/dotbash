# Installing

## Useful packages
* direnv - directory environments
* fzf - fuzzy search
* tmux - terminal multiplexer
* pipenv - Python virtual environments
* nvim - Neovim editor

## Distro-specific
### Arch
```
yay -S --needed direnv fzf tmux python-pipenv neovim bash-completion pkgfile
sudo systemctl enable pkgfile-update.timer
```

### macOS
```
brew install direnv fzf tmux pipenv neovim bash-completion
brew install gnu-sed --with-default-names
brew install gnu-which --with-default-names
$(brew --prefix)/opt/fzf/install
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

# Miscellaneous
## Chef
To display server enabled via [knife-block](https://github.com/knife-block/knife-block) in the prompt, need the following:

```
curl https://raw.githubusercontent.com/knife-block/knife-block/master/knife-block-prompt.sh -o ~/.knife-block-prompt.sh
```

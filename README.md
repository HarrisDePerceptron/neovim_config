# 💤 LazyVim

My Lazyvim config

### Install Neovim 
https://github.com/neovim/neovim/blob/master/INSTALL.md

### Download and install nerd fonts
https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/UbuntuMono.zip
```
mkdir -p  /.local/share/fonts
cp /path/to/font/*  /.local/share/fonts/
fc-cache -fv
```


### Dependencies

```
sudo apt install xclip
sudo apt install ripgrep
sudo apt install fd-find

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
```


### Node
Preferably install node using `node version manager`

https://github.com/nvm-sh/nvm?tab=readme-ov-file#install--update-script

## The Config

```
cp neovim_config ~/.config/nvim
```

Now restart terminal

### Alias(Optional)
```
#~/.bashrc
...

alias alias vi='nvim'
```

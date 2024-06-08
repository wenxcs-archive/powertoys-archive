#!/bin/bash

script_dir=$(dirname "$0")

if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
    echo "Installing vim-plug"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [[ ! -d ~/.vim/pack/github/start/copilot.vim ]]; then
    echo "Installing copilot.vim"
    git clone https://github.com/github/copilot.vim.git ~/.vim/pack/github/start/copilot.vim
fi 

curl -fLo ~/.vimrc --create-dirs https://raw.githubusercontent.com/wenxcs/powertoys/main/vim/vimrc

vim -c "PlugInstall" -c "qa" > /dev/null 2>&1

# sh -c "$(curl -fsSL https://raw.githubusercontent.com/wenxcs/powertoys/master/vim/setup_vim-unix_like.sh)"

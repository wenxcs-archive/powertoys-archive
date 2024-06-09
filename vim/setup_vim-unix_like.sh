#!/bin/bash

script_dir=$(dirname "$0")
OS_NAME=$(uname)
check_command() {
    local cmd=$1
    if ! command -v "$cmd" &> /dev/null; then
        echo "$cmd is not installed. Exiting."
        exit 1
    fi
}

if [ "$OS_NAME" == "Darwin" ]; then
  echo "[macos] Installing nodejs and vim"
  brew install nodejs vim
elif [ "$OS_NAME" == "Linux" ]; then
  echo "[linux, conda] Installing nodejs and vim"
  conda install conda-forge::nodejs
fi

check_command "vim"
check_command "node"

echo "Installing vim plugins"

if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
    echo "Installing vim-plug"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &>/dev/null
fi

if [[ ! -d ~/.vim/pack/github/start/copilot.vim ]]; then
    echo "Installing copilot.vim"
    git clone https://github.com/github/copilot.vim.git ~/.vim/pack/github/start/copilot.vim &>/dev/null
fi 

curl -fLo ~/.vimrc --create-dirs https://raw.githubusercontent.com/wenxcs/powertoys/main/vim/vimrc &>/dev/null

vim -c "PlugInstall" -c "qa" > /dev/null 2>&1

echo "Vim setup complete"

# sh -c "$(curl -fsSL https://raw.githubusercontent.com/wenxcs/powertoys/master/vim/setup_vim-unix_like.sh)"

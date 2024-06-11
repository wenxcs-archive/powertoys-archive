#!/bin/bash

include_script_from_url() {
    local url=$1
    local tmp_file=$(mktemp)
    if curl -fsSL "$url" -o "$tmp_file"; then
        source "$tmp_file"
        rm "$tmp_file"
    else
        echo "Error: Failed to download script from $url"
        return 1
    fi
}
include_script_from_url "https://raw.githubusercontent.com/wenxcs/powertoys/master/shell/solution/include.sh"

if [ "$OS_NAME" == "Darwin" ]; then
  echo "[macos] Installing nodejs and vim"
  install_tool_with_brew "vim"
  install_tool_with_brew "node"
elif [ "$OS_NAME" == "Linux" ]; then
  echo "[linux] Installing nodejs and vim"
  # latest vim
  sudo apt update
  sudo apt-get install software-properties-common -y
  sudo add-apt-repository ppa:jonathonf/vim
  sudo apt update
  sudo apt install vim -y
  # nodejs for copilot
  curl https://webi.sh/node@lts | sh
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

curl -fLo ~/.vimrc --create-dirs https://raw.githubusercontent.com/wenxcs/powertoys/main/shell/vim/vimrc &>/dev/null

vim -c "PlugInstall" -c "qa" > /dev/null 2>&1

echo "Vim setup complete"
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/wenxcs/powertoys/master/shell/vim/setup_vim-unix_like.sh)"
# Userful vim cmd
# :Copilot auth
# :LspInstallServer pyright


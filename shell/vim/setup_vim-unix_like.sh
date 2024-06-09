#!/bin/bash

#<INCLUDE_BEGIN:pre.sh>
script_dir=$(dirname "$0")
OS_NAME=$(uname)
check_command() {
    local cmd=$1
    if ! command -v "$cmd" &> /dev/null; then
        echo "$cmd is not installed. Exiting."
        exit 1
    fi
}

install_tool_with_brew() {
    local tool=$1
    check_command "brew"
    if ! command -v "$tool" &> /dev/null; then
        echo "$tool is not installed. Installing $tool..."
        brew install "$tool"

        # 再次检查工具是否安装成功
        if command -v "$tool" &> /dev/null; then
            echo "$tool has been installed successfully."
        else
            echo "Failed to install $tool. Exiting."
            exit 1
        fi
    else
        echo "$tool is already installed."
    fi
}
#<INCLUDE_END:pre.sh>

if [ "$OS_NAME" == "Darwin" ]; then
  echo "[macos] Installing nodejs and vim"
  install_tool_with_brew "vim"
  install_tool_with_brew "node"
elif [ "$OS_NAME" == "Linux" ]; then
  echo "[linux] Installing nodejs and vim"
  # latest vim
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


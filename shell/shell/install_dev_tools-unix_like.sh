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
  install_tool_with_brew "vim"
  install_tool_with_brew "node"
  install_tool_with_brew "tmux"
elif [ "$OS_NAME" == "Linux" ]; then
  if command -v conda &> /dev/null ; then
    conda install -y -c conda-forge vim nodejs tmux zsh clang-tools fzf
  fi
fi

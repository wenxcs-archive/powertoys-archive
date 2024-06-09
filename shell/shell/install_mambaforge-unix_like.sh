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
  install_tool_with_brew "miniconda"
elif [ "$OS_NAME" == "Linux" ]; then
  curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh" 
  bash Mambaforge-$(uname)-$(uname -m).sh -b -p "$HOME/.opt/conda" 
  rm Mambaforge-$(uname)-$(uname -m).sh
  $HOME/.opt/conda/bin/conda run -n base conda init zsh
  $HOME/.opt/conda/bin/conda run -n base conda init bash
  # $HOME/.opt/conda/bin/conda run -n base conda config --set changeps1 False
fi

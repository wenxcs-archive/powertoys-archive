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

execute_script_from_github "shell/shell/install_dev_tools-unix_like.sh"
execute_script_from_github "shell/shell/install_mambaforge-unix_like.sh"
execute_script_from_github "shell/shell/setup_git-unix_like.sh"
execute_script_from_github "shell/shell/setup_zsh-unix_like.sh"
execute_script_from_github "shell/vim/setup_vim-unix_like.sh"

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
  install_tool_with_brew "git"
  install_tool_with_brew "gh" 
elif [ "$OS_NAME" == "Linux" ]; then
  sudo apt-get install -y git
  curl -sS https://webi.sh/gh | sh
fi

check_command "git"
check_command "gh"

# Set up git user
git config --global user.email "8460860+wenxcs@users.noreply.github.com"
git config --global user.name "wenxcs"

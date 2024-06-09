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

execute_script_from_github() {
  local script_name=$1
  local base_url="https://raw.githubusercontent.com/wenxcs/powertoys/master/"
  local script_url="$base_url/$script_name"

  # Check if script_name is provided
  if [ -z "$script_name" ]; then
    echo "Error: No script name provided."
    echo "Usage: execute_script_from_github <script_name>"
    return 1
  fi

  # Download and execute the script
  sh -c "$(curl -fsSL $script_url)"

  if [ $? -eq 0 ]; then
    echo "Successfully executed $script_name."
  else
    echo "Failed to execute $script_name."
  fi
}

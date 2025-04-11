#!/bin/bash

set -e

# Function to log messages
log() {
    echo -e "\033[1;32m$1\033[0m"
}

# Function to run with or without sudo
run() {
    if [[ $EUID -ne 0 ]]; then
        sudo "$@"
    else
        "$@"
    fi
}

# Function to check if a command exists
has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

# Auto-install command if missing
auto_install() {
    local cmd=$1
    local pkg=$2

    if has_cmd "$cmd"; then
        return
    fi

    log "Missing dependency: $cmd"

    if $IS_MAC; then
        if has_cmd brew; then
            log "Installing $pkg with brew..."
            brew install "$pkg"
        else
            echo -e "\033[1;31mHomebrew not found. Please install Homebrew first: https://brew.sh\033[0m"
            exit 1
        fi
    elif $IS_LINUX; then
        log "Installing $pkg with apt..."
        run apt-get update
        run apt-get install -y "$pkg"
    else
        echo -e "\033[1;31mUnsupported OS. Please install $pkg manually.\033[0m"
        exit 1
    fi
}

# Detect OS
OS="$(uname -s)"
IS_MAC=false
IS_LINUX=false

if [[ "$OS" == "Darwin" ]]; then
    IS_MAC=true
elif [[ "$OS" == "Linux" ]]; then
    IS_LINUX=true
else
    log "Unsupported OS: $OS"
    exit 1
fi

# Update package manager if Linux
if $IS_LINUX; then
    log "apt update..."
    run apt-get update
fi

log "Checking and installing required dependencies..."

# Core tools
auto_install wget wget
auto_install curl curl
auto_install git git

# Python 3.x and pip
if ! has_cmd python3; then
    log "Python3 not found. Please install Python 3 manually."
    exit 1
fi

PY_VERSION=$(python3 -c 'import sys; print(sys.version_info.major)' 2>/dev/null || echo 0)
if [[ "$PY_VERSION" -ne 3 ]]; then
    log "Python 3 is required but not found."
    exit 1
fi

auto_install pip3 python3-pip

# macOS specific: install brew itself if missing (optional)
if $IS_MAC && ! has_cmd brew; then
    log "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"  # Set up brew in path
fi

check_node_version() {
    if command -v node &>/dev/null; then
        NODE_VER=$(node -v | sed 's/v//' | cut -d. -f1)
        log "Found Node.js version: $NODE_VER"
        if (( NODE_VER < 22 )); then
            log "Node.js version is less than 22. Reinstalling..."
            reinstall_node
        else
            log "Node.js is up to date (>= v22)."
        fi
    else
        log "Node.js is not installed. Installing..."
        reinstall_node
    fi
}

reinstall_node() {
    if $IS_MAC; then
        log "Installing latest Node.js with Homebrew..."
        brew install node
    elif $IS_LINUX; then
        log "Installing Node.js v22 with install_node.sh..."
        chmod +x ./install_node.sh
        bash ./install_node.sh
        # Re-source nvm in case this script continues in same shell
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
    else
        echo -e "\033[1;31mUnsupported OS for Node.js installation.\033[0m"
        exit 1
    fi
}

log "Checking Node.js version..."
check_node_version

log "All required dependencies are installed."

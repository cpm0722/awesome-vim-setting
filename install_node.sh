#!/bin/bash

set -e

# Function to print messages
log() {
    echo -e "\033[1;32m$1\033[0m"
}

log "Checking for existing node installation..."
if command -v node &>/dev/null; then
    log "Node is installed. Removing node..."
    rm -rf /usr/local/bin/node
    rm -rf /usr/local/lib/node_modules
    rm -rf ~/.node
else
    log "Node is not installed."
fi

log "Checking for existing nvm installation..."
if [ -d "${HOME}/.nvm" ]; then
    log "nvm is installed at ${HOME}/.nvm . Removing nvm..."
    rm -rf "${HOME}/.nvm"
    sed -i '/{NVM_DIR}/d' ~/.bashrc ~/.zshrc 2>/dev/null || true
    sed -i '/nvm.sh/d' ~/.bashrc ~/.zshrc 2>/dev/null || true
elif [ -d "/usr/local/nvm" ]; then
    log "nvm is installed at /usr/local/nvm . Removing nvm..."
    rm -rf "/usr/local/nvm"
    sed -i '/{NVM_DIR}/d' ~/.bashrc ~/.zshrc 2>/dev/null || true
    sed -i '/nvm.sh/d' ~/.bashrc ~/.zshrc 2>/dev/null || true
else
    log "nvm is not installed."
fi

# Clean up stale nvm config lines from shell profiles and system files
sed -i '/nvm.sh/d' ~/.bashrc ~/.zshrc ~/.bash_profile ~/.profile 2>/dev/null || true
sed -i '/NVM_DIR/d' ~/.bashrc ~/.zshrc ~/.bash_profile ~/.profile 2>/dev/null || true
# Remove old global reference to /usr/local/nvm/nvm.sh
if grep -q "/usr/local/nvm/nvm.sh" /etc/bash.bashrc; then
    log "Removing reference to /usr/local/nvm/nvm.sh from /etc/bash.bashrc"
    sed -i '/\/usr\/local\/nvm\/nvm.sh/d' /etc/bash.bashrc
fi

log "Installing nvm..."
export -n NVM_DIR
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

log "Installing Node.js v22..."

# Load nvm immediately for this script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
nvm install 22
nvm use 22

log "Node.js v22 has been installed and activated."
node -v
npm -v

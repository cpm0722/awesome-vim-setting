#!/bin/bash

set -e


# Function to print messages
log() {
    echo -e "\033[1;32m$1\033[0m"
}

# Use sudo only if not running as root
run() {
    if [[ $EUID -ne 0 ]]; then
        sudo "$@"
    else
        "$@"
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


log "install dependency ..."
chmod +x install_depdendency.sh
bash install_depdendency.sh
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Load nvm immediately for this script
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
fi

VIM_DIR=${HOME}/.config/nvim

log "Install Neovim ..."
if $IS_MAC; then
    NVIM_FILENAME="nvim-macos-x86_64"
else
    NVIM_FILENAME="nvim-linux-x86_64"
fi
wget https://github.com/neovim/neovim/releases/download/stable/$NVIM_FILENAME.tar.gz
tar -xzf $NVIM_FILENAME.tar.gz
rm $NVIM_FILENAME.tar.gz
run rm -rf /opt/nvim
run mv $NVIM_FILENAME /opt/nvim

run rm -f /usr/local/bin/nvim
run ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim

if ! command -v nvim &>/dev/null; then
    log "Error: Neovim (nvim) not found after installation. Exiting."
    exit 1
fi

python3 -m pip install --user --upgrade pynvim

log "Install Lua ..."
if $IS_MAC; then
    brew install lua@5.4
else
    run apt-get install -y lua5.4
fi

log "Install vimrc ..."
if [[ -e ${VIM_DIR} ]]; then
    log "${VIM_DIR} already exists. Backing it up to ${HOME}/.vim_bak"
    rm -rf ${HOME}/.vim_bak
    mv ${VIM_DIR} ${HOME}/.vim_bak
fi

mkdir -p ${VIM_DIR}
cp init.nvim ${VIM_DIR}/init.vim

log "Install colors ..."
mkdir -p ${VIM_DIR}/colors
wget https://raw.githubusercontent.com/joshdick/onedark.vim/main/colors/onedark.vim -O ${VIM_DIR}/colors/onedark.vim
mkdir -p ${VIM_DIR}/autoload
wget https://raw.githubusercontent.com/joshdick/onedark.vim/main/autoload/onedark.vim -O ${VIM_DIR}/autoload/onedark.vim

log "Apply CoC Settings ..."
cp ${PWD}/coc-settings.json ${VIM_DIR}/coc-settings.json
PYTHONPATH=$(which python3)
log "PYTHON3 BINARY: ${PYTHONPATH}"
ESCAPED="${PYTHONPATH//\//\\/}"

if $IS_MAC; then
    sed -i '' "s/\"python.pythonPath\": \"python3\"/\"python.pythonPath\": \"${ESCAPED}\"/" ${VIM_DIR}/coc-settings.json
else
    sed -i "s/\"python.pythonPath\": \"python3\"/\"python.pythonPath\": \"${ESCAPED}\"/" ${VIM_DIR}/coc-settings.json
fi

log "Install vim-plug ..."
curl -fLo ${HOME}/.local/share/nvim/site/autoload/plug.vim \
    --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

log "Install ctags ..."
if $IS_MAC; then
    brew install ctags
else
    run apt-get install -y exuberant-ctags
fi

log "Install Language Server Dependencies ..."
pip3 install -q autopep8 flake8
npm install -g bash-language-server
npm install -g eslint eslint-plugin-vue -D
npm install -g dockerfile-language-server-nodejs

if $IS_MAC; then
    brew install ccls
else
    run apt-get install -y ccls
fi

nvim -c 'PlugInstall' -c 'qa!'

log "Apply CoC Python Snippets ..."
mkdir -p ${HOME}/.config/coc/ultisnips
cp ${PWD}/snippets/* ${HOME}/.config/coc/ultisnips/

log "alias vim=nvim ..."
run ln -sf $(which nvim) /usr/local/bin/vim

log "Install CoC Language Servers ..."
echo ':CocInstall -sync coc-snippets coc-pyright coc-json coc-java coc-tsserver coc-html coc-css coc-vetur coc-cmake|q' > coc_install.vim
nvim -s coc_install.vim
rm coc_install.vim

log "awesome-vim-setting is finished!"

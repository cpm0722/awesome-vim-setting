#!/bin/bash

set -e

if [ "$(uname -s)" == "Darwin" ]; then
  echo "You are using MacOS."
  # Your macOS script here
  OS_TYPE="MAC"
  INSTALLER=brew
  INSTALLER_OPTION="-q"
  SED="gsed"
  export HOMEBREW_NO_AUTO_UPDATE=1
else
  if grep -q 'Ubuntu' /etc/os-release; then
    echo "You are using Ubuntu."
    OS_TYPE="UBUNTU"
    INSTALLER=apt-get
    INSTALLER_OPTION="-y -q"
    SED="sed"
    ${INSTALLER} update
  elif grep -q 'Debian' /etc/os-release; then
    echo "You are using Debian."
    OS_TYPE="UBUNTU"
    INSTALLER=apt-get
    INSTALLER_OPTION="-y -q"
    SED="sed"
    ${INSTALLER} update
  else
    echo "You are using Linux but not Ubuntu."
    exit 1
  fi
fi
echo ""


if [[ ${OS_TYPE} == "UBUNTU" ]]; then
    vim --version | head -1
    echo "Upgrade Vim ..."
    echo ""
    ${INSTALLER} install ${INSTALLER_OPTION} software-properties-common
    add-apt-repository -y ppa:jonathonf/vim && \
        ${INSTALLER} update ${INSTALLER_OPTION} && \
        ${INSTALLER} install ${INSTALLER_OPTION} vim
    echo ""
    vim --version | head -1
    echo ""
elif [[ ${OS_TYPE} == "MAC" ]]; then
    echo "Upgrade Vim ..."
    ${INSTALLER} reinstall ${INSTALLER_OPTION} vim
    echo ""
    echo "Install gsed ..."
    ${INSTALLER} install ${INSTALLER_OPTION} ${SED}
    echo ""
fi


if [[ $(which pip3) ]]; then
    PIP=$(which pip3)
    echo "Use pip ${PIP}"
elif [[ $(which pip) ]]; then
    PIP=$(which pip)
    echo "Use pip ${PIP}"
else
    echo "There is no pip or pip3. Please Install python3-pip."
    exit 1
fi


echo "Install Vundle.vim ..."
VIM_DIR=${HOME}/.vim
if [[ -e ${VIM_DIR} ]]; then
    echo "${VIM_DIR} is already exists. Back-up ${VIM_DIR} file into ${HOME}/.vim_bak"
    rm -rf ${HOME}/.vim_bak
    mv ${VIM_DIR} ${HOME}/.vim_bak
fi
mkdir -p ${VIM_DIR}
mkdir -p ${VIM_DIR}/bundle
rm -rf ${VIM_DIR}/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ${VIM_DIR}/bundle/Vundle.vim
echo ""


echo "Install colors ..."
mkdir -p ${VIM_DIR}/colors
wget https://raw.githubusercontent.com/joshdick/onedark.vim/main/colors/onedark.vim -O ${VIM_DIR}/colors/onedark.vim

mkdir -p ${VIM_DIR}/autoload
wget https://raw.githubusercontent.com/joshdick/onedark.vim/main/autoload/onedark.vim -O ${VIM_DIR}/autoload/onedark.vim
echo ""


echo "Install Node.js ..."

function check_node_version() {
    target_major=22

    # Get current Node.js version, removing the leading 'v'
    current_version=$(node -v | sed 's/v//')

    # Break current version into components
    current_major=$(echo $current_version | cut -d. -f1)

    # Compare major version component only
    if [ $current_major -lt $target_major ]; then
        return 1
    else
        return 0
    fi
}

NODE_MAJOR_VERSION="22"
if [[ ${OS_TYPE} == "UBUNTU" ]]; then
    if NODE_PATH=$(which node); then
        if [[ check_node_version ]]; then # if current node version is less then 17.x.x
            # remove node
            rm -f /etc/apt/sources.list.d/nodesource.list && \
            apt --fix-broken install && \
            apt update && \
            apt remove -y nodejs nodejs-doc && \
            apt autoremove -y
        fi
    fi
    if [[ -n ${NVM_DIR} ]]; then
        rm -rf ${NVM_DIR}
        export -n NVM_DIR
    fi
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    # download and install Node.js (you may need to restart the terminal)
    nvm install ${NODE_MAJOR_VERSION}
    export PATH=/usr/local/nvm/versions/node/*/bin/node:${PATH}
    echo 'export PATH=/usr/local/nvm/versions/node/*/bin/node:${PATH}' >> ${HOME}/.bashrc
elif [[ ${OS_TYPE} == "MAC" ]]; then
    ${INSTALLER} install ${INSTALLER_OPTION} node@${NODE_MAJOR_VERSION}
fi
echo ""


echo "Install Language Server Dependencies ..."
${PIP} install -q autopep8 flake8                      # Python Language Server dependency
${INSTALLER} install ${INSTALLER_OPTION} ccls       # C/C++ langauge server dependency
npm install -g bash-language-server                 # bash langauge server dependency
npm install -g eslint eslint-plugin-vue -D          # vue langauge server dependency
npm install -g dockerfile-language-server-nodejs    # dockerfile langauge server dependency
echo ""


echo "Install CoC.nvim ..."
git clone https://github.com/neoclide/coc.nvim.git -b release ~/.vim/bundle/coc.nvim
echo ""


echo "Install ctags ..."
if [[ ${OS_TYPE} == "UBUNTU" ]]; then
    ${INSTALLER} install ${INSTALLER_OPTION} exuberant-ctags
elif [[ ${OS_TYPE} == "MAC" ]]; then
    ${INSTALLER} install ${INSTALLER_OPTION} ctags
fi
echo ""


echo "Apply .vimrc ..."
if [[ -e ${HOME}/.vimrc ]]; then
    echo "${HOME}/.vimrc is already exists. Back-up ${HOME}/.vimrc file into ${HOME}/.vimrc_bak"
    mv ${HOME}/.vimrc ${HOME}/.vimrc_bak
fi
cp ${PWD}/vimrc ${HOME}/.vimrc
vim -c 'PluginInstall' -c 'qa!'
echo ""


echo "Install CoC Language Servers ..."
echo ':CocInstall -sync coc-snippets coc-pyright coc-json coc-java coc-tsserver coc-html coc-css coc-vetur coc-cmake|q' > coc_install.vim
vim -s coc_install.vim
rm coc_install.vim


echo "Apply CoC Settings ..."
cp ${PWD}/coc-settings.json ${VIM_DIR}/coc-settings.json
PYTHONPATH=$(which python3)
echo "PYTHON3 BINARY: ${PYTHONPATH}"
ESCAPED="${PYTHONPATH//\//\\/}"
${SED} -i "s/\"python.pythonPath\": \"python3\"/\"python.pythonPath\": \"${ESCAPED}\"/" ${VIM_DIR}/coc-settings.json
echo ""


echo "Apply CoC Python Snippets ..."
mkdir -p ${HOME}/.config/coc/ultisnips
cp ${PWD}/snippets/* ${HOME}/.config/coc/ultisnips/
echo ""

echo "awesome-vim-setting is finished!"

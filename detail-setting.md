# vim setting detail

## Basic Setting

### color scheme

- git repo: https://github.com/joshdick/onedark.vim

- `vimrc`

    ```
    # ~/.vimrc

    colorscheme onedark
    ```

- `~/.vim/colors/onedark.vim`, `~/.vim/autoload/onedark.vim` 필요

    ```bash
    # install.sh

    VIM_DIR=${HOME}/.vim

    mkdir -p ${VIM_DIR}/colors
    wget https://raw.githubusercontent.com/joshdick/onedark.vim/main/colors/onedark.vim -o ${VIM_DIR}/colors/onedark.vim

    mkdir -p ${VIM_DIR}/autoload
    wget https://raw.githubusercontent.com/joshdick/onedark.vim/main/autoload/onedark.vim -o ${VIM_DIR}/autoload/onedark.vim
    ```


### global setting

```
# ~/.vimrc

set nocompatible
filetype plugin indent on       " required

if has("syntax")                " syntax highlighting
    syntax on
endif
set encoding=utf-8              " default encoding: utf-8
set termencoding=utf-8
set fileencodings=utf-8,cp949,default,latin1

set noswapfile                  " disable .swp file

set number                      " print line number
set numberwidth=4               " line number column's width

set title                       " print file name in bottom bar
set ruler                       " print cursor location in bottom bar
set laststatus=2                " always show status in bottom bar

set hlsearch                    " search result highlighting
set incsearch                   " search result highlighting update while typing a character
set nowrapscan                  " do not search over and over
set ignorecase smartcase        " distinct lower/upper case in search

set showmatch                   " highlight matching bracket
set nocursorline                " do not create empty line for cursor locating
set cursorline                  " highlight current line
set synmaxcol=9999               " disable syntax highlighting for performance (large size file)

set autoindent                  " auto indent
set smartindent                 " smart indent
set shiftwidth=4                " indent width: 4
set tabstop=4                   " tab width: 4
set softtabstop=4               " tab width: 4
set expandtab                   " replace tab to space when saving
set nowrap                      " do not auto line breaking

set backspace=indent,eol,start  " enable backspace in insert mode
set list listchars=tab:▸\ ,trail:·,precedes:←,extends:→ " indicate tab & space

" remember last cursor position, (when open file, move the cursor to that position)
if has("autocmd")
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal g'\"" |
    \ endif
endif
```

- `set noswapfile`
    - `vim`이 비정상 종료된 경우 남아있는 `*.swp` file을 생성되지 않도록 함
- `set synmaxcol=9999`
    - file 길이가 매우 긴 경우
- `set backspace=indent,eol,start`
    - backspace key를 insert mode에서 사용 가능하도록
- `set list listchars=tab:▸\ ,trail:·,precedes:←,extends:→`

    ![08-27-2023-17 58 45](https://github.com/cpm0722/awesome-vim-setting/assets/18459502/47e3d91a-29e0-442d-b090-a4e58150504b)

    - `‘\t’`는 `▸`로 표시 (1행)
    - line 끝에 위치한 `‘ ‘`는 `·`로 표시 (2행)
- `if has(”autocmd”) ...`
    - file을 닫았을 때의 cursor 위치를 기억한 후, 다음에 해당 file을 열었을 때 cursor를 동일한 위치로 이동시킴
- 그 외 세부 내용은 [Vim documentation: options](https://vimdoc.sourceforge.net/htmldoc/options.html) 참고


### File Types

```
" ======================
" |     FILE TYPES     |
" ======================

" === C / C++ ===
au BufRead,BufNewFile *.c,*.cc,*.cpp,*.h,*.hpp,*.cu set cindent           " C indent
au BufRead,BufNewFile *.c,*.cc,*.cpp,*.h,*.hpp,*.cu set smartindent       " indent disable for preprocessor
au BufRead,BufNewFile *.c,*.cc,*.cpp,*.h,*.hpp,*.cu set shiftwidth=4      " indent width: 4
au BufRead,BufNewFile *.c,*.cc,*.cpp,*.h,*.hpp,*.cu set tabstop=4         " tab width: 4
au BufRead,BufNewFile *.c,*.cc,*.cpp,*.h,*.hpp,*.cu set softtabstop=4     " tab width: 4
au BufRead,BufNewFile *.c,*.cc,*.cpp,*.h,*.hpp,*.cu set noexpandtab       " do not use '\t', replace multiple ' '

" === PYTHON === 
let python_version_3 = 1
let python_highlight_all = 1
au BufRead,BufNewFile *.py set shiftwidth=4
au BufRead,BufNewFile *.py set tabstop=4
au BufRead,BufNewFile *.py set softtabstop=4
" execute python
au FileType python map <f2> : !clear && python3 %<CR>

" === JSON ===
au BufRead,BufNewFile *.json set shiftwidth=4
au BufRead,BufNewFile *.json set tabstop=4
au BufRead,BufNewFile *.json set softtabstop=4
au BufRead,BufNewFile *.json set expandtab

" === HTML / CSS / Javascript ===
au BufRead,BufNewFile *.html,*.css,*.js,*.vue set shiftwidth=2
au BufRead,BufNewFile *.html,*.css,*.js,*.vue set tabstop=2
au BufRead,BufNewFile *.html,*.css,*.js,*.vue set softtabstop=2
au BufRead,BufNewFile *.html,*.css,*.js,*.vue set expandtab

" === Java ===
au BufRead,BufNewFile *.java set shiftwidth=4
au BufRead,BufNewFile *.java set tabstop=4
au BufRead,BufNewFile *.java set softtabstop=4
au BufRead,BufNewFile *.java set expandtab
```

- file 확장자에 따라 서로 다른 indent size 등을 다르게 지정

### Typo alias

```
# ~/.vimrc

command! -bang W w<bang>   " alias :W to :w
command! -bang Q q<bang>   " alias :Q to :q
command! -bang WQ wq<bang> " alias :WQ to :wq
command! -bang Wq wq<bang> " alias :Wq to :Wq
```

- `:w`, `:wq`에서 Shift key로 인해 발생하는 typo를 처리

## Plugins

### Vundle.vim

- git repo: https://github.com/VundleVim/Vundle.vim

- `vimrc` 내에서 `Plugin`을 관리하도록 하는 package

```bash
# install.sh

VIM_DIR=${HOME}/.vim
mkdir -p ${VIM_DIR}
mkdir -p ${VIM_DIR}/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ${VIM_DIR}/bundle/Vundle.vim
```

```
# ~/.vimrc

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'                 " Plugin Vundle
Plugin 'scrooloose/nerdtree'                  " file structure navigator
Plugin 'Xuyuanp/nerdtree-git-plugin'          " nerd tree with git status
Plugin 'blueyed/vim-diminactive'              " split focus highlighting
Plugin 'vim-airline/vim-airline'              " status bar & buffer tab
Plugin 'vim-airline/vim-airline-themes'       " airline themes
Plugin 'airblade/vim-gitgutter'               " git diff marking
Plugin 'tComment'                             " easy comment with (ctrl + -) x2

" Language support
Plugin 'hynek/vim-python-pep8-indent'         " Python auto-indent
Plugin 'preservim/tagbar'                     " C/C++ code navigation
Plugin 'octol/vim-cpp-enhanced-highlight'     " C++ syntax highlighting
Plugin 'JamshedVesuna/vim-markdown-preview'   " Markdown preview
Plugin 'mattn/emmet-vim'                      " HTML auto-complete (,,)
Plugin 'pangloss/vim-javascript'              " JavaScript syntax highlighting / indent
Plugin 'leafgarland/typescript-vim'           " Typescript syntax highlighting / indent
Plugin 'maxmellon/vim-jsx-pretty'             " JSX syntax highlighting

" autocomplete
Plugin 'neoclide/coc.nvim', {'branch': 'release'}

call vundle#end()  " required
```

- `Vundle.vim`이 설치된 상태에서 `:PluginInstall`을 수행할 경우, `~/.vimrc` 내부의 `Plugin`을 찾아 install 수행

### NerdTree

- file explorer plugin
- git repo: https://github.com/scrooloose/nerdtree

- plugin: NERDTree에서 file마다 git status 표시
    - git repo: https://github.com/Xuyuanp/nerdtree-git-plugin

- `vimrc`

    ```
    " NERDTree window 위치: 좌측
    let NERDTreeWinPos = "left"
    " NERDTree 창 열기/닫기: F11
    nmap <F11> :NERDTreeToggle<CR>
    " NERDTree에서 file 선택 후 enter 누를 시: vsplit으로 open
    let NERDTreeCustomOpenArgs = {'file': {'where': 'v', 'keepopen': 1, 'stay': 1}, 'dir': {}}
    " vim 실행 시 NERDTree window open
    autocmd VimEnter * NERDTree  | wincmd p
    " vim 종료 시 NERDTRee window close
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
        \ quit | endif
    " NERDTree에서 무시할 확장자(hidden file): *.out, *.o
    let NERDTreeIgnore = ['\.out$', '\.o$']
    " NERDTree window가 다른 file buffer로 덮어씌워지지 않도록 fix
    autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
        \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
    ```


### vim-diminactive

- split (vsplit / hsplit)으로 여러 file을 열었을 때, 현재 cursor가 위치한 window에 highlight를 주는 plugin
- git repo: https://github.com/blueyed/vim-diminactive


### vim-airline

- 상단 / 하단 status bar를 설정하는 plugin
- git repo: https://github.com/vim-airline/vim-airline

- `vimrc`

    ```
    " 이전 buffer로 이동: , + q
    nmap <leader>q :bp<CR>
    " 다음 buffer로 이동: , + w
    nmap <leader>w :bn<CR>
    " " remove current file buffer
    " 현재 file을 file buffer list에서 제거
    function! CloseCurrentBuffer()
        let l:currentBufferIndex = bufnr('')
        execute 'echo' l:currentBufferIndex
        " move to next file
        execute 'bn'
        execute 'bdelete' l:currentBufferIndex
        " if closed file is the last file, do not move to first file, move to last file
        if bufnr('') == 1
            execute 'bp'
        endif
    endfunction
    nmap <leader>e :call CloseCurrentBuffer()<CR>
    ```


### vim-gitgutter

- file 내에서 git diff를 표시해주는 plugin
- git repo: https://github.com/airblade/vim-gitgutter


### tComment

- vim에서 선택한 block을 주석처리하는 plugin
- git repo: https://github.com/tomtom/tcomment_vim


### emmet-vim

- html tag에 대한 open ~ close를 자동완성해주는 plugin
- git repo: https://github.com/mattn/emmet-vim

- `vimrc`

    ```
    " ',' x 2로 html tag를 자동 완성
    let g:user_emmet_leader_key=','
    ```


### tagbar

- C/C++ project에서 code 구조를 분석 및 navigation해주는 plugin (`ctags` 사용)
- install

    ```bash
    apt-get install ctags
    ```

- git repo: https://github.com/preservim/tagbar

- `vimrc`

    ```
    " tagbar 열고 닫기: , + t
    noremap <leader>t :TagbarToggle<CR>
    ```

- `coc-settings.json`

    ```json
    "ccls": {
    	  "command": "ccls",
    	  "filetypes": ["c", "cc", "cpp", "c++", "objc", "objcpp", "h", "hpp", "cu"],
    	  "rootPatterns": [".ccls", "compile_commands.json", ".git/", ".hg/"],
    	  "initializationOptions": {
    	      "cache": {
    	          "directory": "/tmp/ccls"
    	      },
    	      "compilationDatabaseDirectory": "./build/"
    	  }
    ```

    - `"compilationDatabaseDirectory": "./build/"`
        - `ctags`는 `compile_commands.json` file을 통해 project를 분석함
        - `compile_commands.json`는 대개 `cmake`를 통해 build할 때 아래 option을 주어주는 방식으로 생성
            - `-DCMAKE_EXPORT_COMPILE_COMMANDS=YES`
            - 생성된 `compile_commands.json`은 대개 `project-root-dir/build/`에 위치함

## coc.nvim

- language-server 기반으로 자동완성 및 snippet, linting을 도와주는 plugin
- git repo: https://github.com/neoclide/coc.nvim

- install

    ```bash
    # install.sh

    apt-get install -y -q nodejs

    mkdir -p ~/.vim/bundle
    git clone https://github.com/neoclide/coc.nvim.git -b release ~/.vim/bundle/coc.nvim

    # 이후 vimrc에 coc.nvim Plugin 추가한 뒤, PluginInstall
    ```

- `vimrc`

    ```
    " 자동완성 목록에서 다음 선택지로 이동: tab
    inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#pum#next(1) :
          \ CheckBackspace() ? "\<Tab>" :
          \ coc#refresh()
    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
    " 자동완성 목록에서 이전 선택지로 이동: shift + tab
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

    " 목록에서 현재 위치를 선택: Enter
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    " 이후 diagnostic로 이동: [ + g
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    " 이전 diagnostic으로 이동: ] + g
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " code definition으로 이동: g + d
    nmap <silent> gd <Plug>(coc-definition)
    " code type definition으로 이동: g + y
    nmap <silent> gy <Plug>(coc-type-definition)
    " code implementation으로 이동: g + i
    nmap <silent> gi <Plug>(coc-implementation)
    " code reference로 이동: g + r
    nmap <silent> gr <Plug>(coc-references)

    " symbol의 documentation(prototype)를 확인: shift + k
    nnoremap <silent> K :call ShowDocumentation()<CR>
    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
    endfunction

    " 전체 project에서 해당 symbol rename: r + n
    nmap <leader>rn <Plug>(coc-rename)

    " popup에서 위/아래 scroll: ctrl + u / ctrl + d
    if has('nvim-0.4.0') || has('patch-8.2.0750')
      nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
      nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
      inoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
      inoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
      vnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
      vnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
    endif
    ```

- language server install
    - `coc-settings.json`

        ```json
        {
            "coc.preferences.extensionUpdateCheck": "daily",
            "python.pythonPath": "python3"
            "python.linting.flake8Enabled": true,
            "python.linting.flake8Args": ["--max-line-length=120"],
            "pyright.inlayHints.functionReturnTypes": false,
            "pyright.inlayHints.variableTypes": false,
            "languageserver": {
                "bash": {
                    "command": "bash-language-server",
                    "args": ["start"],
                    "filetypes": ["sh"],
                    "ignoredRootPaths": ["~"]
                },
                "ccls": {
                    "command": "ccls",
                    "filetypes": ["c", "cc", "cpp", "c++", "objc", "objcpp", "h", "hpp", "cu"],
                    "rootPatterns": [".ccls", "compile_commands.json", ".git/", ".hg/"],
                    "initializationOptions": {
                        "cache": {
                            "directory": "/tmp/ccls"
                        },
                        "compilationDatabaseDirectory": "./build/"
                    }
                },
                "dockerfile": {
                    "command": "docker-langserver",
                    "filetypes": ["dockerfile"],
                    "args": ["--stdio"]
                }
            }
        }
        ```

    - install

        ```bash
        # install.sh

        vim -c ':CocInstall coc-snippets coc-pyright coc-json coc-java coc-tsserver coc-html coc-css coc-vetur coc-cmake' -c 'qa!'

        # PYTHONPATH 변경
        cp ${PWD}/coc-settings.json ${VIM_DIR}/coc-settings.json
        PYTHONPATH=$(which python3)
        ESCAPED="${PYTHONPATH//\//\\/}"
        sed -i "s/\"python.pythonPath\": \"python3\"/\"python.pythonPath\": \"${ESCAPED}\"/" ${VIM_DIR}/coc-settings.json
        ```

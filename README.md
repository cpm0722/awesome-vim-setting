# Awesome-vim-setting

## Install

```bash
bash install.sh
```

- Supported OS: Ubuntu / OS-X

## Plugins / Themes / Dependencies

- Vim Plugins
    - [VundleVim/Vundle.vim](https://github.com/VundleVim/Vundle.vim)
    - [scrooloose/nerdtree](https://github.com/preservim/nerdtree)
    - [Xuyuanp/nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin)
    - [blueyed/vim-diminactive](https://github.com/blueyed/vim-diminactive)
    - [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline)
    - [vim-airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)
    - [airblade/vim-gitgutter](https://github.com/airblade/vim-gitgutter)
    - [tComment](https://github.com/tomtom/tcomment_vim)
    - [neoclide/coc.nvim](https://github.com/neoclide/coc.nvim)
    - [hynek/vim-python-pep8-indent](https://github.com/Vimjas/vim-python-pep8-indent)
    - [octol/vim-cpp-enhanced-highlight](https://github.com/octol/vim-cpp-enhanced-highlight)
    - [pangloss/vim-javascript](https://github.com/pangloss/vim-javascript)
    - [leafgarland/typescript-vim](https://github.com/leafgarland/typescript-vim)
    - [maxmellon/vim-jsx-pretty](https://github.com/maxmellon/vim-jsx-pretty)
    - [mattn/emmet-vim](https://github.com/mattn/emmet-vim)
    - [preservim/tagbar](https://github.com/preservim/tagbar)

- Vim Color Themes
    - [joshdick/onedark.vim](https://github.com/joshdick/onedark.vim)

- Dependencies
    - [nodejs/node](https://github.com/nodejs/node)
    - [universal-ctags/ctags](https://github.com/universal-ctags/ctags)

- Language Servers
    - Bash: [bash-lsp/bash-language-server](https://github.com/bash-lsp/bash-language-server)
    - C/C++: [MaskRay/ccls](https://github.com/MaskRay/ccls)
    - CMake: [voldikss/coc-cmake](https://github.com/voldikss/coc-cmake)
    - CSS: [neoclide/coc-css](https://github.com/neoclide/coc-css)
    - Dockerfile: [rcjsuen/dockerfile-language-server-nodejs](https://github.com/rcjsuen/dockerfile-language-server-nodejs)
    - HTML: [neoclide/coc-html](https://github.com/neoclide/coc-html)
    - JAVA: [neoclide/coc-java](https://github.com/neoclide/coc-java)
    - JS/TS: [neoclide/coc-tsserver](https://github.com/neoclide/coc-tsserver)
    - JSON: [neoclide/coc-json](https://github.com/neoclide/coc-json)
    - Python: [fannheyward/coc-pyright](https://github.com/fannheyward/coc-pyright)
    - Vue: [neoclide/coc-vetur](https://github.com/neoclide/coc-vetur)

## keymap (Frequently used)

### vanilla vim ([Vim cheatsheet](https://devhints.io/vim) 참고)
    
- cursor navigation
    - `h` / `j` / `k` / `l`: 상 / 하 / 좌 / 우 이동
    - `w`: 다음 단어의 시작으로 이동
    - `b`: 이전 단어의 시작으로 이동
    - `e`: 다음 단어의 끝으로 이동
    - `ge`: 이전 단어의 끝으로 이동
    - `<SHIFT>6`: 현재 line의 시작으로 이동 (공백 이후)
    - `<SHIFT>4`: 현재 line의 끝으로 이동
    - `0`: 현재 line의 시작으로 이동 (공백 포함)
    - `gg`: file의 첫번째 line으로 이동
    - `G`: file의 마지막 line으로 이동
    - `{number}G`: `{number}`번째 line으로 이동
    - `zz`: 현재 cursor가 screen의 세로 중앙에 위치하도록 scroll
    - `<CTRL>u` / `<CTRL>d`: 위/아래 scroll
- clipboard
    - `x`: 현재 character 잘라내기
    - `dd`: 현재 line 잘라내기
    - `yy`: 현재 line 복사하기
    - `p`: 현재 cursor 이후에 붙여넣기
    - `<SHIFT>p`: 현재 cursor 이전에 붙여넣기
    - `“+y`: system clipboard에 복사하기
    - `“+p`: system clipboard에 붙여넣기
- undo / redo
    - `u`: undo (`<CTRL>+z`)
    - `<CTRL>r`: redo (undo를 되돌리기)
- visual mode
    - `v`: visual mode로 진입
    - `<SHIFT>v`: line visual mode로 진입
    - `d`: 선택한 영역 잘라내기
    - `y`: 선택한 영역 복사하기
- ETC
    - `<SHIFT>k`: 현재 cursor가 위치한 symbol에 대한 man page 확인
    - `<CTRL>[`: `<ESC>` key와 완전히 동일한 역할

### Plugins
- airline
    - `,q` / `,w`: vim 화면 상단 file buffer list에서 이전/이후 file buffer로 이동
    - `,e`: vim 화면 상단 file buffer list에서 현재 file을 제거
- NERDTree
    - `<F11>`: NERDTree window를 open / close
    - `<CTRL>ww`: 다음 split으로 이동 (주로 NERDTree window와 file window 사이 이동할 떄 사용)
    - `o`: NERDTree window에서 해당 file을 열기 (온전하게 한 화면으로 열림)
    - `<ENTER>`: NERDTree window에서 해당 file을 열기 (vsplit으로 열려 가로 이분할이 됨)
    - `,r`: NERDTree window에서 cursor가 위치한 directory에 대한 file list를 갱신 (NERDTree window가 열린 후 추가/삭제/rename된 file이 NERDTree에 반영)
    - `<SHIFT>c`: NERDTree window에서 해당 directory를 root directory로 하도록 tree를 재설정
- tComment
    - `<CTRL>--`: 선택한 block을 주석 처리
- emmet-vim
    - `,,`: html tag의 open ~ close를 자동완성
        - ex) `head,,` => `<head></head>`
- tagbar
    - `,t`: tagbar window를 open / close
- coc
    - `<TAB>` / `<SHIFT><TAB>`: 자동완성 선택지에서 이후 / 이전으로 이동
    - `<ENTER>`: 자동완성 선택지에서 현재 선택지를 선택
    - `[g` / `]g`: 이전 / 이후 diagnostic 위치로 이동
        - diagnostic: linter(`flake8` 등) 규칙에서 어긋난 code line들
    - `gd`: 함수의 definition으로 이동
    - `<SHIFT>k`: 함수의 prototype(header)를 확인
    - `<CTRL>u` / `<CTRL>d`: popup에서 scroll이 필요한 경우, 위/아래 scroll

## Detail Settings
- [detail-setting.md](detail-setting.md)

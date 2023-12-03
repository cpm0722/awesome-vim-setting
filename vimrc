" ======================
" |   GLOBAL SETTING   |
" ======================

colorscheme onedark             " color scheme

set nocompatible
filetype plugin indent on       " required

if has("syntax")                " syntax highlighting
    syntax on
endif
set encoding=utf-8              " default encoding: utf-8
set fileencodings=utf-8,cp949,default,latin1
set termencoding=utf-8

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
set synmaxcol=9999              " disable syntax highlighting for performance (large size file)

set autoindent                  " auto indent
set smartindent
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


" ====================
" |    TYPO ALIAS    |
" ====================

command! -bang W w<bang>   " alias :W to :w
command! -bang Q q<bang>   " alias :Q to :q
command! -bang WQ wq<bang> " alias :WQ to :wq
command! -bang Wq wq<bang> " alias :Wq to :Wq


" ======================
" |      PLUGINS       |
" ======================

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'                 " Plugin Vundle
Plugin 'scrooloose/nerdtree'                  " file structure navigator
Plugin 'Xuyuanp/nerdtree-git-plugin'          " nerd tree with git status
Plugin 'blueyed/vim-diminactive'              " split focus highlighting
Plugin 'vim-airline/vim-airline'              " status bar & buffer tab
Plugin 'airblade/vim-gitgutter'               " git diff marking
Plugin 'vim-airline/vim-airline-themes'       " airline themes
Plugin 'tComment'                             " easy comment with (ctrl + -) x2

" Language support
Plugin 'hynek/vim-python-pep8-indent'         " Python auto-indent
Plugin 'octol/vim-cpp-enhanced-highlight'     " C++ syntax highlighting
Plugin 'pangloss/vim-javascript'              " JavaScript syntax highlighting / indent
Plugin 'leafgarland/typescript-vim'           " Typescript syntax highlighting / indent
Plugin 'maxmellon/vim-jsx-pretty'             " JSX syntax highlighting
Plugin 'mattn/emmet-vim'                      " HTML auto-complete (,,)
Plugin 'preservim/tagbar'                     " C/C++ code navigation

" autocomplete
Plugin 'neoclide/coc.nvim', {'branch': 'release'}

call vundle#end()  " required


let mapleader = ',' " <leader> is ',' key

" ===NERDTREE===
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

" ===DIMINACTIVE===
let g:diminactive_enable_focus = 1

" ===AIRLINE===
" airline theme: zenburn
let g:airline_themes = 'zenburn'
" 상단에 file buffer list를 유지
let g:airline#extensions#tabline#enabled = 1
" 이전 buffer로 이동: , + q
nmap <leader>q :bp<CR>
" 다음 buffer로 이동: , + w
nmap <leader>w :bn<CR>
" 현재 file을 file buffer list에서 제거
" nmap <leader>e :bp\|bd #<CR>
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

" ===GIT-GUTTER===
let g:gitgutter_enabled = 1

" ===CPP-SYNTAX-HIGHLIGHT===
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1
let g:cpp_no_function_highlight = 1

" ===emmet-vim===
" ',' x 2로 html tag를 자동 완성
let g:user_emmet_leader_key=','
let g:loaded_tabline = 0

" ===TAGBAR===
let g:tagbar_autoclose=0
let g:tabar_autofocus=1
" tagbar 열고 닫기: , + t
noremap <leader>t :TagbarToggle<CR>


" ======================
" |        COC         |
" ======================

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

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
inoremap <expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" 목록에서 현재 위치를 선택: Enter
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" 목록 닫기: ; (;가 optional인 python에서만 적옹)
au BufRead,BufNewFile *.py inoremap <silent><expr> ; coc#pum#visible() ? coc#pum#cancel() : ";"

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

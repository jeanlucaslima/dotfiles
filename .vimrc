""""""""""""""""""""
" General
""""""""""""""""""""
set number

" This one everyone adds so I'm adding it (vi compatibility, ik ik)
set nocompatible

" How many lines of history vim has to remember
set history=500

" Vundle requires
filetype off

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" map leader is useful to do extra key combinations
let mapleader = ","

" Fast saving with just ,w
nmap <leader>w :w!<cr>

" Save for sudo with :W (no need to react with sudo)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!



"""""""""""""""""""""""
" Vundle
"""""""""""""""""""""""
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'preservim/nerdtree'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-fugitive'

call vundle#end()  "required

filetype plugin indent on



"""""""""""""""""""""""
" Interface
"""""""""""""""""""""""
" Set 7 lines to the cursor when moving vertically using j/k
set so=7

" Turn on the Wild menu
set wildmenu

" Always show current position
set ruler

" Height of command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Performance: don't redraw while executing macros
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
	autocmd GUIEnter * set vb t_vb=
endif

" Add a bit extra margin to the left
set foldcolumn=1



"""""""""""""""""""""""
" Colors and Fonts 
"""""""""""""""""""""""
" Enable syntax highlighting 
syntax enable

set background=dark
try
	colorscheme desolarized 
catch
endtry

set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac



""""""""""""""""""""""""""""
" Files, backup, and undo 
""""""""""""""""""""""""""""
" Turn backup off, since most stuff is on git, etc...
set nobackup
set nowb
set noswapfile 

set expandtab

set smarttab

set shiftwidth=4
set tabstop=4

set lbr
set tw=500

set ai
set si


set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h`\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c




""""""""""""""""""""""""""""
" Helper functions
""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return''
endfunction


"
function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

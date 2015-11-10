" Vundle setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'git://github.com/gmarik/Vundle.vim.git'
Plugin 'git://github.com/terryma/vim-multiple-cursors'
Plugin 'git://github.com/itchyny/lightline.vim'
Plugin 'git://github.com/sjl/gundo.vim.git'
Plugin 'git://github.com/kevinw/pyflakes-vim.git'
Plugin 'git://github.com/mxw/vim-jsx.git'
Plugin 'git://github.com/nanotech/jellybeans.vim.git'
call vundle#end()
filetype plugin indent on

" General Settings
colorscheme jellybeans      " JellyBeans colorscheme
set smartcase               " Case insensitive search for lower case characters
set hls                     " Highlight search
set number                  " Show line numbers
set fo=tcq                  " FormatOption - (textwidth, comments, allow gq)
set ts=4                    " TabStop - tab is shown with 4 columns
set sw=4                    " ShiftWidth - 4 space identation
set sts=4                   " SoftTabStop Number of spaces a tab counts
set ai                      " AutoIndenting
set wrapmargin=2            " WrapMargin wraps text before reaching 2 columns away from window border
set ruler                   " Show cursor position (lower left side)
set tildeop                 " ~ behaves like and operator
set expandtab               " Use correct number of spaces on tabbing with > <
set visualbell              " Do not beep (bell) when an error occurs
set shell=/bin/bash         " Which shell will be used on shell command
set showcmd                 " Show commands on the last line
set textwidth=79            " Wrap text in 79 columns
set colorcolumn=79          " Highlight the 79th column
set mouse=n                 " Enables use of the mouse
set incsearch               " Show where a matched pattern is
set title                   " Show file that is been edited
set encoding=utf-8          " Encoding
set termencoding=utf-8      " Terminal encoding
set laststatus=2            " Always display status line
syntax on                   " Enable syntax highlighting
let mapleader=' '           " Set which key is the map leader
set t_Co=256                " Use 256 colors

" Highlight trailling whitespaces
set list listchars=tab:\|_,trail:$
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
highlight SpecialKey ctermfg=Red ctermbg=Yellow guibg=Yellow
autocmd BufEnter *.diff highlight SpecialKey ctermfg=red ctermbg=red guibg=black
highlight clear SpellBad
highlight link SpellBad ErrorMsg

" Remove trailling whitespaces when saving
autocmd BufWritePre *.* :%s/\s\+$//e

" Makefile (tabs only)
autocmd BufEnter {Makefile,makefile}* set noexpandtab
autocmd BufEnter {Makefile,makefile}* set nolist

" PostgreSQL editor
autocmd BufEnter psql.edit* set syntax=sql
autocmd BufEnter psql.edit* set nolist

" CSS
autocmd BufEnter *.css* set sts=2
autocmd BufEnter *.css* set ts=2
autocmd BufEnter *.css* set sw=2
autocmd BufEnter *.css* set wrap

" LESS
autocmd BufEnter *.less* set syntax=css
autocmd BufEnter *.less* set sts=2
autocmd BufEnter *.less* set ts=2
autocmd BufEnter *.less* set sw=2
autocmd BufEnter *.less* set wrap

" JSON
autocmd BufEnter *.json set sts=2
autocmd BufEnter *.json set ts=2
autocmd BufEnter *.json set sw=2
autocmd BufEnter *.json set wrap

" Javascript
autocmd BufEnter *.js set sts=2
autocmd BufEnter *.js set ts=2
autocmd BufEnter *.js set sw=2
autocmd BufEnter *.js set wrap

" Javascript
autocmd BufEnter *.jsx set sts=2
autocmd BufEnter *.jsx set ts=2
autocmd BufEnter *.jsx set sw=2
autocmd BufEnter *.jsx set wrap

" HTML
autocmd BufEnter *.html* set sts=2
autocmd BufEnter *.html* set ts=2
autocmd BufEnter *.html* set sw=2
autocmd BufEnter *.html* set nowrap

" SHTML
autocmd BufEnter *.shtml* set sts=2
autocmd BufEnter *.shtml* set ts=2
autocmd BufEnter *.shtml* set sw=2
autocmd BufEnter *.shtml* set nowrap

" Handlebars
autocmd BufEnter *.hbs* set syntax=html
autocmd BufEnter *.hbs* set sts=2
autocmd BufEnter *.hbs* set ts=2
autocmd BufEnter *.hbs* set sw=2
autocmd BufEnter *.hbs* set nowrap

" Gundo Mapping
nnoremap <F9> :GundoToggle<CR>

" Enable sudow
cnoremap sudow w !sudo tee % >/dev/null

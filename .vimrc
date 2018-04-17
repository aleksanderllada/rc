set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'terryma/vim-expand-region'
Plugin 'townk/vim-autoclose'
Plugin 'valloric/youcompleteme'
call vundle#end()

execute pathogen#infect()
call pathogen#helptags()

set backspace=indent,eol,start

"Show line and column
set ruler

"Expand tab to 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

filetype plugin indent on

"Nerdtree shortcuts
let NERDTreeShowHidden=1
autocmd vimenter * NERDTree

"Activate syntax
syntax on

"Automatically init Flake8() for .py files
autocmd BufWritePost *.py call Flake8()

"Automatically go to the right tab (S-Right command)
autocmd vimenter * wincmd l

map <F2> :NERDTreeToggle<cr>
nmap <S-e> :qa<CR>
nmap <S-w> :wa<CR>
nmap <S-Right> <C-w>l
nmap <S-Left> <C-w>h
nmap <S-Up> <C-w>k
nmap <S-Down> <C-w>j

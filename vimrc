set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'terryma/vim-expand-region'
Plugin 'fatih/vim-go'
Plugin 'zimbatm/haproxy.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-syntastic/syntastic'
Plugin 'lfv89/vim-interestingwords'
Plugin 'hashivim/vim-terraform'
Plugin 'hashivim/vim-packer'
Plugin 'dart-lang/dart-vim-plugin'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'tpope/vim-commentary'
Plugin 'groovy.vim'
Plugin 'preservim/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Plugin 'ryanoasis/vim-devicons'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'nordtheme/vim'
Plugin 'ayu-theme/ayu-vim'
Plugin 'ghifarit53/tokyonight-vim'
Plugin 'tpope/vim-fugitive'
Plugin 'gcmt/taboo.vim'
call vundle#end()

"Allow backspace in insert mode
set backspace=indent,eol,start

"Encoding
set encoding=utf-8

"Number of lines above or below the cursor
set scrolloff=10

"Auto read file when changed outside of vim
set autoread

"Reload file on focus gain
au FocusGained,BufEnter * :silent! !

"Disable swap files
set noswapfile

"Show line and column
set ruler

"Smart search
set smartcase

"Expand tab to 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

"Always show tabline
set showtabline=2

"Show numbers
set number

"Use the new regex engine
set re=2

"Activate syntax
syntax on

"Set terminal colors
if (has("termguicolors"))
  set termguicolors
endif

colorscheme ayu

"Synthastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'mode': 'passive' }

"Terraform options
let g:terraform_align=1
let g:terraform_fmt_on_save=1

"Golang options
let g:go_fmt_command="gofmt"
let g:go_imports_autosave=0

"Recognize Jenkinsfile as groovy
au BufNewFile,BufRead Jenkinsfile setf groovy

filetype plugin indent on
autocmd BufEnter * lcd %:p:h

"Nerdtree shortcuts
let NERDTreeShowHidden=1

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

" Open NERDTree when Vim is started without file arguments.
autocmd VimEnter * if argc() == 0 && !exists("b:NERDTree") | NERDTree | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | NERDTreeMirror | endif

" Set NERDTree to open the current file's directory.
autocmd BufReadPost * NERDTreeFind | wincmd p

" Set NERDTree window size
let g:NERDTreeWinSize=40

"Automatically go to the right tab (S-Right command)
autocmd vimenter * wincmd l

"Toggle side bar and numbers on Ctrl+C (copy mode)
function! NumberNo()
  set nonumber
  map <F12> :call NumberYes()<CR>
endfunction
function! NumberYes()
  set number
  map <F12> :call NumberNo()<CR>
endfunction
map <F12> :call NumberNo()<CR>

map <C-c> :NERDTreeToggle<CR><C-w>l<F12>

"Trigger interestingwords plugin
nmap <CR> <Leader>k
nmap <S-c> <Leader>K

"Quit all on Shift+e
nmap <S-e> :qa<CR>

"Close window on Shift+c
nmap <S-c> :q<CR>

"Write all on Shift+w
nmap <S-w> :wa<CR>

"Fuzzy Finder Files on Ctrl+f
nmap <C-f> :Files<CR>

"Fuzzy Finder Lines on Shift+f
nmap <S-f> :Lines<CR>

"Ag search on Shift+g
nmap <S-g> :Ag<CR>

"Git history on Ctrl+h
nmap <C-h> :BCommits<CR>

"Syntastic check on Shift+c
nnoremap <S-c> :SyntasticCheck<CR>

"Move between windows in NerdTree with Shift+Arrows
nmap <S-Right> <C-w>l
nmap <S-Left> <C-w>h
nmap <S-Up> <C-w>k
nmap <S-Down> <C-w>j

"Move between tabs with Ctrl+Arrows
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>

"Comment lines with ctrl + /
nmap <C-_> gcc
vmap <C-_> gc

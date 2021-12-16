call plug#begin()
Plug 'shaunsingh/nord.nvim'
call plug#end()

autocmd!
scriptencoding utf-8
if !1 | finish | endif

set nocompatible

set title

set number
set relativenumber

set expandtab
set autoindent
set smartindent
set ts=4
set sw=4

set noswapfile
set nobackup

set nowrap

set scrolloff=10

set shell=fish

set showcmd
set laststatus=2
set showtabline=2

set incsearch
set ignorecase

set splitbelow
set splitright

set clipboard=unnamed
set undodir=~/.config/nvim/undodir
set undofile

let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_bufsettings='noma nomod nu nowrap ro nobl'

syntax enable
if has('termguicolors')
    set termguicolors
endif

colorscheme nord
hi Normal guibg=NONE ctermbg=NONE

command! -nargs=* T split | res 10 | terminal
command! -nargs=* VT vsplit | terminal
nmap <F1> :echo<CR>
imap <F1> <C-o>:echo<CR>
nnoremap <s-k> i<CR><Esc>l
nmap gn :bn<CR>
nmap gp :bp<CR>
nnoremap H gT
nnoremap L gt
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
tnoremap <Esc> <C-\><C-n>


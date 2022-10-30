call plug#begin()

" aesthetics
Plug 'shaunsingh/nord.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" helpers
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

" git
Plug 'lewis6991/gitsigns.nvim'

" fuzzy finder
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

" motions
Plug 'machakann/vim-sandwich'

" lsp
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
call plug#end()



" general
autocmd!
set nocompatible
scriptencoding utf-8
if !1 | finish | endif

" aesthetics
set number
set relativenumber
syntax enable
if has('termguicolors')
    set termguicolors
endif
colorscheme nord
hi Normal guibg=NONE ctermbg=NONE
lua<<END
require'nvim-web-devicons'.setup {
 color_icons=false;
}
END

" status line
set showcmd
set laststatus=3
set showtabline=0
lua<<END
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'nord',
    component_separators = { left = '', right = ''},
    section_separators = { left = '▓▒░', right = '░▒▓'}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {{'filename', path=1}},
    lualine_x = {},
    lualine_y = {'location'},
    lualine_z = {{'filetype', colored=false, icon_only=true}}
  },
  tabline = {}
}
END

" whitespace
set listchars=tab:>·,trail:~,extends:>,precedes:<
set list

" split preferences
set splitbelow
set splitright

" over length (python)
autocmd BufEnter,WinEnter *.py highlight OverLength guifg=#D8DEE9 guibg=#BF616A
autocmd BufEnter,WinEnter *.py match OverLength /\%80v.*/

" window
set scrolloff=10
set nowrap

" tabs
set expandtab
set autoindent
set smartindent
set ts=4
set sw=4

" searching
set nohlsearch
set incsearch
set ignorecase

" clipboard
set clipboard=unnamed
set undodir=~/.config/nvim/undodir
set undofile

" files
set noswapfile
set nobackup

" terminal
set shell=fish
autocmd TermOpen * setlocal nonumber norelativenumber
autocmd TermOpen * startinsert
command! -nargs=* T split | res 10 | terminal
command! -nargs=* VT vsplit | terminal

" git
set signcolumn=yes:1
highlight clear SignColumn
highlight GitSignsAdd guifg=#8FBCBB
highlight GitSignsChange guifg=#81A1C1
highlight GitSignsDelete guifg=#5E81AC
lua<<END
require'gitsigns'.setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = true,
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 100,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>',
  preview_config = {
    border='none',
  }
}
END
nnoremap <leader>hp <cmd>Gitsigns preview_hunk<cr>
nnoremap <silent><cr> <cmd>Gitsigns next_hunk<cr>
nnoremap <silent><bs> <cmd>Gitsigns prev_hunk<cr>

" fuzzy finder
:lua require('telescope').load_extension('fzf')
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>

" lsp
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "\<Tab>" : coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm(): "\<C-g>u\<cr>\<c-r>=coc#on_enter()\<cr>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
command! -nargs=0 Format :call CocActionAsync('format')

" remaps: split line (opposite of <s-j>)
nnoremap <s-k> i<cr><Esc>l

" remaps: cycle through buffers
nmap gn :bn<cr>
nmap gp :bp<cr>

" remaps: center on some jumps
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz

call plug#begin()

" a e s t h e t i c s
Plug 'shaunsingh/nord.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter'

" utils
Plug 'nvim-lua/plenary.nvim'

" git
Plug 'lewis6991/gitsigns.nvim'

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }

" helpers
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-commentary'

" fuzzy finder
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim', {'tag': '0.1.0'}

call plug#end()



" general
set nocompatible
set updatetime=300
if !1 | finish | endif

" encoding
set encoding=utf-8
set fileencoding=utf-8

" aesthetics
set number
set relativenumber
syntax on
if has('termguicolors')
  set termguicolors
endif
colorscheme nord
highlight Normal guibg=NONE
lua<<END
require'nvim-web-devicons'.setup{color_icons=false}
require'nvim-treesitter.configs'.setup{
  ensure_installed = { "python" },
  highlight = {
    enable = true,
  }
}
END

" command line
set cmdheight=1
set noshowmode

" status/win/tab line
function Empty()
  return ""
endfunction
set laststatus=3
set statusline=%{%Empty()%}
highlight StatusLine guibg=NONE
lua<<END
require'lualine'.setup{
  options = {
    icons_enabled = true,
    theme = 'nord',
    component_separators = { left = '', right = ''},
    section_separators = { left = '▓▒░ ', right = '░▒▓'},
    disabled_filetypes = {'term'},
    refresh = {
      statusline = 400,
      tabline = 400,
      winbar = 400,
    },
  },
  tabline = {
    lualine_a = {'mode'},
    lualine_b = {
      {'filetype', colored=false, icon_only=true},
      {'filename', path=1, shorting_target=0, symbols={modified='+ ',readonly= '- ',unnamed='',newfile=''}},
      {'%l,%c,%p'},
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {
      {'diff', colored=false},
      'branch',
    },
    lualine_z = {},
  },
  sections = {},
  inactive_sections = {},
  winbar = {},
  inactive_winbar = {},
}
require'lualine'.hide({place = {'statusline', 'winbar'}, unhide = false})
END
function RefreshLuaLine(timerID)
  silent redrawtabline
endfunction
call timer_start(1000, 'RefreshLuaLine', {'repeat': -1})

" highlight overlength lines and extra whitespace
highlight OverLength guifg=#D8DEE9 guibg=#3B4252
augroup python_col_hl
  autocmd!
  autocmd BufRead *.py match OverLength /\%80v.*/
augroup END

" split preferences
set splitbelow
set splitright

" window
set scrolloff=5
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
set shell=/usr/bin/fish
augroup term_settings
  autocmd!
  autocmd TermOpen * setlocal nonu nornu scl=no | startinsert
augroup END
nnoremap T <cmd>split<cr><c-w><s-j><cmd>res 10<cr><cmd>terminal<cr>
tnoremap <Esc> <C-\><C-n>
nnoremap tr :res10<cr>
nnoremap ty :res40<cr>

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
    ignore_whitespace = true,
  },
  current_line_blame_formatter = '   (<author>)',
  preview_config = {border='none'},
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
set nobackup
set nowritebackup
set signcolumn=yes:1
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "\<Tab>" : coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm(): "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" remaps: split line (opposite of <s-j>)
nnoremap <s-k> i<CR><Esc>l

" remaps: cycle through buffers
nmap gn :bn<cr>
nmap gp :bp<cr>

" remaps: center on some jumps
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz

" whitespace
set listchars=tab:│\ ,leadmultispace:│\ \ \ ,trail:~,extends:⟩,precedes:⟨
set list

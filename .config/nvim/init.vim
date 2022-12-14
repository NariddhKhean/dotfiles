call plug#begin()

" a e s t h e t i c s
Plug 'nariddhkhean/nord.nvim'
Plug 'nariddhkhean/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter'

" utils
Plug 'nvim-lua/plenary.nvim'

" git
Plug 'lewis6991/gitsigns.nvim'

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }

" linters and fixers
Plug 'dense-analysis/ale'
Plug 'psf/black', { 'branch': 'stable' }

" helpers
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-commentary'

" fuzzy finder
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim', {'tag': '0.1.0'}
Plug 'fannheyward/telescope-coc.nvim'

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
set termguicolors
colorscheme nord
highlight Normal guibg=NONE
lua<<END
require'nvim-web-devicons'.setup{color_icons=false}
require'nvim-treesitter.configs'.setup{
  ensure_installed = { "python" },
  highlight = { enable = true },
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
  },
  tabline = {
    lualine_a = {'mode'},
    lualine_b = {
      {'filetype', colored=false, icon_only=true},
      {'filename', path=2, shorting_target=0, symbols={modified='+ ',readonly= '',unnamed='',newfile=''}}
    },
    lualine_c = {},
    lualine_x = {'directory'},
    lualine_y = {{'%l,%c [%p]'}},
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
call timer_start(300, 'RefreshLuaLine', {'repeat': -1})

" highlight overlength lines and extra whitespace
highlight OverLength guifg=#D8DEE9 guibg=#3B4252
augroup python_col_hl
  autocmd!
  autocmd BufRead *.py match OverLength /\%89v.*/
augroup END

" split preferences
set splitbelow
set splitright
set noequalalways

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
set shell=/usr/bin/fish
augroup term_settings
  autocmd!
  autocmd TermOpen * setlocal nonu nornu scl=no | startinsert
augroup END
nnoremap T <cmd>split<cr><c-w><s-j><cmd>res 11<cr><cmd>terminal<cr>
tnoremap <Esc> <C-\><C-n>
nnoremap tr :res11<cr>
nnoremap ty :res40<cr>

" git
set signcolumn=yes:1
highlight clear SignColumn
lua<<END
require'gitsigns'.setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'   },
    change       = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    untracked    = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'   },
  },
  signcolumn = true,
  preview_config = {border='none'},
}
END
nnoremap <leader>hp <cmd>Gitsigns preview_hunk<cr>
nnoremap <leader>hr <cmd>Gitsigns reset_hunk<cr>
nnoremap <leader>hs <cmd>Gitsigns stage_hunk<cr>
nnoremap <silent><cr> <cmd>Gitsigns next_hunk<cr>
nnoremap <silent><bs> <cmd>Gitsigns prev_hunk<cr>

" linters and fixers
nmap <silent> <C-k> <Plug>(ale_previous_wrap)zz
nmap <silent> <C-j> <Plug>(ale_next_wrap)zz

let g:ale_disable_lsp = 1

let g:ale_set_signs = 1
let g:ale_set_highlights = 0

let g:ale_sign_error = ">>"
let g:ale_sign_warning = ">>"
let g:ale_sign_info = ">>"

let g:ale_echo_cursor = 1
let g:ale_cursor_detail = 1
let g:ale_floating_preview = 1
let g:ale_close_preview_on_insert = 1

let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'python': ['pylint', 'flake8'],
\ }
let g:ale_python_pylint_options = '--rcfile ~/.config/ims-config/pylintrc'
let g:ale_python_flake8_options = '--config ~/.config/ims-config/flake8'
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['isort', 'black'],
\ }
let g:ale_python_isort_options = '--settings ~/.config/ims-config/.isort.cfg'
let g:ale_python_black_options = '--preview'

let g:ale_lint_on_text_changed = "normal"
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 1

let g:ale_echo_msg_format = ""
let g:ale_floating_window_border = []
let g:ale_floating_preview_popup_opts = {
\    'border': ["", "", "", " ", "", "", "", " "],
\ }

let g:ale_fix_on_save = 1


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
nmap <silent> gd <Plug>(coc-definition)
nnoremap <leader>a :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
nmap <leader>rn <Plug>(coc-rename)

" fuzzy finder
lua << EOF
require("telescope").setup({
  extensions = {
    coc = {
      prefer_locations = true,
    },
  },
})
require('telescope').load_extension('coc')
require('telescope').load_extension('fzf')
EOF
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>d <cmd>Telescope buffers<cr>
nnoremap <leader>s <cmd>Telescope resume<cr>
nnoremap <silent> gr <cmd>Telescope coc references<cr>

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
nnoremap [m [mzz
nnoremap ]m ]mzz

" whitespace
set fillchars=eob:\ ,
set listchars=tab:│\ ,leadmultispace:│\ \ \ ,trail:~,extends:⟩,precedes:⟨
set list

:syntax on
:set guifont=Monaspace\ Krypton:h19
" Manually source plug.vim (fix for Windows Vim)
if filereadable($HOME . '/.vim/autoload/plug.vim')
  execute 'source' $HOME . '/.vim/autoload/plug.vim'
endif
let mapleader = " "
set number relativenumber
set autoindent
set splitbelow
set splitright
set scrolloff=10
syntax on
set clipboard=unnamedplus,unnamed,autoselect

" remap jk to escape
inoremap jk <Esc>
call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-function'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive'
Plug 'jiangmiao/auto-pairs'
Plug 'kis9a/vimsidian'
" Plug 'github/copilot.vim'
Plug 'ghifarit53/tokyonight-vim'

call plug#end()

set termguicolors

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1

colorscheme tokyonight




" Optional: NERDTree toggle
nnoremap \ :NERDTreeToggle<CR>

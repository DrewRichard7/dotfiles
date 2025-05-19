:syntax on
" :set guifont=Monaspace\ Krypton:h19
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
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'yaegassy/coc-ruff', {'do': 'yarn install --frozen-lockfile'}

call plug#end()

set termguicolors

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1

colorscheme tokyonight




" Optional: NERDTree toggle
nnoremap \ :NERDTreeToggle<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>
"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <leader>mp :MarkdownPreview<CR>
nmap <leader>ms :MarkdownPreviewStop<CR>
nmap <leader>mt :MarkdownPreviewToggle<CR>

nmap <leader>lf :call CocAction('format')<CR>

function! ToggleCocInlayHints()
  execute 'CocCommand document.toggleInlayHint'
  " Coc usually provides feedback or the visual change is immediate.
  " You can add an echo if you want confirmation, but it might be redundant
  " if the hints visually toggle.
  " For example:
  " echo "CoC Inlay Hints Toggled for current buffer"
endfunction

nnoremap <leader>h :call ToggleCocInlayHints()<CR>

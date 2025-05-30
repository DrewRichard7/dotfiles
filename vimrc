
" ------ Global Vim Settings ---------
" set clipboard=unnamedplus,unnamed,autoselect
filetype plugin indent on
let mapleader = " "
set autoindent
set nocompatible
set number relativenumber
set path+=**
set scrolloff=10
set spell
set spelllang=en_us
set splitbelow
set splitright
set termguicolors
set wildmenu
" syntax on


" -------- Plugins (vim-plug) ----------------
call plug#begin(expand('~/vimfiles/plugged'))

Plug 'Chun-Yang/vim-textobj-chunk'
Plug 'bps/vim-textobj-python'
Plug 'christoomey/vim-sort-motion'
Plug 'ghifarit53/tokyonight-vim'
Plug 'github/copilot.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'inkarkat/vim-ReplaceWithRegister'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'kis9a/vimsidian'
Plug 'menisadi/kanagawa.vim'
Plug 'mhinz/vim-startify'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'yaegassy/coc-ruff', { 'do': { -> system('yarn install --frozen-lockfile') } }

call plug#end()

" ---------- Colorscheme ------------
"let g:tokyonight_style = 'night' " available: night, storm
"let g:tokyonight_enable_italic = 1
colorscheme kanagawa

" make background transparent
augroup TransparentBackground
    autocmd!
    " Trigger this after any colorscheme is loaded
     autocmd ColorScheme * call SetTransparentBackground()
 augroup END

function! SetTransparentBackground()
    " Normal text
    highlight Normal ctermbg=NONE guibg=NONE

    " End of buffer
    highlight EndOfBuffer ctermbg=NONE guibg=NONE

    " NonText characters (like tilde ~ for empty lines)
    highlight NonText ctermbg=NONE guibg=NONE

    " Line numbers
    highlight LineNr ctermbg=NONE guibg=NONE
    highlight CursorLineNr ctermbg=NONE guibg=NONE " Background of current line number

    " Sign column (for git signs, linters, etc.)
    highlight SignColumn ctermbg=NONE guibg=NONE

    " Fold column
    highlight FoldColumn ctermbg=NONE guibg=NONE

    " Status line (might want to keep this opaque or style differently)
    " highlight StatusLine ctermbg=NONE guibg=NONE
    " highlight StatusLineNC ctermbg=NONE guibg=NONE

    " Popup menu (for completion, etc.) - be careful, might make it hard to read
    " highlight Pmenu ctermbg=NONE guibg=NONE
    " highlight PmenuSel guibg=NONE " PmenuSel often needs a background for selection
    " highlight PmenuSbar ctermbg=NONE guibg=NONE
    " highlight PmenuThumb ctermbg=NONE guibg=NONE

    " Tab line
    " highlight TabLine ctermbg=NONE guibg=NONE
    " highlight TabLineFill ctermbg=NONE guibg=NONE
    " highlight TabLineSel guibg=NONE " TabLineSel often needs a background

    " Add any other groups you notice still have a background
    " e.g., VertSplit, ColorColumn, Folded
    highlight VertSplit ctermbg=NONE guibg=NONE
    highlight ColorColumn ctermbg=NONE guibg=NONE
    highlight Folded ctermbg=NONE guibg=NONE

    " If you use Neovim's floating windows and want them transparent
    if has('nvim')
    highlight NormalFloat ctermbg=NONE guibg=NONE
    highlight FloatBorder ctermbg=NONE guibg=NONE
    endif
endfunction

" Call it once on startup as well, in case ColorScheme event doesn't fire as expected
" or if you load the colorscheme very early.
if has('vim_starting')
    au VimEnter * call SetTransparentBackground()
else
    call SetTransparentBackground() " For re-sourcing the file
endif


" ------------ Functions & Autocommands -------------
" Store the terminal buffer number globally
let g:my_terminal_bufnr = -1
" function to open a new terminal
function! OpenMyTerminal()
  if exists('g:my_terminal_bufnr') && bufexists(g:my_terminal_bufnr)
    execute 'buffer' g:my_terminal_bufnr
  else
    terminal
    let g:my_terminal_bufnr = bufnr('%')
  endif
endfunction
" function to close new terminal
function! CloseMyTerminal()
  if exists('g:my_terminal_bufnr') && bufexists(g:my_terminal_bufnr)
    execute 'bdelete!' g:my_terminal_bufnr
    let g:my_terminal_bufnr = -1
  endif
endfunction
" Uses previous functions to toggle terminal
function! ToggleMyTerminal()
  if exists('g:my_terminal_bufnr') && bufexists(g:my_terminal_bufnr)
    call CloseMyTerminal()
  else
    call OpenMyTerminal()
  endif
endfunction

" Show line numbers in netrw (the :Explore file browser)
augroup netrw_line_numbers
  autocmd!
  autocmd FileType netrw setlocal number relativenumber
augroup END

" Show relative line numbers in NERDTree
augroup nerdtree_line_numbers
  autocmd!
  autocmd FileType nerdtree setlocal number relativenumber
augroup END

" ----------- Keymaps --------------
 
" remap jk to escape
inoremap jk <Esc>
" exit terminal mode with jk
tnoremap jk <C-\><C-n>

" source current file
nnoremap <leader>xx :source %<CR>
" Plugin keymaps
nnoremap <silent> <leader>pi :PlugInstall<CR>
nnoremap <silent> <leader>pc :PlugClean<CR>

nnoremap <silent> <leader>tr :call OpenMyTerminal()<CR>
nnoremap <silent> <leader>td :call CloseMyTerminal()<CR>
nnoremap <silent> <leader>\ :call ToggleMyTerminal()<CR>
nnoremap <silent> <leader>t :call ToggleMyTerminal()<CR>

nnoremap \ :NERDTreeToggle<CR>
let g:NERDTreeWinSize = 50 " Set the width to 50 characters

nnoremap ee :Explore<CR>

" fuzzy find with fzf and ripgrep
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" center cursor after movment
nnoremap j jzz
nnoremap k kzz
nnoremap G Gzz
nnoremap n nzz
nnoremap N Nzz


" render-markdown keymaps
nnoremap <leader>mp :MarkdownPreview<CR>
nmap <leader>ms :MarkdownPreviewStop<CR>
nmap <leader>mt :MarkdownPreviewToggle<CR>

" format file with CoC
nmap <leader>lf :call CocAction('format')<CR>

" toggle inlay hints
function! ToggleCocInlayHints()
  execute 'CocCommand document.toggleInlayHint'
  " Coc usually provides feedback or the visual change is immediate.
  " You can add an echo if you want confirmation, but it might be redundant
  " if the hints visually toggle.
  " For example:
  " echo "CoC Inlay Hints Toggled for current buffer"
endfunction
nnoremap <leader>h :call ToggleCocInlayHints()<CR>

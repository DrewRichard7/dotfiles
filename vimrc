:set nu rnu
:syntax on
:set autoindent
:set guifont=Monaspace\ Krypton:h19
" remap escape to jk in rapid succession 
inoremap jk <Esc>

" auto closing pairs hard code
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
set clipboard=unnamedplus,unnamed,autoselect
colorscheme elflord

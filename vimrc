call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

"
" Basic/common settings
"

" Colorization/display

" Syntax highlighting!
syntax on
" Colorize for a dark background
set background=light
" 256 colors!
set t_Co=256
let g:solarized_termcolors=256
colorscheme solarized
"colorscheme elflord
" Show ruler line at bottom of each buffer
set ruler
" Show additional info in the command line (very last line on screen) where
" appropriate.
set showcmd
" Always display status lines/rulers
set laststatus=2

" Navigation/search
" Show matching brackets/parentheses when navigating around
set showmatch
" Search incrementally instead of waiting for me to hit Enter
set incsearch
" Search case-insensitively
set ignorecase
" But be smart about it -- if I have any caps in my term, be case-sensitive.
set smartcase
" Don't highlight search terms by default.
set nohls

" Formatting

" Automatically indent based on current filetype
set autoindent
" Don't unindent when I press Enter on an indented line
set preserveindent
" 'smartindenting
set smartindent
" Make tabbing/deleting honor 'shiftwidth' as well as 'softtab' and 'tabstop'
set smarttab
" Use spaces for tabs
set expandtab
" When wrapping/formatting, break at 109 characters.
set textwidth=109
" By default, all indent/tab stuff is 4 spaces, as God intended.
set tabstop=4
set softtabstop=4
set shiftwidth=4
" Default autoformatting options:
" t: automatically hard-wrap based on textwidth
" c: do the same for comments, but autoinsert comment character too
" r: also autoinsert comment character when making new lines after existing
" comment lines
" o: ditto but for o/O in normal mode
" q: Allow 'gq' to autowrap/autoformat comments as well as normal text
" n: Recognize numbered lists when autoformatting (don't explicitly need this,
" was probably in a default setup somewhere.)
" 2: Use 2nd line of a paragraph for the overall indentation level when
" autoformatting. Good for e.g. bulleted lists or other formats where first
" line in a paragraph may have a different indent than the rest.
set formatoptions=tcroqn2
" Try to break on specific characters instead of the very last character that
" might otherwise fit.
set lbr
" keep formating when paste
set paste
" Jump to last known location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif
" Filetype based indent rules
if has("autocmd")
  filetype indent plugin on
endif


autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

"
" Settings for specific filetypes
"

" Ruby and related
autocmd BufNewFile,BufRead Gemfile,Vagrantfile setlocal filetype=ruby
autocmd BufNewFile,BufRead *.tt,*.citrus setlocal filetype=treetop
autocmd FileType ruby setlocal tabstop=2 softtabstop=2 shiftwidth=2 " foldmethod=syntax


" Utility Functions
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

"
" Key mappings
"
let mapleader = ","
"Toggle line numbers and fold column for easy copying:
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
"Strip trailing spaces
nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>

"Editing .vimrc on the fly (with source on write autocommand)
nmap <leader>v :tabedit $MYVIMRC<CR>

" Switching windows made easyier
nmap <C-Left> <C-w>h
nmap <C-Down> <C-w>j
nmap <C-Up> <C-w>k
nmap <C-Right> <C-w>l
nmap <C-S-Left> <C-W>H
nmap <C-S-Down> <C-W>J
nmap <C-S-Up> <C-W>K
nmap <C-S-Right> <C-W>L

" Bubble single lines
"nmap <C-Up> ddkP
"nmap <C-Down> ddp
" Bubble multiple lines
vmap <C-Up> xkP`[V`]
vmap <C-Down> xp`[V`]
"Identation
nmap <Tab> >>
nmap <S-Tab> <<
vmap <Tab> >gv
vmap <S-Tab> <gv
"comments
" #ruby # comments
map ,# :s/^/#/<CR>
" ,< HTML comment
map ,< :s/^\(.*\)$/<!-- \1 -->/<CR><Esc>:nohlsearch<CR>

" --------------------------------------------------------------------------------------------------------
" - * File: .vimrc
" - * Author: itchyny
" - * Last Change: 2014/12/08 00:54:59.
" --------------------------------------------------------------------------------------------------------

" Initial process {{{1
filetype off
if has('vim_starting')
  set rtp^=~/.vim/miv/miv/
endif

" Setting options {{{1
" Encoding
if &encoding !=? 'utf-8' | let &termencoding = &encoding | endif
set encoding=utf-8 fileencoding=utf-8 fileformats=unix,mac,dos
set fileencodings=utf-8,iso-2022-jp-3,euc-jisx0213,cp932,euc-jp,sjis,jis,latin,iso-2022-jp

" Appearance
set number background=dark display=lastline,uhex wrap wrapmargin=0 showbreak= notitle
set showmatch matchtime=1 noshowmode shortmess+=I cmdheight=1 cmdwinheight=10
set noruler rulerformat= laststatus=2 statusline=%t\ %=\ %m%r%y%w[%{&fenc}][%{&ff}][%3l,%3c,%3p]
silent! set cursorline nocursorcolumn colorcolumn= concealcursor=nvc conceallevel=0 showtabline=1
silent! set list listchars=tab:>\ ,nbsp:_ synmaxcol=300 ambiwidth=double breakindent breakindentopt=
if has('gui_running') | set lines=999 columns=999 | else | set t_Co=256 | endif
silent! let [&t_SI,&t_EI] = ["\e]50;CursorShape=1\x7","\e]50;CursorShape=0\x7"]

" Editing
set formatoptions+=mM iminsert=0 imsearch=0 autoread smartindent autoindent shiftwidth=2
set foldclose=all nofoldenable foldlevel=0 foldmarker& foldmethod=indent nopaste pastetoggle= nogdefault
set textwidth=0 expandtab tabstop=2 backspace=indent,eol,start nrformats=hex

" Clipboard
set clipboard=unnamed
if has('unnamedplus') | set clipboard+=unnamedplus | endif

" Cache files
let $CACHE = expand('~/.vim/cache')
silent! set history=500 nobackup viminfo='10,/10,:500,<10,@10,s10,n$CACHE/.viminfo
silent! set nospell spellfile=$CACHE/en.utf-8.add
silent! set swapfile directory=$CACHE/swap,$CACHE,/var/tmp/vim,/var/tmp
silent! set undofile undolevels=1000 undodir=$CACHE/undo,$CACHE,/var/tmp/vim,/var/tmp

" Search
set wrapscan ignorecase smartcase incsearch nohlsearch magic

" Insert completion
silent! set complete& completeopt=menu infercase pumheight=10 noshowfulltag

" Command line
silent! set wildchar=9 nowildmenu wildmode=list:longest wildoptions= wildignorecase
set wildignore=*.?~,*.??~,*.???~,*.~,*.o,*.sw?,*.bak,*.hi,*.pyc,*.aux,*.bbl,*.blg,*.dvi,*.nav,*.snm,*.toc,*.out,*.exe

" Performance
set updatetime=300 timeout timeoutlen=500 ttimeout ttimeoutlen=50 ttyfast lazyredraw

" Bell
set noerrorbells visualbell t_vb=

" External interface
set shell& shellcmdflag& shellpipe=2>&1\ >
let &makeprg = 'if test -f configure; then ./configure && make; elif test -f Makefile -o -f makefile; then make; elif test -f Makefile.am; then autoreconf -i && ./configure && make; fi'

" Enable plugin, indent, syntax {{{1
filetype plugin indent on
silent! syntax enable

" Auto commands {{{1
augroup vimrc
  autocmd!
augroup END

" Maximize the window
autocmd vimrc GUIEnter * silent! simalt ~x

" Move to the directory each buffer
autocmd vimrc BufEnter * silent! lcd %:p:h

" Open Quickfix window automatically
autocmd vimrc QuickfixCmdPost [^l]* leftabove copen | wincmd p | redraw!
autocmd vimrc QuickfixCmdPost l* leftabove lopen | wincmd p | redraw!

" Always open read-only when a swap file is found
autocmd vimrc SwapExists * let v:swapchoice = 'o'

" Automatically set expandtab
autocmd vimrc FileType * exec 'setl ' . (search('^\t.*\n\t.*\n\t', 'n') ? 'no' : '') . 'et'

" Key mappings {{{1
" Increment and decrement
nnoremap + <C-a>
nnoremap - <C-x>

" indentation in visual mode
vnoremap < <gv
vnoremap > >gv|

" swap line/normal visual mode
noremap V v
noremap v V

" yank to the end of line
nnoremap Y y$

" remove spaces at the end of lines
nnoremap <silent> ,<Space> :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

" smart Enter
inoremap <silent> <expr> <CR> (pumvisible()?"\<ESC>o":"\<C-g>u\<CR>")

" diff
nnoremap <silent> <expr> ,d ":\<C-u>".(&diff?"diffoff":"diffthis")."\<CR>"

" save
nnoremap <C-s> :<C-u>w<CR>
inoremap <C-s> <ESC>:<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>

" search
nnoremap <silent> <Esc><Esc> :<C-u>set nohlsearch nopaste<CR>
nnoremap / :<C-u>set hlsearch<CR>/
nnoremap ? :<C-u>set hlsearch<CR>?
nnoremap * :<C-u>set hlsearch<CR>*
nnoremap # :<C-u>set hlsearch<CR>#
nnoremap g* :<C-u>set hlsearch<CR>g*
nnoremap g# :<C-u>set hlsearch<CR>g#

" navigate window
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-x> <C-w>x
nnoremap <expr><C-m> (bufname('%') ==# '[Command Line]' <bar><bar> &l:buftype ==# 'quickfix') ? "<CR>" : "<C-w>j"
nnoremap <C-q> <C-w>

" improve scroll
noremap <expr> <C-b> max([winheight(0) - 2, 1]) . "\<C-u>" . (line("w0") <= 1         ? "H" : "L")
noremap <expr> <C-f> max([winheight(0) - 2, 1]) . "\<C-d>" . (line("w$") >= line('$') ? "L" : "H")
noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "\<C-y>")
noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "\<C-e>")

" Open dot files
execute 'nnoremap \. :edit' resolve(expand('~/.vimrc')) '<CR>'
execute 'nnoremap \; :edit' resolve(expand('~/.vimrc.yaml')) '<CR>'
execute 'nnoremap \, :edit' resolve(expand('~/.zshrc')) '<CR>'

" tab
nnoremap <silent> <C-t> :<C-u>tabnew<CR>
inoremap <silent> <C-t> <ESC>:<C-u>tabnew<CR>
nnoremap <silent> g0 :<C-u>tabfirst<CR>
nnoremap <silent> g$ :<C-u>tablast<CR>

" tag
nnoremap <C-@> <C-t>

" select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" disable EX-mode
map Q <Nop>

" navigation in command line
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" <C-g> in command line
cmap <C-g> <ESC><C-g>

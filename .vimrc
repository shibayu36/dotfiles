" --------------------------------------------------------------------------------------------------------
" - * File: .vimrc
" - * Author: itchyny
" - * Last Change: 2013/11/05 01:21:14.
" --------------------------------------------------------------------------------------------------------

" INITIALIZE {{{
" --------------------------------------------------------------------------------------------------------
set nocompatible
filetype off
scriptencoding utf-8
if !executable(&shell) | set shell=sh | endif
let s:isunix = has('unix')
let s:iswin = has('win16') || has('win32') || has('win64')
let s:iscygwin = has('win32unix')
let s:ismac = !s:iswin && !s:iscygwin && (has('mac') || has('macunix') || has('guimacvim') || system('uname') =~? '^darwin')
let s:fancy = s:ismac && has('multi_byte')
let s:nosudo = $SUDO_USER == ''
let $VIM = expand('~/.vim')
let $CACHE = $VIM.'/.cache'
let $BUNDLE = $VIM.'/bundle'
let s:neobundle_dir = $BUNDLE.'/neobundle.vim'
if filereadable($VIM.'/.vimrc.secret') | source $VIM/.vimrc.secret | endif
augroup Vimrc
  autocmd!
augroup END
" }}}

" Bundles {{{
" neobundle {{{
" --------------------------------------------------------------------------------------------------------
if !isdirectory(s:neobundle_dir)
  if executable('git')
    exec '!mkdir -p '.$BUNDLE.' && git clone https://github.com/Shougo/neobundle.vim '.s:neobundle_dir
  else
    echo 'git not found! Sorry, this .vimrc cannot be completely used without git.'
  endif
else
if has('vim_starting')
  execute 'set runtimepath+='.expand(s:neobundle_dir)
endif
call neobundle#rc(expand($BUNDLE))
NeoBundleFetch 'Shougo/neobundle.vim'
  nnoremap <silent> <S-b><S-b> :<C-u>Unite neobundle/update -log<CR>
" }}}

" Colorscheme {{{
" --------------------------------------------------------------------------------------------------------
NeoBundle 'itchyny/landscape.vim', {'type': 'nosync'}
  colorscheme landscape
  let g:landscape_highlight_url = 1
  let g:landscape_highlight_todo = 1
  let g:landscape_highlight_url_filetype = {'thumbnail': 0}
NeoBundleLazy 'xterm-color-table.vim', {'autoload': {'commands': [{'name': 'XtermColorTable'}]}}
" }}}

" Lightline {{{
" --------------------------------------------------------------------------------------------------------
NeoBundle 'itchyny/lightline.vim', {'type': 'nosync'}
NeoBundle 'itchyny/lightline-powerful', {'type': 'nosync'}
  let g:lightline = {'colorscheme': 'landscape','mode_map':{'c': 'NORMAL'}}
  if s:ismac
    set guifont=Inconsolata\ for\ Powerline:h15
  elseif s:iswin
    set guifont=Inconsolata_for_Powerline:h13:cANSI
  else
    set guifont=Inconsolata\ for\ Powerline\ 12
  endif
  if s:iswin
    set guifontwide=MS_Gothic:h11:cSHIFTJIS
  endif
" }}}

" Complement {{{
" --------------------------------------------------------------------------------------------------------
if has('lua') && v:version > 703
NeoBundle 'Shougo/neocomplete.vim'
NeoBundleLazy 'Shougo/neocomplcache'
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smart_case = 1
  let g:neocomplete#max_list = 1000
  let g:neocomplete#skip_auto_completion_time = "0.50"
  let g:neocomplete#enable_auto_close_preview = 1
  let g:neocomplete#auto_completion_start_length = 1
  let g:neocomplete#max_keyword_width = 50
  let g:neocomplete#data_directory = $CACHE.'/neocomplete'
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#force_overwrite_completefunc = 1
  let g:neocomplete#force_omni_input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplete#force_omni_input_patterns.objc = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplete#force_omni_input_patterns.objcpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  function! s:cancel_popup(key)
    return a:key . neocomplete#cancel_popup()
  endfunction
  function! s:cancel_popup_reverse(key)
    return neocomplete#cancel_popup() . a:key
  endfunction
  function! s:goback_insert(key)
    return "gi" . a:key . neocomplete#cancel_popup()
  endfunction
else
NeoBundle 'Shougo/neocomplcache'
NeoBundleLazy 'Shougo/neocomplete.vim'
  let g:neocomplcache_enable_at_startup = 1
  let g:neocomplcache_enable_smart_case = 1
  let g:neocomplcache_enable_underbar_completion = 1
  let g:neocomplcache_enable_camel_case_completion = 1
  let g:neocomplcache_enable_cursor_hold_i = 0
  let g:neocomplcache_max_list = 350
  let g:neocomplcache_skip_auto_completion_time = "0.50"
  let g:neocomplcache_enable_auto_close_preview = 1
  let g:neocomplcache_auto_completion_start_length = 1
  let g:neocomplcache_max_menu_width = 20
  let g:neocomplcache_max_keyword_width = 50
  let g:neocomplcache_context_filetype_lists = {}
  let g:neocomplcache_temporary_dir = $CACHE.'/neocomplcache'
  if !exists('g:neocomplcache_force_omni_patterns')
    let g:neocomplcache_force_omni_patterns = {}
  endif
  let g:neocomplcache_force_overwrite_completefunc = 1
  let g:neocomplcache_force_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplcache_force_omni_patterns.objc = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplcache_force_omni_patterns.objcpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  function! s:cancel_popup(key)
    return a:key . neocomplcache#cancel_popup()
  endfunction
  function! s:cancel_popup_reverse(key)
    return neocomplcache#cancel_popup() . a:key
  endfunction
  function! s:goback_insert(key)
    return "gi" . a:key . neocomplcache#cancel_popup()
  endfunction
endif
NeoBundle 'Shougo/neosnippet'
  let g:neosnippet#snippets_directory = expand($VIM.'/snippets')
  imap <expr><TAB> neosnippet#expandable_or_jumpable() ?  "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
NeoBundle 'ujihisa/neco-look', {'disabled': !executable('look')}
" }}}

" Unite ( "," ) {{{
" --------------------------------------------------------------------------------------------------------
let mapleader = ","
if s:nosudo
NeoBundle 'Shougo/unite.vim'
  let g:unite_enable_start_insert = 1
  let g:unite_cursor_line_highlight = 'CursorLine'
  let g:unite_source_file_mru_limit = 1000
  let g:unite_source_mru_do_validate = 0
  let g:unite_source_file_mru_filename_format = ':~'
  let g:unite_force_overwrite_statusline = 0
  let g:unite_data_directory = $CACHE.'/unite'
  let g:unite_marked_icon = s:fancy ? '✓' : 'v'
  let g:unite_candidate_icon = '-'
  nnoremap <C-u> :Unite<SPACE>
  nnoremap <silent><C-p> :Unite buffer -buffer-name=buffer<CR>
  nnoremap <silent><C-n> :Unite file/new directory/new -buffer-name=file/new,directory/new<CR>
  nnoremap <silent><S-k> :Unite output:message -buffer-name=output<CR>
  nnoremap <silent><C-o> :Unite file file/new -buffer-name=file<CR>
  nnoremap <silent><C-z> :Unite file_mru -buffer-name=file_mru<CR>
  nnoremap <silent><S-l> :Unite line -buffer-name=line<CR>
  augroup Unite
    autocmd!
    autocmd FileType unite inoremap <silent> <buffer> <C-z> <Nop>
    autocmd FileType unite inoremap <silent> <buffer> <C-o> <Nop>
    autocmd FileType unite nmap <buffer> <C-a> <Plug>(unite_insert_enter)
    autocmd FileType unite nmap <buffer> OA <Plug>(unite_rotate_previous_source)
    autocmd FileType unite nnoremap <buffer> OB <Down>
    autocmd FileType unite nmap <buffer> <Bs> <Plug>(unite_exit)
  augroup END
  autocmd Vimrc FileType unite nmap <silent> <buffer> <ESC><ESC> <Plug>(unite_exit)
NeoBundleLazy 'Shougo/unite-build', {'autoload': {'unite_sources': ['build']}}
  nnoremap <silent><F5> :<C-u>Unite build -buffer-name=build<CR>
NeoBundleLazy 'unite-colorscheme', {'autoload': {'unite_sources': ['colorscheme']}}
NeoBundleLazy 'osyo-manga/unite-highlight', {'autoload': {'unite_sources': ['highlight']}}
NeoBundleLazy 'eagletmt/unite-haddock', {'autoload': {'unite_sources': ['hoogle']}, 'disabled': !executable('hoogle')}
  nnoremap <Leader>h :<C-u>Unite hoogle -buffer-name=hoogle<CR>
  " --| Requirement: hoogle
  " --|   $ cabal install hoogle
  " --|   $ hoogle data
NeoBundleLazy 'h1mesuke/unite-outline', {'autoload': {'unite_sources': ['outline']}}
NeoBundleLazy 'ujihisa/unite-haskellimport', {'autoload': {'unite_sources': ['haskellimport']}}
NeoBundle 'itchyny/unite-eject', {'type': 'nosync'}
NeoBundle 'itchyny/unite-auto-open', {'type': 'nosync'}
NeoBundle 'itchyny/unite-changetime', {'type': 'nosync'}
NeoBundle 'itchyny/vimfiler-preview', {'type': 'nosync'}
  let g:vimfiler_preview_action = 'auto_preview'
  let bundle = neobundle#get('unite.vim')
  function! bundle.hooks.on_post_source(bundle)
    if exists('*unite#custom_source')
      call unite#custom_source('file', 'ignore_pattern', '.*\.\(o\|exe\|dll\|bak\|sw[po]\|hi\|fff\|aux\|toc\|bbl\|blg\|DS_Store\)$')
      call unite#custom_source('haddock,hoogle', 'max_candidates', 20)
    endif
    if exists('*unite#custom_action')
      call unite#custom_action('file', 'eject', g:unite_eject)
      call unite#custom_action('file', 'auto_open', g:unite_auto_open)
      call unite#custom_action('file', 'change_time', g:unite_changetime)
      call unite#custom_action('file', 'auto_preview', g:vimfiler_preview)
    endif
    if exists('*unite#custom_default_action')
      call unite#custom_default_action('file', 'auto_open')
    endif
  endfunction
endif
" }}}

" QuickRun / Filer / Outer world of Vim ( "\\" ) {{{
" --------------------------------------------------------------------------------------------------------
let mapleader = "\\"
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
  \     'windows' : 'echo "Sorry, cannot update vimproc binary file in Windows."',
  \     'cygwin' : 'make -f make_cygwin.mak',
  \     'mac' : 'make -f make_mac.mak',
  \     'unix' : 'make -f make_unix.mak',
  \   },
  \ }
NeoBundle 'thinca/vim-quickrun'
  let g:quickrun_config = {'_': {'runner': 'vimproc', 'runner/vimproc/updatetime': 60, 'split': 'vertical', 'into': 1}}
  let s:quickrun_command_list = map(split('quickrun;cat,javascript;node,roy;roy,qcl;qcl,haskell;runhaskell,bf;bf', ','), 'split(v:val, ";")')
  for [s:ft, s:exe] in s:quickrun_command_list
    execute printf('if executable("%s") | let g:quickrun_config.%s = {"command":"%s"} | endif', s:exe, s:ft, s:exe)
  endfor
  if executable('pandoc')
    let g:quickrun_config.markdown = {'type' : 'markdown/pandoc', 'outputter': 'browser', 'cmdopt': '-s'}
  endif
  if executable('autolatex')
    let g:quickrun_config.tex = {'command' : 'autolatex'}
  elseif executable('platex')
    let g:quickrun_config.tex = {'command' : 'platex'}
  endif
  if executable('man')
    let g:quickrun_config.nroff = {'command': 'man', 'args': " -P cat | tr '\b' '\1' | sed -e 's/.\1//g'", 'filetype': 'man'}
  endif
  if executable('autognuplot')
    let g:quickrun_config.gnuplot = {'command' : 'autognuplot'}
  elseif executable('gnuplot')
    let g:quickrun_config.gnuplot = {'command' : 'gnuplot'}
  endif
  let g:quickrun_config.objc = {'command': 'cc', 'exec': ['%c %s -o %s:p:r -framework Foundation', '%s:p:r %a', 'rm -f %s:p:r'], 'tempfile': '{tempname()}.m'}
  if executable('scad3.exe')
    let g:quickrun_config.spice = {'command': 'scad3.exe', 'exec': ['%c -b %s:t'] }
  endif
  if executable('abcm2ps')
    let g:quickrun_config.abc = {'command': 'abcm2ps', 'exec': ['%c %s -O %s:p:r.ps', 'ps2pdf %s:p:r.ps', 'open %s:p:r.pdf']}
    if executable('abc2midi')
      call extend(g:quickrun_config.abc.exec, ['abc2midi %s -o %s:p:r.mid', 'open %s:p:r.mid'])
    endif
  endif
  nnoremap <silent> <Leader>r :<C-u>QuickRun -outputter/buffer/name "[quickrun output%{tabpagenr()>1?' '.tabpagenr():''}]"<CR>
  nnoremap <silent> <Leader><Leader>r :<C-u>QuickRun >file:temp.dat<CR>
  nnoremap <silent> <Leader>e :<C-u>QuickRun <i <CR>
  nnoremap <silent> <Leader>o :<C-u>QuickRun <i >file:output<CR>
  autocmd Vimrc FileType quickrun nnoremap <silent> <buffer> <ESC><ESC> <ESC>:q!<CR>
  autocmd Vimrc FileType quickrun vnoremap <silent> <buffer> <ESC><ESC> <ESC>:q!<CR>
if s:nosudo
NeoBundle 'Shougo/vimfiler'
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_sort_type = 'TIME'
  let g:vimfiler_safe_mode_by_default = 0
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimfiler_data_directory = $CACHE.'/vimfiler'
  let g:vimfiler_draw_files_limit = 1000
  let g:vimfiler_tree_leaf_icon = s:fancy ? ' ' : '|'
  let g:vimfiler_tree_opened_icon = s:fancy ? '▾' : '-'
  let g:vimfiler_tree_closed_icon = s:fancy ? '▸' : '+'
  let g:vimfiler_file_icon = '-'
  let g:vimfiler_readonly_file_icon = s:fancy ? '✗' : 'x'
  let g:vimfiler_marked_file_icon = s:fancy ? '✓' : 'v'
  nnoremap <silent> <Leader>f :<C-u>VimFilerBufferDir -status -buffer-name=vimfiler -auto-cd<CR>
  nnoremap <silent> <Leader><Leader> :<C-u>VimFilerBufferDir -status -buffer-name=vimfiler -auto-cd<CR>
  let g:vimfiler_execute_file_list = {}
  for s:ft in split('pdf,png,jpg,jpeg,gif,bmp,ico,ppt,html', ',')
    let g:vimfiler_execute_file_list[s:ft] = 'open'
  endfor
  augroup Vimfiler
    autocmd!
    autocmd FileType vimfiler nunmap <buffer> <C-l>
    autocmd FileType vimfiler nunmap <buffer> \
    autocmd FileType vimfiler nnoremap <buffer> <C-l> <ESC><C-w>l
    autocmd FileType vimfiler nmap <buffer> <C-r> <Plug>(vimfiler_redraw_screen)
    autocmd FileType vimfiler nmap <buffer> O <Plug>(vimfiler_sync_with_another_vimfiler)
    autocmd FileType vimfiler nmap <buffer><expr> e vimfiler#smart_cursor_map("\<Plug>(vimfiler_cd_file)", "\<Plug>(vimfiler_edit_file)")
    autocmd FileType vimfiler nnoremap <buffer><silent> t :<C-u>call vimfiler#mappings#do_action('change_time')<CR>
    autocmd FileType vimfiler if filereadable("Icon\r") | silent call delete("Icon\r") | endif
  augroup END
NeoBundle 'Shougo/vinarise'
endif
NeoBundleLazy 'eagletmt/ghci-vim', {'autoload': {'filetypes': ['haskell']}}
  let bundle = neobundle#get('ghci-vim')
  function! bundle.hooks.on_post_source(bundle)
    augroup Ghci
      autocmd!
      autocmd FileType haskell nnoremap <buffer> <Leader>l GhciLoad
      autocmd FileType haskell nnoremap <buffer> <Leader>i GhciInfo
      autocmd FileType haskell nnoremap <buffer> <Leader>t GhciType
    augroup END
  endfunction
NeoBundle 'tyru/open-browser.vim'
  nmap <silent> <Leader>b <Plug>(openbrowser-smart-search)
  vmap <silent> <Leader>b <Plug>(openbrowser-smart-search)
NeoBundle 'mattn/webapi-vim'
NeoBundleLazy 'mattn/googletasks-vim', {'autoload': {'commands': [{'name': 'GoogleTasks'}]}}
" }}}

" vimshell ( ";" ) {{{
" --------------------------------------------------------------------------------------------------------
let mapleader = ";"
NeoBundle 'Shougo/vimshell'
" --| Requirement: vimproc
" --| If you can't use sudo, do:
" --|  $ sudo chmod 4755 /usr/bin/sudo
  let g:vimshell_interactive_update_time = 150
  let g:vimshell_popup_command = 'top new'
  let g:vimshell_split_command = 'vsplit'
  let g:vimshell_prompt_expr = 'escape(fnamemodify(getcwd(), ":~"), "\\[]()?! ")." "'
  let g:vimshell_prompt_pattern = (s:iswin ? '\%(^\f:' : '\%(^[~/]') . '\%(\f\|\\.\)* \|^[a-zA-Z][a-zA-Z .0-9]\+> \|^>>> \)'
  let g:vimshell_scrollback_limit = 1000000000
  let g:vimshell_disable_escape_highlight = 0
  let g:vimshell_force_overwrite_statusline = 0
  let g:vimshell_temporary_directory = $CACHE.'/vimshell'
  let g:vimshell_max_command_history = 1000000
  let g:vimshell_vimshrc_path = expand('~/Dropbox/.files/.vimshrc')
  augroup Vimshell
    autocmd!
    autocmd FileType vimshell iunmap <buffer> <C-h>
    autocmd FileType vimshell iunmap <buffer> <C-k>
    autocmd FileType vimshell iunmap <buffer> <C-l>
    autocmd FileType vimshell iunmap <buffer> <C-w>
    autocmd FileType vimshell nunmap <buffer> <C-k>
    autocmd FileType vimshell nunmap <buffer> <C-l>
    autocmd FileType vimshell nnoremap <buffer> <C-a> <Nop>
    autocmd FileType vimshell nnoremap <buffer> <C-m> <ESC><C-w>j
    autocmd FileType vimshell inoremap <buffer> <C-h> <ESC><C-w>h
    autocmd FileType vimshell inoremap <buffer> <C-j> <ESC><C-w>j
    autocmd FileType vimshell inoremap <buffer> <C-k> <ESC><C-w>k
    autocmd FileType vimshell inoremap <buffer> <C-l> <ESC><C-w>l
    autocmd FileType vimshell inoremap <silent><buffer> ^ <ESC>:call vimshell#execute('cd ../')<CR>:call vimshell#print_prompt()<CR>:call vimshell#start_insert()<CR>
    autocmd FileType vimshell inoremap <buffer> <C-^> <ESC><C-^>
    let s:start_complete = ' "\<ESC>GA" . unite#sources#vimshell_history#start_complete(!0)'
    for s:key in ['<UP>', '<Down>', 'OA', 'OB']
      execute "autocmd FileType vimshell inoremap <buffer> <expr><silent> ".s:key.s:start_complete
      execute "autocmd FileType vimshell nnoremap <buffer> <expr><silent> ".s:key.s:start_complete
    endfor
  augroup END
  nnoremap <silent> <Leader>s :<C-u>VimShellBufferDir<CR>
  nnoremap <silent> <S-h> :<C-u>VimShellBufferDir -popup<CR>
  nnoremap <silent> s :<C-u>VimShellBufferDir<CR>
NeoBundleLazy 'ujihisa/neco-ghc', {'autoload': {'filetypes': ['haskell']}, 'disabled': !executable('ghc-mod')}
  let g:necoghc_enable_detailed_browse = 1
NeoBundleLazy 'eagletmt/ghcmod-vim', {'autoload': {'filetypes': ['haskell']}, 'disabled': !executable('ghc-mod')}
  nnoremap <Leader>g :<C-u>GhcModCheckAsync<CR>
  " --| Requirement: ghc-mod
  " --|  $ cabal install ghc-mod
" }}}

" Commenter / Utility / Matching ( "," ) {{{
" --------------------------------------------------------------------------------------------------------
let mapleader = ","
NeoBundle 'tpope/vim-surround'
  let g:surround_{char2nr('$')} = "$\r$" " for LaTeX
NeoBundle 'tComment'
  augroup tComment
    autocmd!
    autocmd FileType gnuplot call tcomment#DefineType('gnuplot', '# %s')
    autocmd FileType haxe call tcomment#DefineType('haxe', '// %s')
    autocmd FileType meissa call tcomment#DefineType('meissa', '# %s')
    autocmd FileType spice call tcomment#DefineType('spice', '* %s')
  augroup END
  nnoremap <silent> __ :TComment<CR>
  vnoremap <silent> __ :TComment<CR>
  let g:tcommentMapLeader1 = ''
NeoBundleLazy 'Align', {'autoload': {'commands': [{'name': 'Align'}]}}
NeoBundle 'autodate.vim'
  let g:autodate_format = '%Y/%m/%d %H:%M:%S'
NeoBundleLazy 'sjl/gundo.vim', {'autoload': {'commands': [{'name': 'GundoToggle'}]}, 'disabled': !has('python')}
  nnoremap <Leader>g :<C-u>GundoToggle<CR>
  autocmd Vimrc FileType gundo nnoremap <silent> <buffer> <ESC><ESC> :<C-u>GundoToggle<CR>
NeoBundleLazy 'VimCalc', {'type': 'nosync', 'autoload': {'commands': [{'name': 'Calc'}]}, 'disabled': !has('python')}
  autocmd Vimrc FileType vimcalc nnoremap <silent> <buffer> <ESC><ESC><ESC> :<C-u>q<CR>
  nnoremap <silent> <Leader>a :<C-u>Calc<CR>
NeoBundle 'gregsexton/MatchTag'
NeoBundle 'matchit.zip'
NeoBundleLazy 'thinca/vim-scouter', {'autoload': {'commands': [{'name': 'Scouter'}]}}
NeoBundle 'Lokaltog/vim-easymotion'
  let g:EasyMotion_leader_key = '<Leader>'
  let g:EasyMotion_keys = 'asdfwertxcvuiopbnmhjkl'
  let g:EasyMotion_do_shade = 0
  let g:EasyMotion_do_mapping = 0
  nnoremap <silent> <Leader>f :<C-u>call EasyMotion#F(0, 0)<CR>
  nnoremap <silent> <Leader>F :<C-u>call EasyMotion#F(0, 1)<CR>
  nnoremap <silent> <Leader>w :<C-u>call EasyMotion#WB(0, 0)<CR>
  nnoremap <silent> <Leader>W :<C-u>call EasyMotion#WBW(0, 1)<CR>
NeoBundleLazy 'pasela/unite-webcolorname', {'autoload': {'unite_sources': ['webcolorname']}}
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'kien/ctrlp.vim'
  let g:ctrlp_cmd = 'CtrlPMRUFiles'
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_max_depth = 5
  let g:ctrlp_max_files = 300
  let g:ctrlp_mruf_max = 300
  let g:ctrlp_custom_ignore = { 'dir': '\v[\/]\.(git|hg|svn)$', 'file': '\v\.(exe|so|dll|swp|pdf|DS_Store)$', }
  let g:ctrlp_open_new_file = 'r'
  let g:ctrlp_use_caching = 1
  let g:ctrlp_cache_dir = $CACHE.'/ctrlp'
  let bundle = neobundle#get('ctrlp.vim')
  function! bundle.hooks.on_post_source(bundle)
    let path = expand('~')
    let file = g:ctrlp_cache_dir . '/mru/cache.txt'
    silent call writefile(map(readfile(file), "substitute(v:val, '^/home/\\a\\+', path, '')"), file)
  endfunction
NeoBundle 'banyan/recognize_charcode.vim'
NeoBundleLazy 'itchyny/thumbnail.vim', {'type': 'nosync', 'autoload': {'commands': [{'name': 'Thumbnail', 'complete': 'customlist,thumbnail#complete'}]}}
  nnoremap <silent> <Leader>t :<C-u>Thumbnail -here<CR>
  augroup ThumbnailKey
    autocmd!
    autocmd FileType thumbnail nmap <buffer> v <Plug>(thumbnail_start_line_visual)
    autocmd FileType thumbnail nmap <buffer> V <Plug>(thumbnail_start_visual)
    autocmd FileType thumbnail call clearmatches()
  augroup END
NeoBundle 'itchyny/calendar.vim', {'type': 'nosync'}
  nnoremap <silent> <Leader>z :<C-u>Calendar -here<CR>
  let g:calendar_frame = 'unicode'
NeoBundleLazy 'itchyny/dictionary.vim', {'type': 'nosync', 'autoload': {'commands': [{'name': 'Dictionary', 'complete': 'customlist,dictionary#complete'}]}}
  nnoremap <silent> <Leader>y :<C-u>Dictionary -no-duplicate<CR>
  let g:dictionary_executable_path = '~/Dropbox/bin/'
NeoBundle 'itchyny/vim-cmdline-ranges', {'type': 'nosync'}
NeoBundle 'vim-jp/vital.vim'
" }}}

" Syntax {{{
" --------------------------------------------------------------------------------------------------------
NeoBundleLazy 'scrooloose/syntastic', {'autoload': {'filetypes': ['c', 'cpp'], 'functions': ['SyntasticStatuslineFlag']}}
  let g:syntastic_mode_map = { 'mode': 'passive' }
  let g:syntastic_echo_current_error = 0
  let g:syntastic_enable_highlighting = 0
  autocmd Vimrc BufWritePost *.c,*.cpp call s:syntastic()
  function! s:syntastic()
    if exists(':SyntasticCheck') | exec 'SyntasticCheck' | endif
    if exists('*lightline#update') | call lightline#update() | endif
  endfunction
NeoBundleLazy 'mattn/emmet-vim', {'autoload': {'filetypes': ['html']}}
  let g:user_emmet_settings = { 'indentation' : '  ' }
  autocmd Vimrc FileType html,css imap <tab> <plug>(EmmetExpandAbbr)
NeoBundleLazy 'itspriddle/vim-javascript-indent', {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy 'JSON.vim', {'autoload': {'filetypes': ['json']}}
NeoBundleLazy 'html5.vim', {'autoload': {'filetypes': ['html']}}
NeoBundleLazy 'wavded/vim-stylus', {'autoload': {'filetypes': ['stylus']}}
NeoBundleLazy 'groenewege/vim-less', {'autoload': {'filetypes': ['less']}}
NeoBundleLazy 'less.vim', {'autoload': {'filetypes': ['less']}}
NeoBundleLazy 'syntaxm4.vim', {'autoload': {'filetypes': ['m4']}}
NeoBundleLazy 'vim-scripts/jade.vim', {'autoload': {'filetypes': ['jade']}}
NeoBundleLazy 'vim-coffee-script', {'autoload': {'filetypes': ['coffee']}}
NeoBundleLazy 'rest.vim', {'autoload': {'filetypes': ['rest']}}
NeoBundleLazy 'vim-scripts/indenthaskell.vim', {'autoload': {'filetypes': ['haskell']}}
  let hs_highlight_boolean = 1
  let hs_highlight_types = 1
  let hs_highlight_more_types = 1
NeoBundleLazy 'tpope/vim-markdown', {'autoload': {'filetypes': ['m4']}}
NeoBundleLazy 'motemen/hatena-vim', {'autoload': {'filetypes': ['hatena']}}
  let g:hatena_upload_on_write = 0
  let g:hatena_user = 'itchyny'
NeoBundleLazy 'syngan/vim-vimlint', { 'depends' : 'ynkdir/vim-vimlparser', 'autoload' : { 'functions' : 'vimlint#vimlint'}}
" }}}

endif
" }}} Bundles

" ENCODING {{{
" --------------------------------------------------------------------------------------------------------
set encoding=utf-8
set fenc=utf-8
set fileencodings=utf-8,euc-jp,sjis,jis,iso-2022-jp,cp932,latin
set formatoptions+=mM       " 日本語の行の連結時には空白を入力しない
" ☆や□や○の文字があってもカーソル位置がずれないようにする
" ambiwidthの設定のみでは, 解決しない場合がある
" Ubuntuでは, gnome-terminal, terminatorを以下のコマンドに貼り替えると解決する
"   /bin/sh -c "VTE_CJK_WIDTH=1 terminator -m"
"   /bin/sh -c "VTE_CJK_WIDTH=1 gnome-terminal --disable-factory"
" MacのiTermでは, Profiles>Text>Double-Width Characters>Treat ambiguous-width characters as double widthにチェック
set ambiwidth=double
" }}}

" APPERANCE {{{
" --------------------------------------------------------------------------------------------------------
" Frame appearance {{{
set noshowmode " https://github.com/vim-jp/issues/issues/100
" }}}

" Main appearance {{{
set list
if !s:fancy
  set listchars=tab:^I,extends:>,precedes:<,nbsp:%
else
  try
    set listchars=tab:▸\ ,extends:»,precedes:«,nbsp:%
  catch
    set listchars=tab:^I,extends:>,precedes:<,nbsp:%
    let g:vimfiler_tree_leaf_icon = '|'
    let g:vimfiler_tree_opened_icon = '-'
    let g:vimfiler_tree_closed_icon = '+'
  endtry
endif
set shortmess+=I            " disable start up message
set number
  autocmd Vimrc FileType vimshell,vimcalc,quickrun,int-ghci setlocal nonumber buftype=nofile
set cursorline
  autocmd Vimrc WinLeave * setlocal nocursorline
  autocmd Vimrc BufEnter,WinEnter * setlocal cursorline
  autocmd Vimrc FileType calendar,vimcalc,vimshell,quickrun,int-ghci,cam setlocal nocursorline
        \ | autocmd Vimrc BufEnter,WinEnter <buffer> setlocal nocursorline
set nocursorcolumn
" http://blog.remora.cx/2012/10/spotlight-cursor-line.html
let [&t_SI,&t_EI] = ["\e]50;CursorShape=1\x7","\e]50;CursorShape=0\x7"]
set showmatch
set showtabline=1
set previewheight=20
set pumheight=10
set history=1000
set helplang=en
language C
set nospell
  function! s:myspell()
    if !exists('b:myspell_done') || b:myspell_done != &l:spell
      if &l:spell
        let spellbads = [ '^\(\S\+ \+\)\{30,}\S\+[,.]\?$', '\<a\> [aiueo]', '^\$', '\<figure..\?\\', '\\ref{eq:'
              \ , '^\\end{align}', '[^\~]\\\(eq\)\?ref\>', 'does not [a-z]*s ', 's [a-z][a-z]\+s ', '\<a \S\+s ', 'in default']
        let b:myspell_id = []
        for s in spellbads
          call add(b:myspell_id, matchadd('SpellBad', s))
        endfor
      elseif exists('b:myspell_id')
        for i in b:myspell_id
          call matchdelete(i)
        endfor
        unlet b:myspell_id
      endif
      let b:myspell_done = &l:spell
    endif
  endfunction
  function! s:autospell()
    if !exists('b:autospell_done')
      if search("[^\x01-\x7e]", 'n') == 0 && line('$') > 5
        setlocal spell
        call s:myspell()
      else
        setlocal nospell
      endif
      let b:autospell_done = 1
    endif
  endfunction
  autocmd Vimrc FileType tex,markdown call s:autospell()
  autocmd Vimrc BufWritePost * call s:myspell()
set modeline
set modelines=1
set completeopt-=preview
if has('conceal')
  set concealcursor=nvc
  autocmd Vimrc FileType vimfiler set concealcursor=nvc
endif
" }}}

" Status line {{{
set laststatus=2
set statusline=%{expand('%:p:t')}\ %<[%{expand('%:p:h')}]%=\ %m%r%y%w[%{&fenc!=''?&fenc:&enc}][%{&ff}][%3l,%3c,%3p]
" }}}

" Color {{{
syntax enable
set background=dark
set synmaxcol=300
  autocmd Vimrc Filetype cam setlocal synmaxcol=3000
if !has('gui_running') | set t_Co=256 | endif
" }}}

" Statusline color {{{
let s:hi_sl = 'highlight StatusLine '
let s:hi_gui_common = 'guifg=black gui=none '
let s:hi_cterm_common = 'ctermfg=black cterm=none '
let s:hi_normal = s:hi_sl.s:hi_gui_common.s:hi_cterm_common.'guibg=blue ctermbg=blue'
let s:hi_insert = s:hi_sl.s:hi_gui_common.s:hi_cterm_common.'guibg=darkmagenta ctermbg=darkmagenta'
silent execute s:hi_normal
autocmd Vimrc InsertEnter * execute s:hi_insert
autocmd Vimrc InsertLeave * execute s:hi_normal
if has('unix') && !has('gui_running')
  inoremap <silent> <ESC> <ESC>
endif
" }}}
" }}} APPERANCE

" FILE READING {{{
" --------------------------------------------------------------------------------------------------------
" SET {{{
set autoread
" }}}

" Filetype {{{
augroup SetLocalFiletype
  let s:filetypes1 = map(split('bf,gnuplot,jade,json,less,r,roy,tex,meissa,coffee', ','), '[v:val, v:val]')
  let s:filetypes2 = map(split('cls;tex,hs;haskell,hx;haxe,md;markdown,cir;spice,asc;spice,m;objc', ','), 'split(v:val, ";")')
  autocmd!
  for [s:ex, s:ft] in extend(s:filetypes1, s:filetypes2)
    execute 'autocmd BufNewFile,BufReadPost *.' . s:ex . ' setlocal filetype=' . s:ft
  endfor
  autocmd Vimrc BufReadPost,BufWrite,CursorHold,CursorHoldI * call s:auto_filetype()
augroup END
function! s:auto_filetype()
  let newft = ''
  for [pat, ft] in map(split('*[;hatena,#include;c,\documentclass;tex,import;haskell,main =;haskell,diff --;diff', ','), 'split(v:val, ";")')
    if getline(1)[:strlen(pat) - 1] ==# pat | let newft = ft | endif
  endfor
  if newft != '' && (&filetype == '' || &filetype == newft)  | exec 'setlocal filetype=' . newft | endif
endfunction
" }}}

" }}} FILE READING

" EDIT {{{
" --------------------------------------------------------------------------------------------------------
" Search {{{
set infercase
set wrapscan
set ignorecase
set smartcase
set incsearch
set nohlsearch
set magic
" }}}

" Indent {{{
filetype plugin indent on
set autoindent
  autocmd Vimrc FileType tex,hatena setlocal noautoindent
  let g:tex_indent_items=0
set smartindent
  autocmd Vimrc FileType tex,hatena setlocal nosmartindent
set shiftwidth=2
  autocmd Vimrc FileType markdown setlocal shiftwidth=4
" }}}

" Special keys (tab, backspace) {{{
set textwidth=0   " No auto breking line
  autocmd Vimrc FileType rest setlocal textwidth=50
set expandtab
  function! s:autotab()
    if search('^\t.*\n\t.*\n\t', 'n') > 0
      setlocal noexpandtab
    else
      setlocal expandtab
    endif
  endfunction
  autocmd Vimrc FileType * call s:autotab()
set tabstop=2
retab
set backspace=indent,eol,start
" }}}

" Sequencial keys {{{
set timeoutlen=500
" }}}

" Clipboard {{{
if exists('&clipboard')
  set clipboard=unnamed
  if has('unnamedplus')
    set clipboard+=unnamedplus
  endif
endif
" }}}

" Increment {{{
set nrformats-=ocral
"}}}

" Generated files {{{
set swapfile
set nobackup
set viminfo='10,/10,:1000,<10,@10,s10,n$CACHE/.viminfo
" }}}

" }}} EDIT

" UTILITY {{{
" --------------------------------------------------------------------------------------------------------
" On starting vim {{{
if s:iswin
  autocmd Vimrc GUIEnter * simalt ~x
endif
" }}}

" Move to the directory each buffer {{{
autocmd Vimrc BufEnter * silent! lcd `=expand('%:p:h')`
" }}}

" Enable omni completation {{{
augroup Omnifunc
  let s:omnifunc = map(split('c;ccomplete#Complete,css;csscomplete#CompleteCSS,html;htmlcomplete#CompleteTags,javascript;javascriptcomplete#CompleteJS,php;phpcomplete#CompletePHP,python;pythoncomplete#Complete,xml;xmlcomplete#CompleteTags,haskell;necoghc#omnifunc', ','), 'split(v:val, ";")')
  autocmd!
  for [s:ft, s:omnif] in s:omnifunc
    exec 'autocmd FileType ' . s:ft . ' setlocal omnifunc=' . s:omnif
  endfor
augroup END
setlocal omnifunc=syntaxcomplete#Complete
" }}}

" Make with S-F5 key (user omake) {{{
function! Automake()
  if filereadable('OMakefile') && executable('omake')
    execute '!omake'
  elseif filereadable('Makefile') || filereadable('makefile')
    execute '!make all'
  endif
endfunction
nnoremap <silent> <S-F5> :<C-u>call Automake()<CR>
" }}}

" Open file explorer at current directory {{{
function! Explorer()
  silent call system((s:ismac ? 'open -a Finder' : s:iswin ? 'start' : 'nautilus') .' . &')
endfunction
nnoremap <silent> \n :call Explorer()<CR>
" }}}

" Quickly open with outer text editor {{{
function! TextEdit()
  silent call system((s:ismac ? 'open -a TextEdit ' : s:iswin ? 'notepad ' : 'gedit ') . fnameescape(expand('%:p')) . ' &')
endfunction
nnoremap <silent> \g :call TextEdit()<CR>
" }}}

" view syntax name under cursor {{{
command! S echo synIDattr(synID(line('.'), col('.'), 0), 'name')
" }}}

" Quick open dot files {{{
if filereadable(expand('~/Dropbox/.files/.vimrc'))
  nnoremap \. :e ~/Dropbox/.files/.vimrc<CR>
elseif filereadable(expand('~/.vimrc'))
  nnoremap \. :e ~/.vimrc<CR>
endif
if filereadable(expand('~/Dropbox/.files/.zshrc'))
  nnoremap ;. :e ~/Dropbox/.files/.zshrc<CR>
elseif filereadable(expand('~/.zshrc'))
  nnoremap ;. :e ~/.zshrc<CR>
endif
" }}}

" template for blog {{{
nnoremap ,cpp i>\|cpp\|<CR>\|\|<<ESC>
nnoremap ,sh i>\|sh\|<CR>\|\|<<ESC>
nnoremap ,hs i>\|haskell\|<CR>\|\|<<ESC>
nnoremap ,js i>\|javascript\|<CR>\|\|<<ESC>
" }}}

" }}} UTILITY

" OTHERS {{{
" --------------------------------------------------------------------------------------------------------
" Performance {{{
set ttyfast
set updatetime=300
set vb t_vb=
" }}}

" Command line {{{
set wildmode=list:longest
set wildignore+=*.sw?,*.bak,*.?~,*.??~,*.???~,*.~
let s:cmdlist = 'vps;vsp,vp;vsp,nbi;NeoBundleInstall,nbc;NeoBundleClean,nbd;NeoBundleDocs,di;Dictionary<SPACE>-cursor-word,aoff;AutodateOFF,aon;AutodateON,qa1;qa!,q1;q!,nvew;vnew'
for [s:cmd, s:exp] in map(split(s:cmdlist, ','), 'split(v:val, ";")')
  exec 'cabbrev <expr> '.s:cmd.' (getcmdtype() == ":" && getcmdline() ==# "'.s:cmd.'") ? "'.s:exp.'" : "'.s:cmd.'"'
endfor
" }}}

" }}} OTHERS

" KEY MAPPING {{{
" --------------------------------------------------------------------------------------------------------

" edit {{{
" Increment and decrement
nnoremap + <C-a>
nnoremap - <C-x>

" indentation in visual mode
vnoremap < <gv
vnoremap > >gv|

" swap line/normal visual mode
noremap <S-v> v
noremap v <S-v>

" yank to the end of line
nnoremap Y y$

" remove spaces at the end of lines
nnoremap ,<Space> ma:%s/  *$//<CR>`a<ESC>

" smart Enter
inoremap <silent> <expr> <CR> (pumvisible()?"\<ESC>o":"\<C-g>u\<CR>")

" split by 80 characters
nnoremap <silent> ,80 :s/\(.\{80}\)/\1<c-v><Enter>/g<Enter><ESC>:<C-u>set nohlsearch<CR>
vnoremap <silent> ,80 :s/\(.\{80}\)/\1<c-v><Enter>/g<Enter><ESC>:<C-u>set nohlsearch<CR>

" diff
nnoremap ,d :<C-u>diffthis<CR>
" }}}

" file {{{
" save
nnoremap <C-s> :<C-u>w<CR>
inoremap <C-s> <ESC>:<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>
" }}}

" search {{{
nnoremap <silent> <Esc><Esc> :<C-u>set nohlsearch<CR>:<C-u>set nopaste<CR>
nnoremap <silent> / :<C-u>set hlsearch<CR>/
nnoremap <silent> ? :<C-u>set hlsearch<CR>?
nnoremap <silent> * :<C-u>set hlsearch<CR>*
nnoremap <silent> # :<C-u>set hlsearch<CR>#
" }}}

" Navigation {{{
" window
" <C-j> doesn't work, without the setting of <C-m>
for k in ['h', 'j', 'k', 'l', 'x']
  let l = k == 'j' ? 'm' : k
  if l == k && k != 'x' | exec 'inoremap <C-' . l . '> <ESC><C-w>' . k | endif
  exec 'nnoremap <C-' . l . '> <C-w>' . k
  exec 'vnoremap <C-' . l . '> <C-w>' . k
  exec 'nnoremap <C-' . k . '> <C-w>' . k
  exec 'vnoremap <C-' . k . '> <C-w>' . k
endfor
nnoremap <expr><C-m> (bufname('%') ==# '[Command Line]') ? "<CR>" : "<C-w>j"
inoremap <C-q> <ESC><C-w>
nnoremap <C-q> <C-w>
vnoremap <C-q> <ESC><C-w>

" close buffer
let s:winwid = winwidth(0)
function! AutoClose()
  try
    if &filetype == 'quickrun'
      silent bd!
    elseif &filetype == 'gundo'
      silent call feedkeys('q')
    elseif expand('%:t') == '__XtermColorTable__'
      silent bd!
    elseif winwidth(0) < 2 * s:winwid / 3
      silent q
    elseif &filetype == '' && !&modified
      silent q!
    elseif &modified
    elseif &filetype == 'vimshell'
      silent q
    else
      silent bd!
    endif
  catch
  endtry
endfunction
inoremap <silent> <C-w> <ESC>:<C-u>call AutoClose()<CR>
nnoremap <silent> <C-w> :<C-u>call AutoClose()<CR>
vnoremap <silent> <C-w> :<C-u>call AutoClose()<CR>

" tag
autocmd Vimrc FileType help nnoremap <C-[> <C-t>

" tab
nnoremap <C-t> :<C-u>tabnew<CR>
inoremap <C-t> <ESC>:<C-u>tabnew<CR>

" select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" quit help with escape key
autocmd Vimrc FileType help,qf nnoremap <silent> <buffer> <expr> <ESC><ESC>
      \ &modifiable ? ":\<C-u>set nohlsearch\<CR>" : ":\<C-u>q\<CR>"

" disable EX-mode
map <S-q> <Nop>

" move within insert mode
imap <expr><C-o> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<ESC>o"
inoremap <expr> <C-p> <SID>cancel_popup("\<Up>")
inoremap <expr> <C-n> <SID>cancel_popup("\<Down>")
inoremap <expr> <C-b> <SID>cancel_popup("\<Left>")
inoremap <expr> <C-f> <SID>cancel_popup("\<Right>")
inoremap <expr> <C-e> <SID>cancel_popup("\<End>")
inoremap <expr> <C-a> <SID>cancel_popup("\<Home>")
inoremap <expr> <C-d> <SID>cancel_popup("\<Del>")
inoremap <expr> <C-h> <SID>cancel_popup("\<BS>")
inoremap <expr> <C-u> <SID>cancel_popup_reverse("\<C-u>")
inoremap <expr> <Up> <SID>cancel_popup("\<Up>")
inoremap <expr> <Down> <SID>cancel_popup("\<Down>")
inoremap <expr> <Left> <SID>cancel_popup("\<Left>")
inoremap <expr> <Right> <SID>cancel_popup("\<Right>")
nnoremap <expr> OA <SID>goback_insert("\<Up>")
nnoremap <expr> OB <SID>goback_insert("\<Down>")
nnoremap <expr> OC <SID>goback_insert("\<Right>")
nnoremap <expr> OD <SID>goback_insert("\<Left>")
nnoremap <expr> OF <SID>goback_insert("\<End>")
nnoremap <expr> OH <SID>goback_insert("\<Home>")
nnoremap <expr> [3~ <SID>goback_insert("\<Del>")
nnoremap <expr> [5~ <SID>goback_insert("\<PageUp>")
nnoremap <expr> [6~ <SID>goback_insert("\<PageDown>")
" }}}

" command line {{{
" navigation in command line
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Del>
cnoremap <C-h> <BS>
" }}}
" }}} KEY MAPPING

" vim:foldmethod=marker

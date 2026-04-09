" 基本設定 {{{1
let mapleader = ";"              " キーマップリーダー
nnoremap <Space>r :source ~/.vimrc<CR>
nnoremap <Space>e :e ~/.vimrc<CR>
set path=.,/usr/include/,/usr/local/include
set scrolloff=5                  " スクロール時の余白確保
set textwidth=0                  " 一行に長い文章を書いていても自動折り返しをしない
set nobackup                     " バックアップ取らない
set autoread                     " 他で書き換えられたら自動で読み直す
set noswapfile                   " スワップファイル作らない
set hidden                       " 編集中でも他のファイルを開けるようにする
set backspace=indent,eol,start   " バックスペースでなんでも消せるように
set formatoptions=lmoq           " テキスト整形オプション，マルチバイト系を追加
set vb t_vb=                     " ビープをならさない
set browsedir=buffer             " Exploreの初期ディレクトリ
set whichwrap=b,s,h,l,<,>,[,]    " カーソルを行頭、行末で止まらないようにする
set showcmd                      " コマンドをステータス行に表示
set showmode                     " 現在のモードを表示
set viminfo='50,<1000,s100,\"50  " viminfoファイルの設定
set modeline
set modelines=1                  " モードラインを１行読み込む
set timeoutlen=3500
set modifiable
" set clipboard+=unnamed
set splitbelow                   " newした時に下に開く
set splitright                   " vertical splitは右に開く
set isk+=-                       " -もwordとして扱う。
set signcolumn=yes               " diagnosticsやgit signでレイアウトを安定させる

" プラグイン読み込み {{{1
filetype plugin indent off
call plug#begin('~/.vim/plugged')
" must
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/xoria256.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'tpope/vim-commentary'
" Plug 'honza/vim-snippets'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'
Plug 'lambdalisue/fern.vim' " Filter
Plug 'tpope/vim-surround'
Plug 'houtsnip/vim-emacscommandline' " コマンドラインでemacsのキーバインド操作できるようにする
Plug 'yuroyoro/vimdoc_ja'
Plug 'mattn/vim-goimports'
Plug 'mattn/vim-goaddtags'
Plug 'rust-lang/rust.vim'
Plug 'vim-scripts/ciscoacl.vim'
Plug 'nathanalderson/yang.vim'
Plug 'rightson/vim-p4-syntax'
Plug 'glench/vim-jinja2-syntax'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'thinca/vim-quickrun'
Plug 'kana/vim-smartinput'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" if !has("gui_running")
  " Plug 'SirVer/ultisnips'
  " Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
  " Plug 'thomasfaingnaert/vim-lsp-ultisnips'
" endif

" testing
Plug 'vim-test/vim-test'
Plug 'tpope/vim-dispatch'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'
Plug 'easymotion/vim-easymotion'
" Plug 'iberianpig/tig-explorer.vim' " vimからGit操作する
" depends tig-explorer.vim when use nvim
" Plug 'rbgrouleff/bclose.vim'
Plug 'mbbill/undotree'
Plug 'github/copilot.vim'
call plug#end()
" ステータスライン {{{1
set laststatus=2
set ruler

" インデント {{{1
set autoindent   " 自動でインデント
set smartindent  " 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする。
set cindent      " Cプログラムファイルの自動インデントを始める

" softtabstopはTabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=2 shiftwidth=2 softtabstop=0

if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "そのファイルタイプにあわせたインデントを利用する
  filetype indent on

  autocmd FileType apache     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType aspvbs     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cs         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType diff       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType eruby      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType haml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType html       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType java       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et
  autocmd FileType perl       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType php        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType scala      setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType sql        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vb         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType wsh        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xhtml      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xml        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType zsh        setlocal sw=4 sts=4 ts=4 et
endif

" 表示 {{{1
set showmatch         " 括弧の対応をハイライト
set number            " 行番号表示
set list              " 不可視文字表示
set listchars=tab:>.,trail:_,extends:>,precedes:< " 不可視文字の表示形式
set display=uhex      " 印字不可能文字を16進数で表示

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

" カーソル行をハイライト
set cursorline
" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * setlocal nocursorline
  autocmd WinEnter,BufRead * setlocal cursorline
augroup END

hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

" コマンド実行中は再描画しない
set lazyredraw
" 高速ターミナル接続を行う
set ttyfast

" 補完・履歴 {{{1
set wildmenu               " コマンド補完を強化
set wildchar=<tab>         " コマンド補完を開始するキー
set wildmode=list:full     " リスト表示，最長マッチ
set history=1000           " コマンド・検索パターンの履歴数
set complete+=k            " 補完に辞書ファイル追加

" タグ関連 {{{1
set tags=tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags

set notagbsearch

" 検索設定 {{{1
set wrapscan   " 最後まで検索したら先頭へ戻る
set ignorecase " 大文字小文字無視
set smartcase  " 検索文字列に大文字が含まれている場合は区別して検索する
set incsearch  " インクリメンタルサーチ
set hlsearch   " 検索文字をハイライト
"Escの2回押しでハイライト消去
nmap <ESC><ESC> :nohlsearch<CR><ESC>
vnoremap g/ y/\V<C-R>"<CR>

" 移動設定 {{{1
inoremap jj <ESC>
nnoremap h <Left>
nnoremap l <Right>
inoremap <C-e> <END>
inoremap <C-a> <HOME>
inoremap <C-n> <Down>
inoremap <C-p> <Up>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-h> <BackSpace>
inoremap <C-d> <Del>

noremap <C-n> :bn<CR>
noremap <C-p> :bp<CR>
noremap <Space>n :e %:p:h/
noremap <Space>q :BD<CR>
noremap <Space>p :set invpaste<CR>:GitGutterBufferToggle<CR>

"フレームサイズを変更する
nnoremap <silent> <Space>j 5<C-w>+
nnoremap <silent> <Space>k 5<C-w>-
nnoremap <silent> <Space>h 10<C-w><
nnoremap <silent> <Space>l 10<C-w>>

nnoremap go :e %:p:h/<cfile><CR>

" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" 最後に編集された位置に移動
nnoremap gb '[
nnoremap gp ']

" 矩形選択で自由に移動する
set virtualedit+=block

"ビジュアルモード時vで行末まで選択
vnoremap v $h
vmap <Leader>y "+y
vnoremap <leader>64 y:echo system('base64 --decode', @")<CR>

" CTRL-hjklでウィンドウ移動
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" ターミナルタイプによるカラー設定
if exists('+termguicolors')
  set termguicolors
endif

if &term =~# 'xterm-256color\|screen-256color\|wezterm'
  " 256色
  set t_Co=256
  set t_Sf=[3%dm
  set t_Sb=[4%dm
elseif &term =~# 'xterm-debian\|xterm-xfree86'
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
elseif &term =~# 'xterm-color'
  set t_Co=8
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

"ポップアップメニューのカラーを設定
hi Pmenu guibg=#666666
hi PmenuSel guibg=#8cd0d3 guifg=#666666
hi PmenuSbar guibg=#333333

" ハイライト on
syntax enable
" 補完候補の色づけ for vim7
hi Pmenu ctermbg=255 ctermfg=0 guifg=#000000 guibg=#999999
" hi PmenuSel ctermbg=blue ctermfg=black
hi PmenuSel cterm=reverse ctermfg=33 ctermbg=222 gui=reverse guifg=#3399ff guibg=#f0e68c
" hi PmenuSbar ctermbg=0 ctermfg=9
hi PmenuSbar ctermbg=255 ctermfg=0 guifg=#000000 guibg=#FFFFFF

" Terminal設定 {{{1
tnoremap <Esc> <C-\><C-n>
if has('nvim')
  " Neovim 用
  autocmd WinEnter * if &buftype ==# 'terminal' | startinsert | endif
else
  " Vim 用
  autocmd WinEnter * if &buftype ==# 'terminal' | normal i | endif
endif
" 編集関連 {{{1
noremap <Space>w :w<Space>!<Space>sudo<Space>tee<Space>><Space>/dev/null<Space>%

" Visualモードでのpで選択範囲をレジスタの内容に置き換える
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Tabキーを空白に変換
set expandtab

" 保存時に行末の空白を除去する
fun! StripTrailingWhitespace()
    if &ft =~ 'modula2\|markdown\|text\|ciscoacl\|bindzone'
        return
    endif

    if &ft == ''
        return
    endif
    let l:view = winsaveview()
    silent! keeppatterns %s/\s\+$//e
    call winrestview(l:view)
endfun
augroup trim_trailing_whitespace
  autocmd!
  autocmd BufWritePre * call StripTrailingWhitespace()
augroup END

" foldは各FiltTypeにお任せる
set foldmethod=marker

" git mergetool用に変更
if &diff
  map <Leader>1 :diffget LOCAL<CR>
  map <Leader>2 :diffget BASE<CR>
  map <Leader>3 :diffget REMOTE<CR>
endif

" 連番を作成する
" https://sites.google.com/site/fudist/Home/vim-nihongo-ban/tips#TOC--7
nnoremap <silent> co :ContinuousNumber <C-a><CR>
vnoremap <silent> co :ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor

" エンコーディング関連 {{{1
set ffs=unix,dos,mac  " 改行文字
set encoding=utf-8    " デフォルトエンコーディング

" 文字コード認識はbanyan/recognize_charcode.vimへ

autocmd FileType svn setlocal fileencoding=utf-8
autocmd FileType js setlocal fileencoding=utf-8
autocmd FileType css setlocal fileencoding=utf-8
autocmd FileType html setlocal fileencoding=utf-8
autocmd FileType xml setlocal fileencoding=utf-8
autocmd FileType java setlocal fileencoding=utf-8
autocmd FileType scala setlocal fileencoding=utf-8

" ワイルドカードで表示するときに優先度を低くする拡張子
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" 指定文字コードで強制的にファイルを開く
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8
command! Jis Iso2022jp
command! Sjis Cp932

" 言語設定 {{{1
" ciscoacl
augroup filetype
  au! BufRead,BufNewFile *.crules set filetype=ciscoacl
  au! BufRead,BufNewFile *.acl    set filetype=ciscoacl
augroup END

" golang
set path+=$GOPATH/src/**
let g:gofmt_command = 'goimports'
au BufNewFile,BufRead *.go set sw=4 noexpandtab ts=4
au FileType go compiler go
" }}}1
" My Func {{{1
function! s:project_root_dir() abort
  let current_file_dir = expand('%:p:h')
  let git_dir = findfile('.git', expand('%:p:h') . ';')
  if git_dir ==# ''
    let git_dir = finddir('.git', expand('%:p:h') . ';')
  endif

  if git_dir ==# ''
    throw 'Not a git repository: ' . expand('%:p:h')
  endif

  let root_dir = fnamemodify(git_dir, ':h')

  if !isdirectory(root_dir)
    return current_file_dir
  endif
  return root_dir
endfunction

function! s:ChangeProjectRootFromFile()
  try
    let root_dir = s:project_root_dir()
  catch
    echoerr 'change-current-dir: ' . v:exception
    return
  endtry

  execute 'lcd ' . fnamemodify(root_dir, ':p')
endfunction

function! MySnippetcase(word) abort
  return MySnakecase(a:word)
endfunction

" Copied from tpope/vim-abolish
function! MySnakecase(word) abort
  let word = substitute(a:word, '::', '/', 'g')
  let word = substitute(word, '\(\u\+\)\(\u\l\)', '\1_\2', 'g')
  let word = substitute(word, '\(\l\|\d\)\(\u\)', '\1_\2', 'g')
  let word = substitute(word, '[.-]', '_', 'g')
  let word = tolower(word)
  return word
endfunction

" Copied from tpope/vim-abolish
function! MyCamelcase(word) abort
  let word = substitute(a:word, '-', '_', 'g')
  if word !~# '_' && word =~# '\l'
    return substitute(word, '^.', '\l&', '')
  else
    return substitute(word, '\C\(_\)\=\(.\)', '\=submatch(1)==""?tolower(submatch(2)) : toupper(submatch(2))','g')
  endif
endfunction

command! -nargs=0 ChangeProjectRootDirectory call s:ChangeProjectRootFromFile()

nmap <Leader>u :ChangeProjectRootDirectory<CR>
" }}}1
" プラグインごとの設定 {{{1

try
  colorscheme xoria256
catch
endtry

"------------------------------------
" fzf.vim
"------------------------------------
if exists('$TMUX')
  let g:fzf_layout = { 'tmux': '-p90%,60%' }
else
  let g:fzf_layout = { 'up': '~80%' }
endif

let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()
command! CurrentDirFiles execute 'Files' expand('%:p:h')

command! -nargs=0 ChangeProjectRoot call fzf#run({
\ 'source': 'ghq list --full-path',
\ 'sink': 'cd'
\ })


nmap <Leader>f :ProjectFiles<CR>
nmap <Leader>F :Files<CR>
nmap <Leader>; :Buffers<CR>
nmap <Leader>g :GFiles<CR>
nmap <Leader>G :Rg<CR>
nmap <Leader>h :History<CR>
nmap <Leader>C :History:<CR>
nmap <Leader>d :CurrentDirFiles<CR>
nmap <Leader>r :ChangeProjectRoot<CR>
"------------------------------------
" vim-lsp
"------------------------------------
let g:lsp_highlight_references_enabled = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
let g:asyncomplete_popup_delay = 200
set completeopt=menuone,noinsert,noselect

function! s:find_python_venv() abort
  let l:venv_dir = finddir('.venv', expand('%:p:h') . ';')
  if empty(l:venv_dir)
    return ''
  endif
  return fnamemodify(l:venv_dir, ':p')
endfunction

function! s:configure_pylsp_environment() abort
  if &filetype !=# 'python'
    return
  endif

  let l:plugins = g:lsp_settings['pylsp-all']['workspace_config']['pylsp']['plugins']
  let l:venv_dir = s:find_python_venv()

  if empty(l:venv_dir)
    if has_key(l:plugins, 'jedi')
      call remove(l:plugins, 'jedi')
    endif
    return
  endif

  let l:plugins['jedi'] = {
  \ 'environment': l:venv_dir,
  \ 'env_vars': {
  \   'VIRTUAL_ENV': l:venv_dir,
  \ },
  \}
endfunction

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  if exists('+tagfunc')
    setlocal tagfunc=lsp#tagfunc
  endif
  if exists('+formatexpr')
    setlocal formatexpr=lsp#ui#vim#formatexpr()
  endif

  nmap <silent><buffer> gd <plug>(lsp-definition)
  nmap <silent><buffer> gi <plug>(lsp-implementation)
  nmap <silent><buffer> gr <plug>(lsp-references)
  nmap <silent><buffer> gt <plug>(lsp-type-definition)
  nmap <silent><buffer> K <plug>(lsp-hover)
  nmap <silent><buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <silent><buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <silent><buffer> [e <plug>(lsp-previous-error)
  nmap <silent><buffer> ]e <plug>(lsp-next-error)
  nmap <silent><buffer> <Leader>rn <plug>(lsp-rename)
  nmap <silent><buffer> <Leader>ca <plug>(lsp-code-action)
  nmap <silent><buffer> <Leader>lf <plug>(lsp-document-format)
  nmap <silent><buffer> <Leader>ds <plug>(lsp-document-symbol)
  nmap <silent><buffer> <Leader>ws <plug>(lsp-workspace-symbol-search)
  xmap <silent><buffer> <Leader>lf <plug>(lsp-document-format)
endfunction

augroup vim_lsp
  autocmd!
  autocmd FileType python call s:configure_pylsp_environment()
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_settings_filetype_go = ['gopls']
let g:lsp_settings_filetype_python = ['pylsp-all']
let g:lsp_settings_filetype_javascript = ['typescript-language-server']
let g:lsp_settings_filetype_javascriptreact = ['typescript-language-server']
let g:lsp_settings_filetype_typescript = ['typescript-language-server']
let g:lsp_settings_filetype_typescriptreact = ['typescript-language-server']

let g:lsp_settings = {
\   'gopls': {
\     'workspace_config': {
\       'gopls': {
\         'gofumpt': v:true,
\         'staticcheck': v:true,
\       },
\     },
\   },
\   'pylsp-all': {
\     'workspace_config': {
\       'pylsp': {
\         'configurationSources': ['flake8'],
\         'plugins': {
\           'flake8': {
\             'enabled': 1,
\           },
\           'pycodestyle': {
\             'maxLineLength': 150,
\           },
\         },
\       }
\     }
\   },
\   'typescript-language-server': {
\     'workspace_config': {
\       'typescript': {
\         'inlayHints': {
\           'includeInlayParameterNameHints': 'all',
\           'includeInlayParameterNameHintsWhenArgumentMatchesName': v:false,
\           'includeInlayFunctionParameterTypeHints': v:true,
\           'includeInlayVariableTypeHints': v:true,
\           'includeInlayPropertyDeclarationTypeHints': v:true,
\           'includeInlayFunctionLikeReturnTypeHints': v:true,
\           'includeInlayEnumMemberValueHints': v:true,
\         },
\       },
\       'javascript': {
\         'inlayHints': {
\           'includeInlayParameterNameHints': 'all',
\           'includeInlayParameterNameHintsWhenArgumentMatchesName': v:false,
\           'includeInlayFunctionParameterTypeHints': v:true,
\           'includeInlayVariableTypeHints': v:true,
\           'includeInlayPropertyDeclarationTypeHints': v:true,
\           'includeInlayFunctionLikeReturnTypeHints': v:true,
\           'includeInlayEnumMemberValueHints': v:true,
\         },
\       },
\     },
\   },
\}

"------------------------------------
" vsnip
"------------------------------------
let g:vsnip_snippet_dir = $HOME.'/.vim/snippets/vsnip'
" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
" nmap        s   <Plug>(vsnip-select-text)
" xmap        s   <Plug>(vsnip-select-text)
" nmap        S   <Plug>(vsnip-cut-text)
" xmap        S   <Plug>(vsnip-cut-text)


"------------------------------------
" ultisnips
"------------------------------------
" let g:UltiSnipsExpandTrigger="<c-j>"
" let g:UltiSnipsJumpForwardTrigger="<c-l>"
" let g:UltiSnipsJumpBackwardTrigger="<c-h>"

" let g:UltiSnipsEditSplit="vertical"
" let g:UltiSnipsSnippetDirectories=['UltiSnips',$HOME.'/.vim/snippets']

" " let g:UltiSnipsExpandTrigger="<c-e>"
" call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
    " \ 'name': 'ultisnips',
    " \ 'allowlist': ['*'],
    " \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
    " \ }))


"------------------------------------
" vim-commentary
"------------------------------------
nmap <Leader>c <Plug>Commentary
xmap <Leader>c <Plug>Commentary
omap <Leader>c <Plug>Commentary

"------------------------------------
" surround.vim
"------------------------------------
let g:surround_{char2nr('e')} = "begin \r end"
let g:surround_{char2nr('d')} = "do \r end"
let g:surround_{char2nr("-")} = ":\r"

"------------------------------------
" vim-airline
"------------------------------------
if has('gui_running')
  let g:airline_theme="laederon"
else
  let g:airline_theme="powerlineish"
endif

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '|'

"------------------------------------
" Fern
"------------------------------------
let g:fern_disable_startup_warnings = 1
nmap <Leader>T :Fern . -drawer -toggle<CR>
nmap <Leader>e :Fern %:h -reveal=%<CR>

"------------------------------------
" vim-test
"------------------------------------
let g:test#strategy = 'dispatch'
let test#python#runner = 'pytest'
" let g:test#strategy = 'dispatch_background'
" let g:test#strategy = 'neovim'
nmap <Leader>t :TestSuite<CR>

"------------------------------------
" Rust
"------------------------------------
let g:rustfmt_autosave = 1

if exists('*smartinput#define_rule')
  call smartinput#define_rule({
    \ 'at': '[<&]\%#',
    \ 'char': '''',
    \ 'input': '''',
    \ })
endif

"------------------------------------
" quickrun
"------------------------------------
nmap <silent>qr :QuickRun<CR>
" au FileType quickrun setlocal nobuflisted nomodifiable readonly
au FileType quickrun nnoremap <buffer>q :quit<CR>
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
autocmd BufLeave quickrun://output setlocal nobuflisted

let g:quickrun_config = get(g:, 'quickrun_config', {})
"      \ 'runner'    : 'vimproc',
"      \ 'runner/vimproc/updatetime' : 60,
"      \ 'outputter/buffer/into'  : 1,
"      \ 'outputter' : 'error',
"      \ 'outputter/error/success' : 'buffer',
"      \ 'outputter/error/error'   : 'quickfix',
let g:quickrun_config._ = {
      \ 'outputter/buffer/opener'  : 'new',
      \ 'outputter/buffer/running_mark'  : 'running...',
      \ 'outputter/buffer/filetype'  : 'quickrun',
      \ 'outputter/buffer/close_on_empty' : 1,
      \ }

let g:quickrun_config['gotest'] = {
      \ 'command': 'go',
      \ 'exec': '%c test ./...',
      \ 'hook/output_encode/encoding': 'utf-8',
      \ 'hook/cd/directory': '%S:p:h',
      \ }

" }}}1
filetype plugin indent on
set maxmempattern=2000000
" vim:foldmethod=marker:foldcolumn=3:foldlevel=0

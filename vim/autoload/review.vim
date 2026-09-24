" LLMが書いたコード/設計書をレビューするためのワークフロー
" コマンドとキーマップは plugin/review.vim、使い方は同ファイル冒頭を参照。

" レビュー状態
"   ref     : 比較対象のgit ref。空なら「差分を取らずファイルを読むだけ」（設計書モード）
"   root    : gitリポジトリのルート（設計書モードでgit外なら空）
"   main    : 実ファイルを表示するウィンドウID
"   partner : <Leader>bで開いた変更前の比較用ウィンドウID
"   done    : レビュー済みにしたファイル（絶対パス → 1）
let s:state = {'active': 0, 'ref': '', 'root': '', 'main': 0, 'partner': 0, 'done': {},
      \ 'gutter_base': ''}

function! s:err(msg) abort
  echohl ErrorMsg | echomsg 'Review: ' . a:msg | echohl None
endfunction

function! s:git_root() abort
  let root = trim(system('git rev-parse --show-toplevel 2>/dev/null'))
  return v:shell_error ? '' : root
endfunction

function! s:git(args) abort
  return systemlist('git -C ' . shellescape(s:state.root) . ' ' . a:args)
endfunction

" ----------------------------------------------------------------------------
" 開始
" ----------------------------------------------------------------------------

" :Review [ref]  refとの差分（未追跡ファイル含む）をレビュー。省略時はHEAD
function! review#start(args) abort
  let root = s:git_root()
  if empty(root)
    return s:err('gitリポジトリではありません')
  endif
  let s:state.root = root
  let ref = empty(a:args) ? 'HEAD' : a:args

  " --name-status で A(新規)/D(削除)/R(リネーム) を区別する
  let lines = s:git('diff --name-status ' . ref . ' --')
  if v:shell_error
    return s:err('git diffに失敗しました: ' . ref)
  endif
  let items = []
  for l in lines
    let cols = split(l, '\t')
    let st = cols[0][0]
    let path = cols[-1]
    call add(items, {'filename': root . '/' . path, 'text': path,
          \ 'user_data': {'status': st, 'path': path}})
  endfor
  " git diff は未追跡ファイルを含まない。LLMは新規ファイルを作ることが多いので追加する
  for path in s:git('ls-files --others --exclude-standard')
    call add(items, {'filename': root . '/' . path, 'text': path,
          \ 'user_data': {'status': '?', 'path': path}})
  endfor
  if empty(items)
    echomsg 'Review: ' . ref . ' との差分はありません'
    return
  endif
  call s:begin(ref, items, 'Review: ' . ref)
endfunction

" :ReviewDoc [files...]  指定ファイル（省略時はargs）を差分なしで順に読む
function! review#start_doc(files) abort
  let files = empty(a:files) ? argv() : a:files
  if empty(files)
    return s:err('ファイルを指定してください')
  endif
  let s:state.root = s:git_root()
  let items = map(copy(files), {_, f -> {'filename': fnamemodify(f, ':p'),
        \ 'text': fnamemodify(f, ':.'), 'user_data': {'status': 'doc', 'path': fnamemodify(f, ':.')}}})
  call s:begin('', items, 'ReviewDoc')
endfunction

function! s:begin(ref, items, title) abort
  " レビュー中に再度開始した場合はレビュー前の値を保持したままにする
  if !s:state.active
    let s:state.gutter_base = get(g:, 'gitgutter_diff_base', '')
  endif
  let s:state.active = 1
  let s:state.ref = a:ref
  let s:state.done = {}
  let s:state.partner = 0
  " gitgutterのサインをref基準にする（既定はindex基準なので、stage済みの変更が見えない）
  let g:gitgutter_diff_base = a:ref
  " quickfixウィンドウ以外の通常ウィンドウをメインにする
  if &buftype ==# 'quickfix'
    wincmd p
  endif
  let s:state.main = win_getid()
  call setqflist([], ' ', {'title': a:title, 'items': a:items,
        \ 'quickfixtextfunc': 'review#qftext'})
  call s:refresh_qf()
  botright copen 8
  call review#jump('cfirst')
endfunction

" ----------------------------------------------------------------------------
" ファイル移動
" ----------------------------------------------------------------------------

function! s:goto_main() abort
  if s:state.main && win_gotoid(s:state.main)
    return 1
  endif
  " メインが閉じられていたら、quickfix以外の最初のウィンドウを採用する
  for w in range(1, winnr('$'))
    if getwinvar(w, '&buftype') ==# '' && win_getid(w) != s:state.partner
      let s:state.main = win_getid(w)
      return win_gotoid(s:state.main)
    endif
  endfor
  call s:err('レビュー用ウィンドウが見つかりません')
  return 0
endfunction

function! s:close_partner() abort
  if s:state.partner && win_id2win(s:state.partner) > 0
    execute win_id2win(s:state.partner) . 'close'
  endif
  let s:state.partner = 0
  " 片側が閉じてもメイン側のdiffは残ることがあるので明示的に切る
  if s:goto_main()
    diffoff
  endif
endfunction

" 現在のquickfixエントリを開き、状態に応じて差分を表示する
function! s:open_current() abort
  let qf = getqflist({'idx': 0, 'items': 0})
  let item = qf.items[qf.idx - 1]
  let st = get(get(item, 'user_data', {}), 'status', '')

  call s:close_partner()
  if st ==# 'D'
    " 削除されたファイルはref側の内容を読み取り専用で表示
    execute 'Gedit' s:state.ref . ':' . item.user_data.path
  endif
  if &filetype ==# 'markdown'
    call s:markdown_view()
  endif
  " LLMが裏で書き換えていても最新を見る
  silent! checktime
  silent! GitGutter
endfunction

" 変更前（ref側）を左に並べてdiff表示する。もう一度押すと閉じる
function! review#toggle_before() abort
  if !s:state.active || empty(s:state.ref)
    return s:err('差分レビュー中ではありません')
  endif
  if s:state.partner && win_id2win(s:state.partner) > 0
    call s:close_partner()
    return
  endif
  let qf = getqflist({'idx': 0, 'items': 0})
  let st = get(get(qf.items[qf.idx - 1], 'user_data', {}), 'status', '')
  if st =~# '^[AD?]$'
    return s:err('新規/削除ファイルには比較対象がありません')
  endif
  if !s:goto_main()
    return
  endif
  execute 'leftabove Gvdiffsplit' s:state.ref
  let s:state.partner = win_getid()
  call s:goto_main()
endfunction

" cnext/cprev/cc/cfirst を実行して開く。リスト端なら何もしない
function! review#jump(cmd) abort
  if !s:state.active
    try | execute a:cmd | catch /E55[03]/ | endtry
    return
  endif
  if !s:goto_main()
    return
  endif
  try
    execute a:cmd
  catch /E55[03]/
    echo 'Review: ' . (a:cmd =~# 'next' ? '最後のファイルです' : '最初のファイルです')
    return
  endtry
  call s:open_current()
endfunction

" quickfix上で<CR>
function! review#qf_enter() abort
  let idx = line('.')
  if !s:state.active
    execute 'cc' idx
    return
  endif
  call review#jump('cc ' . idx)
endfunction

" ----------------------------------------------------------------------------
" レビュー済みマーク
" ----------------------------------------------------------------------------

" quickfixの表示からファイル名/行番号を省き、状態つきのテキストだけ見せる
function! review#qftext(info) abort
  let items = getqflist({'id': a:info.id, 'items': 0}).items
  return map(items[a:info.start_idx - 1 : a:info.end_idx - 1], 'v:val.text')
endfunction

function! s:refresh_qf() abort
  let qf = getqflist({'idx': 0, 'items': 0, 'title': 0})
  let total = len(qf.items)
  let done = 0
  for item in qf.items
    let path = fnamemodify(bufname(item.bufnr), ':p')
    let mark = get(s:state.done, path, 0) ? '[x]' : '[ ]'
    if mark ==# '[x]' | let done += 1 | endif
    let ud = get(item, 'user_data', {})
    let st = get(ud, 'status', '')
    let item.text = st ==# 'doc' ? mark . ' ' . ud.path : printf('%s %s %s', mark, st, ud.path)
  endfor
  let title = substitute(qf.title, ' (\d\+/\d\+)$', '', '') . printf(' (%d/%d)', done, total)
  call setqflist([], 'r', {'items': qf.items, 'idx': qf.idx, 'title': title})
endfunction

" 現在のファイルをレビュー済みにトグルし、未レビューなら次へ進む
function! review#toggle_done() abort
  if !s:state.active
    return
  endif
  let qf = getqflist({'idx': 0, 'items': 0})
  let idx = &buftype ==# 'quickfix' ? line('.') : qf.idx
  let path = fnamemodify(bufname(qf.items[idx - 1].bufnr), ':p')
  let now = !get(s:state.done, path, 0)
  let s:state.done[path] = now
  call setqflist([], 'r', {'idx': idx})
  call s:refresh_qf()
  if now && idx < len(qf.items)
    call review#jump('cnext')
  endif
endfunction

" ----------------------------------------------------------------------------
" レビューコメント
" ----------------------------------------------------------------------------

" コメントは .git 配下に置く（コミットに混ざらない / worktreeごとに分かれる）
function! review#notes_path() abort
  let root = empty(s:state.root) ? s:git_root() : s:state.root
  if empty(root)
    return fnamemodify('.llm-review.md', ':p')
  endif
  let p = trim(system('git -C ' . shellescape(root) . ' rev-parse --git-path llm-review.md'))
  return fnamemodify(p =~# '^/' ? p : root . '/' . p, ':p')
endfunction

" fugitive:// バッファ（diffの左側）でも実ファイルのパスを返す
function! s:real_path() abort
  let p = exists('*FugitiveReal') ? FugitiveReal(expand('%:p')) : expand('%:p')
  let root = empty(s:state.root) ? s:git_root() : s:state.root
  return empty(root) ? fnamemodify(p, ':.') : substitute(p, '^' . escape(root, '\.') . '/', '', '')
endfunction

" 指定範囲のコードを引用してコメント欄を作り、そこで挿入モードに入る
function! review#comment(line1, line2) abort
  let path = s:real_path()
  let loc = a:line1 == a:line2 ? path . ':' . a:line1 : path . ':' . a:line1 . '-' . a:line2
  let side = expand('%') =~# '^fugitive://' ? ' (変更前)' : ''
  let code = getline(a:line1, a:line2)
  let lang = &filetype
  " 引用がmarkdownのフェンスを壊さないように、中身より長いフェンスを使う
  let fence = '```'
  while !empty(filter(copy(code), {_, l -> l =~# '^\s*' . fence}))
    let fence .= '`'
  endwhile
  let entry = ['', '## ' . loc . side, fence . lang] + code + [fence, '']

  call review#open_notes()
  call append('$', entry)
  normal! G
  write
  startinsert!
endfunction

function! review#open_notes() abort
  let path = review#notes_path()
  let winnr = bufwinnr('^' . path . '$')
  if winnr > 0
    execute winnr . 'wincmd w'
    return
  endif
  if !filereadable(path)
    call writefile(['# Review notes', '',
          \ '<!-- 各見出しの path:line について、下のコメントに従って修正してください -->'], path)
  endif
  execute 'botright 12split' fnameescape(path)
  setlocal bufhidden=hide wrap
  " 書いたそばから保存して、Claude側がいつ読んでも最新になるようにする
  augroup review_notes
    autocmd! * <buffer>
    autocmd InsertLeave,TextChanged <buffer> silent! update
  augroup END
endfunction

" コメント全体をクリップボードへ。Claudeに貼り付けるか、パスを伝えて読ませる
function! review#send() abort
  let path = review#notes_path()
  if !filereadable(path)
    return s:err('コメントがありません')
  endif
  let @+ = join(readfile(path), "\n")
  let @" = @+
  echomsg 'Review: コメントをコピーしました（' . path . '）'
endfunction

" コメントを空にする（LLMが対応し終わった後の次ラウンド用）
function! review#clear_notes() abort
  let path = review#notes_path()
  if filereadable(path) && confirm('レビューコメントを削除しますか?', "&Yes\n&No", 2) == 1
    call delete(path)
    let b = bufnr('^' . path . '$')
    if b > 0 | execute 'bwipeout!' b | endif
    echomsg 'Review: コメントを削除しました'
  endif
endfunction

" ----------------------------------------------------------------------------
" Markdown
" ----------------------------------------------------------------------------

" 記法を隠して読みやすくする（カーソル行だけは生の記法を表示）
function! s:markdown_view() abort
  setlocal wrap linebreak breakindent conceallevel=2 concealcursor=
endfunction

" glowで整形表示（表や見出しを確認したい時用）
function! review#preview() abort
  if !executable('glow')
    return s:err('glow がインストールされていません（brew install glow）')
  endif
  let file = expand('%') =~# '^fugitive://' && exists('*FugitiveReal')
        \ ? FugitiveReal(expand('%:p')) : expand('%:p')
  " pagerはvimのterminal内で描画されないので、出力を残したバッファをvimでスクロールする
  let buf = term_start(['glow', '-s', &background, '-w', string(winwidth(0) / 2 - 4), file],
        \ {'vertical': 1, 'term_name': 'glow: ' . fnamemodify(file, ':t')})
  call setbufvar(buf, '&bufhidden', 'wipe')
  " 描画し終わったらノーマルモードで操作でき、qで閉じる（qrマッピングを待たないようnowait）
  call term_wait(buf, 1000)
  setlocal nonumber norelativenumber nolist signcolumn=no
  nnoremap <buffer><silent><nowait> q :close<CR>
  normal! gg
endfunction

" ----------------------------------------------------------------------------
" 終了
" ----------------------------------------------------------------------------

function! review#end() abort
  if s:state.active
    call s:close_partner()
    let g:gitgutter_diff_base = s:state.gutter_base
    silent! GitGutterAll
  endif
  let s:state.active = 0
  let s:state.ref = ''
  cclose
endfunction

function! review#active() abort
  return s:state.active
endfunction

" LLMの実装/設計書レビュー（実装は autoload/review.vim）
"
" 起動:
"   :Review [ref]          refとの差分（未追跡ファイル含む）を順にレビュー。省略時はHEAD＝未コミット分
"   :ReviewDoc [files...]  ファイルを差分なしで順に読む（設計書向け）。省略時は起動時の引数
"   シェルからは `review [ref]` / `review docs/*.md`
"
" 移動:
"   ]q / [q      次/前のファイル（変更ありなら左に変更前をGdiffsplit）
"   <CR>         quickfix上で選んだファイルを開く
"   x            quickfix上でレビュー済みをトグル（済みにすると次へ進む）
"   <Leader>x    ファイル上で同上
"
" コメント（LLMへの指摘）:
"   <Leader>m    カーソル行/選択範囲を引用してコメントを書く（.git/llm-review.md に保存）
"   <Leader>M    コメントファイルを開く
"   :ReviewSend  コメントをクリップボードへ。Claudeに貼るか「.git/llm-review.md を読んで対応して」と伝える
"   :ReviewClear 対応済みのコメントを消して次のラウンドへ
"
" Markdown:
"   レビュー中の .md は折り返し＋記法を隠して表示。:ReviewPreview で glow による整形表示
"
" 終了:
"   <Leader>Q    レビュー終了

if exists('g:loaded_review')
  finish
endif
let g:loaded_review = 1

command! -nargs=* Review call review#start(<q-args>)
command! -nargs=* -complete=file ReviewDoc call review#start_doc([<f-args>])
command! -range ReviewComment call review#comment(<line1>, <line2>)
command! ReviewNotes call review#open_notes()
command! ReviewSend call review#send()
command! ReviewClear call review#clear_notes()
command! ReviewPreview call review#preview()
command! ReviewEnd call review#end()

nnoremap <silent> ]q :call review#jump('cnext')<CR>
nnoremap <silent> [q :call review#jump('cprev')<CR>
nnoremap <silent> <Leader>x :call review#toggle_done()<CR>
nnoremap <silent> <Leader>m :ReviewComment<CR>
xnoremap <silent> <Leader>m :ReviewComment<CR>
nnoremap <silent> <Leader>M :ReviewNotes<CR>
nnoremap <silent> <Leader>Q :ReviewEnd<CR>

augroup review_plugin
  autocmd!
  autocmd FileType qf nnoremap <buffer><silent> <CR> :call review#qf_enter()<CR>
  autocmd FileType qf nnoremap <buffer><silent> x :call review#toggle_done()<CR>
  " LLMが裏でファイルを書き換えたら追従する（autoreadはvimrcで有効）
  autocmd FocusGained,BufEnter,CursorHold * if getcmdwintype() ==# '' | silent! checktime | endif
augroup END

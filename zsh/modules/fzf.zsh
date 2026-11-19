#* -*- sh -*-
# FZF 設定。検索ウィジェット関数は autoload（実体は ~/.zsh/functions/）。
# ウィジェット登録・キーバインドは keybinds.zsh 側。

# 色は iTerm2 / WezTerm の配色（背景 #2b2b2b、アクセント #80ebdf）に合わせる
export FZF_DEFAULT_OPTS="--height=60% --layout=reverse --border=rounded --margin=0,1 --info=inline-right --prompt='❯ ' --pointer='▌' --marker='┃' --separator='─' --scrollbar='│' --color=fg:#d0d0d0,bg:-1,hl:#80ebdf,fg+:#ffffff,bg+:#3a3a3a,hl+:#80ebdf --color=border:#4a4a4a,label:#80ebdf,prompt:#80ebdf,pointer:#80ebdf,marker:#f0e68c,info:#7a7a7a,spinner:#80ebdf,header:#7a7a7a"
FZF=fzf
FZF_OPTS=
if [ $TMUX ]; then
    FZF=fzf-tmux
    FZF_OPTS="-p"
fi

# search snippet + history
# http://blog.glidenote.com/blog/2014/06/26/snippets-peco-percol/
# _cmdsearch_history_records が $history 連想配列を使うため zsh/parameter をロード。
zmodload -i zsh/parameter
autoload -Uz _cmdsearch_history_records _cmdsearch_snippet_records \
    filter-cmdsearch-history filter-src filter-worktree vim-file-search filter-multi-ssh

# fzf-tab: Tab 補完の候補を fzf で選ぶ。compinit（completion.zsh）の後、zsh-syntax-highlighting などの
# ウィジェットを包むプラグイン（zinit の wait で後から読む）より前に読む必要がある。
# fzf の有無を見るので、PATH を整える zsh_`uname` より後（このファイル）で読む。
# fzf がない環境（Linux サーバーなど）では読まず、これまでの menu select のまま。
if (( $+commands[fzf] )); then
    zinit light Aloxaf/fzf-tab
    # 候補の一覧は fzf-tab が出すので zsh 標準のメニューは使わない
    zstyle ':completion:*' menu no
    # fzf-tab はグループ名を [%d] の形で受け取る（色付きの見出しだと崩れる）
    zstyle ':completion:*:descriptions' format '[%d]'
    # 見た目は FZF_DEFAULT_OPTS（ghq などと同じ枠と色）に合わせる
    zstyle ':fzf-tab:*' use-fzf-default-opts yes
    # < と > でグループ（ファイル / ディレクトリ / オプションなど）を切り替える
    zstyle ':fzf-tab:*' switch-group '<' '>'
    # 色: 標準はグループごとに原色の虹色なので、iTerm2 / fzf の配色に合わせて落ち着かせる。
    # グループ（コマンド / オプション / ファイルなど）ごとに、この順で色が付く
    zstyle ':fzf-tab:*' default-color $'\e[38;2;208;208;208m'
    zstyle ':fzf-tab:*' group-colors \
        $'\e[38;2;128;235;223m' $'\e[38;2;240;230;140m' $'\e[38;2;168;208;141m' \
        $'\e[38;2;215;186;125m' $'\e[38;2;180;160;230m' $'\e[38;2;127;191;255m' \
        $'\e[38;2;208;113;111m' $'\e[38;2;160;160;160m'
    # ディレクトリを補完するときは中身をプレビューする
    zstyle ':fzf-tab:complete:(cd|pushd|eza|ls):*' fzf-preview \
        'if [ -d $realpath ]; then eza -1 --icons --group-directories-first --color=always $realpath; else bat --color=always --style=numbers --line-range=:100 $realpath 2>/dev/null; fi'
    zstyle ':fzf-tab:complete:(v|vi|vim|cat|bat|less):*' fzf-preview \
        'if [ -d $realpath ]; then eza -1 --icons --group-directories-first --color=always $realpath; else bat --color=always --style=numbers --line-range=:100 $realpath 2>/dev/null; fi'
    # git checkout / switch はブランチの最近のコミットを出す
    zstyle ':fzf-tab:complete:git-(checkout|switch):*' fzf-preview \
        'git log --oneline --color=always -15 $word 2>/dev/null'
fi

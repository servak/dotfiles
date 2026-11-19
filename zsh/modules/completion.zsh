#* -*- sh -*-
# 補完まわり（complist / compinit / 色 / zstyle）
zmodload zsh/complist  # menuselect キーマップに必要

# 手で入れたコマンド補完の置き場。`cmd completion zsh > ~/.zsh/completions/_cmd`
# のように _<コマンド名> で保存する。compinit より前に fpath へ追加すること。
fpath=(~/.zsh/completions $fpath)

autoload -Uz compinit && compinit

source ~/.zsh/ls_colors.zsh
# 色設定
autoload -Uz colors && colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' verbose yes
zstyle ':completion:*:default' menu select=2

zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
# グループ名に空文字列を指定すると，マッチ対象のタグ名がグループ名に使われる。
# したがって，すべての マッチ種別を別々に表示させたいなら以下のようにする
zstyle ':completion:*' group-name ''

# fzf-tab: Tab 補完の候補を fzf で選ぶ。compinit の後、zsh-syntax-highlighting などの
# ウィジェットを包むプラグイン（zinit の wait で後から読む）より前に読む必要がある。
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
    # ディレクトリを補完するときは中身をプレビューする
    zstyle ':fzf-tab:complete:(cd|pushd|eza|ls):*' fzf-preview \
        'if [ -d $realpath ]; then eza -1 --icons --group-directories-first --color=always $realpath; else bat --color=always --style=numbers --line-range=:100 $realpath 2>/dev/null; fi'
    zstyle ':fzf-tab:complete:(v|vi|vim|cat|bat|less):*' fzf-preview \
        'if [ -d $realpath ]; then eza -1 --icons --group-directories-first --color=always $realpath; else bat --color=always --style=numbers --line-range=:100 $realpath 2>/dev/null; fi'
    # git checkout / switch はブランチの最近のコミットを出す
    zstyle ':fzf-tab:complete:git-(checkout|switch):*' fzf-preview \
        'git log --oneline --color=always -15 $word 2>/dev/null'
fi

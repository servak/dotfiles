#* -*- sh -*-
# zsh-abbr: fish の abbr 相当。スペース/Enter で展開される。
# https://github.com/olets/zsh-abbr
#
# ここでは session スコープ (-S) で定義する。
# session abbreviation は ~/.config/zsh-abbr/user-abbreviations に
# 永続化されず、この設定ファイルが唯一の管理元になる（dotfiles 向き）。
# 対話的に `abbr add ...` した分は user スコープに保存され別管理になる。

# compinit 後に同期ロードする（abbr コマンドを即使えるようにするため）。
# zsh-abbr は zsh-job-queue サブモジュールに依存し、これが無いと
# キーバインド（スペース展開）が設定されない。zinit は clone 時に
# サブモジュールを取得しないため atclone で明示的に取得する。
zinit ice atclone'git submodule update --init --recursive' atpull'%atclone'
zinit load "olets/zsh-abbr"

# --- command position（コマンド先頭でのみ展開）-------------------------
abbr -S -q g='git'
abbr -S -q gs='git status'
abbr -S -q gd='git diff'
abbr -S -q gdc='git diff --cached'
abbr -S -q gb='git branch'
abbr -S -q gba='git branch -a'
abbr -S -q gbr='git branch -r'
abbr -S -q gg='git graph'
abbr -S -q gga='git graphall'
abbr -S -q grv='git remote -v'
abbr -S -q gf='git fetch -p'
abbr -S -q gp='git pull --ff-only'
abbr -S -q k='kubectl'

# --- anywhere（行のどこでも展開。グローバルエイリアス相当）-----------
abbr -S -q -g T='| tail'
abbr -S -q -g H='| head'
abbr -S -q -g L='| less'
abbr -S -q -g G='| grep'
abbr -S -q -g W='| wc -l'
abbr -S -q -g V='| vim -R -'
abbr -S -q -g C='| pbcopy'

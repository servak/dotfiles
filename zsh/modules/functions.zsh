#* -*- sh -*-
# 汎用関数（autoload）。実体は ~/.zsh/functions/<関数名> に 1 関数 1 ファイルで置く。
# ウィジェット登録・キーバインドは keybinds.zsh 側。
fpath=(~/.zsh/functions $fpath)
autoload -Uz mkcd description do_enter cdup color256 multi-ssh-cmd

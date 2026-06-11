#* -*- sh -*-
# モジュール化された zsh 設定。zshrc はローダーに徹し、実体は ~/.zsh/modules/* に置く。
# 読み込み順序には依存関係があるため、順番を入れ替える際は注意すること。

source ~/.zsh/modules/options.zsh      # setopt / WORDCHARS / umask
source ~/.zsh/modules/zinit.zsh        # プラグインマネージャ + プラグイン
source ~/.zsh/modules/env.zsh          # EDITOR 等の環境変数
source ~/.zsh/modules/history.zsh      # 履歴設定
source ~/.zsh/modules/completion.zsh   # complist / compinit / 色 / zstyle

source ~/.zsh/modules/aliases.zsh      # alias

# プラットフォーム固有設定（PATH/brew/mise や ll/sed 等の alias）。
# これらの alias は関数定義時に展開されうるため、functions/fzf より前に読む。
[ -f ~/.zsh/zsh_`uname` ] && source ~/.zsh/zsh_`uname`

source ~/.zsh/modules/functions.zsh    # 汎用関数
source ~/.zsh/modules/fzf.zsh          # FZF 設定 + 検索ウィジェット関数

# --- 順序厳守: キーマップ確定 → zsh-abbr → キーバインド ---
# bindkey -e でキーマップを確定してから zsh-abbr を読む（先に読むと bindkey -e が
# スペース展開バインドを reset する）。ウィジェットのキーバインドは abbr の後に
# 適用し、^space などを abbr の magic-space より優先させる。
bindkey -e
source ~/.zsh/modules/abbreviations.zsh
source ~/.zsh/modules/keybinds.zsh

[ -f ~/.zsh_local ] && source ~/.zsh_local

source ~/.zsh/modules/prompt.zsh       # PATH(~/.zsh/bin) 仕上げ + starship

# WezTerm 公式シェル統合（OSC 133 セマンティックゾーン / OSC 7 cwd / user var）。
# starship が組む PS1 を precmd で OSC 133 マーカーで包むため、必ず prompt.zsh の後に読む。
[ -n "$WEZTERM_PANE" ] && [ -f ~/.zsh/wezterm.sh ] && source ~/.zsh/wezterm.sh

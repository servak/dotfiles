## Self update
# zinit self-update

## Plugin update
# zinit update

## Plugin parallel update
# zinit update --parallel

## Increase the number of jobs in a concurrent-set to 40
# zinit update --parallel 40

# Zinitのホームディレクトリを指定
export ZINIT_HOME="$HOME/.zsh/zinit"

### Added by Zinit's installer
if [[ ! -f $ZINIT_HOME/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$ZINIT_HOME" && command chmod g-rwX "$ZINIT_HOME"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$ZINIT_HOME/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# プラグインディレクトリも変更（ディレクトリを事前作成）
mkdir -p "$ZINIT_HOME"/{plugins,completions,snippets}
ZINIT[PLUGINS_DIR]="$ZINIT_HOME/plugins"
ZINIT[COMPLETIONS_DIR]="$ZINIT_HOME/completions" 
ZINIT[SNIPPETS_DIR]="$ZINIT_HOME/snippets"

# Zinit plugins
zinit ice multisrc"shell/{completion,key-bindings}.zsh" id-as"junegunn/fzf_completions" pick"/dev/null"
zinit load "junegunn/fzf"

# パフォーマンス向上のためのターボモード
zinit ice wait lucid
zinit load "zsh-users/zsh-completions"

# 履歴検索の改善
zinit ice wait lucid
zinit load "zsh-users/zsh-history-substring-search"

# パス補完の改善
zinit ice wait lucid
zinit load "zsh-users/zsh-completions"

# 現在の設定を改善
zinit ice wait lucid
zinit load "zsh-users/zsh-syntax-highlighting"

zinit ice wait lucid
zinit load "zsh-users/zsh-autosuggestions"

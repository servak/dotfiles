#* -*- sh -*-
# PATH 仕上げ + プロンプト初期化

# プラットフォーム固有のPATH設定
PATH=~/.zsh/bin:$PATH

# Starship prompt initialization (PATH設定後)
if command -v starship > /dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

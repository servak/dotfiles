DOTFILES
========
vim, zsh, fish, tmux, Ghostty, WezTermの設定ファイルをまとめた。

## Installation

vim, zsh, fish, tmuxすべての設定ファイルを入れる。
```sh
make all
```

vimが自動で開かれ、PlugInstallが実行されます。

vimpluginのインストールが終了後、vimを閉じると、他の設定も入ります。

### Mac

#### 1. Homebrew packages（Global ツール）
```sh
brew bundle install
```

#### 2. mise（プロジェクト別バージョン管理）
```sh
mise install
```

#### 3. Ghostty / WezTerm

`make config` に `Ghostty` と `WezTerm` の設定が含まれます。
Laptop では GUI ターミナルとして `Ghostty` または `WezTerm` を使い、Linux の踏み台 VM では引き続き `tmux` を使う想定です。

`WezTerm` は `Ctrl-t` を leader にして、既存の `Ghostty` / `tmux` に近い操作へ寄せています。
特に `Ctrl-t [` で copy-mode に入り、`hjkl` 移動、`v` / `V` / `r` で選択、`y` でクリップボードへコピーできます。

### Fish migration

`zsh` の設定はそのまま残したまま、`fish` の設定も追加できます。
`fish` は macOS のローカル環境で使う前提で、Linux サーバーでは `zsh` を継続利用します。

```sh
make fish
```

デフォルトシェルを切り替える場合だけ、手動で以下を実行してください。

```sh
chsh -s $(which fish)
```

#### ツール管理方針

**Brewfile（Global ツール）**: 全プロジェクトで共通使用するツール
- 基本CLI: `git`, `jq`, `fzf`, `ripgrep`, `tmux` 等
- 開発支援: `docker-compose`, `lima`, `podman` 等  
- 言語固有標準ツール: `uv` (Python), `mise`
- Shell支援: `fish`, `zoxide`

**mise（プロジェクト別バージョン管理）**: プロジェクトごとにバージョンが重要なツール
- 言語ランタイム: `go`, `node`
- 開発ツール: `golangci-lint` 等

**言語標準バージョン管理**: 言語固有の優秀なツールを優先
- Python: `uv`
- Rust: `rustup`
- Go: 公式バージョン管理

#### Manual installation (deprecated)
```sh
brew install peco jq ghq fzf jsonnet ripgrep
```

DOTFILES
========
vim, zsh, tmuxの設定ファイルをまとめた。

## Installation

vim, zsh, tmuxすべての設定ファイルを入れる。
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

#### ツール管理方針

**Brewfile（Global ツール）**: 全プロジェクトで共通使用するツール
- 基本CLI: `git`, `jq`, `fzf`, `ripgrep`, `tmux` 等
- 開発支援: `docker-compose`, `lima`, `podman` 等  
- 言語固有標準ツール: `uv` (Python), `mise`

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

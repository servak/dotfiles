DOTFILES
========
vim, zsh, fish, tmux, iTerm2, WezTermの設定ファイルをまとめた。

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

#### 3. iTerm2 / WezTerm

`make config` に `iTerm2` と `WezTerm` の設定が含まれます。
Laptop では GUI ターミナルとして `iTerm2`（予備に `WezTerm`）を使い、Linux の踏み台 VM では引き続き `tmux` を使う想定です。

`WezTerm` は `Ctrl-t` を leader にして、`tmux` に近い操作へ寄せています。
特に `Ctrl-t [` で copy-mode に入り、`hjkl` 移動、`v` / `V` / `r` で選択、`y` でクリップボードへコピーできます。

#### iTerm2

`config/iterm2/com.googlecode.iterm2.plist` に、プロファイル（配色・フォント）やキーバインドなど設定本体を置いています。
ウィンドウ位置やアップデータの内部状態、`NoSync` が付く同期対象外のキーは除外済みです。

```sh
make iterm2
```

を実行すると、iTerm2 の「Preferences > General > Preferences」に相当する

- `PrefsCustomFolder` を `config/iterm2` に
- `LoadPrefsFromCustomFolder` を `true` に

セットします。反映には iTerm2 の再起動、または Preferences 画面の `Save Preferences Now` が必要です。
設定変更をそのまま `config/iterm2/com.googlecode.iterm2.plist` に書き戻したい場合は、Preferences 画面で `Save changes automatically` も有効にしてください（有効にすると `git diff` でそのまま設定変更履歴を追えます）。

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
- Shell支援: `fish`

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

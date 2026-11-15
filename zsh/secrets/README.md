# secrets

1Password の参照を YAML でまとめ、アプリや用途ごとのプロファイルとして環境変数に読み込む。macOS 専用。

- 本体: `zsh/bin/secrets`（Python。`uv run --script` で ruamel.yaml を自動で用意する）
- シェル関数: `zsh/functions/secrets`, `config/fish/functions/secrets.fish`（`load` / `unload` だけ担当）
- 設定: `~/.config/secrets/secrets.yaml`（リポジトリの外。ディレクトリ 700 / ファイル 600 で作る）。`$XDG_CONFIG_HOME` または `SECRETS_FILE` で変更可
- 必要なもの: `uv`, 1Password CLI `op`

## 設定の形

スキーマ全体は [examples/secrets.yaml.example](examples/secrets.yaml.example) を参照。

| 項目 | 内容 |
|---|---|
| `default_profile` | profile を省略したときに使うプロファイル（省略時は `default`） |
| `secrets.<name>` | 秘密の一覧。`ref` / `template` / `value` のどれか 1 つと `description` |
| `profiles.<name>.include` | 他プロファイルの変数を取り込む（後に書いたものが勝つ） |
| `profiles.<name>.env.<KEY>` | 一覧の名前、`op://...`、または `{ref / template / value}` をその場で定義 |

取り出し元は `ref`（普通はこれ。`op://...` の文字列は省略形）、`template`（文字列の中に `{{ op://... }}` を埋め込む）、`value`（秘密ではない固定値）の 3 つ。

## 使い方

```sh
secrets list                       # プロファイル一覧（* は読み込み済み）
secrets show app1                  # 変数名・参照先・説明（値は出さない）
secrets show --keys app1           # App1 に必要な変数名だけ
secrets load app1                  # 今のシェルに export（zsh / fish）
secrets unload                     # 読み込んだものを全部 unset

secrets secret add notion op://Private/Notion/password -d "Notion integration"
secrets secret list                # 秘密の一覧と、使っている profile.KEY
secrets secret where notion
secrets secret rm notion           # 使われていると拒否（--force）

secrets profile add app1 -d "App1 用" -i default
secrets env add app1 NOTION_TOKEN notion          # 一覧の名前で参照
secrets env add app1 SENTRY_DSN op://Work/Sentry/dsn
secrets env add app1 AWS_REGION ap-northeast-1 --literal   # 平文は --literal が必須
secrets env rm app1 AWS_REGION
secrets profile rm app1

secrets check                      # 検証（op は呼ばない）。使われていない秘密も知らせる
secrets migrate                    # 旧 ~/.zsh/secrets/*.env を YAML に変換（--from DIR で場所を指定）
```

## 他のシェル・言語から使う

`export` は解決した値を標準出力に書く。形式は `sh` `bash` `zsh` `fish` `json` `dotenv`。

```sh
eval "$(secrets export app1 -f bash)"           # bash
secrets export app1 -f fish | source            # fish
secrets export app1 -f dotenv > .env            # dotenv を読むツール向け（扱いに注意）
secrets export app1 -f json | jq .              # JSON を読む言語向け
secrets run app1 -- python app.py               # 子プロセスにだけ渡す（シェルに残らない）
```

複数プロファイルは並べた順に重ねる（`secrets load default app1`）。
シェル形式では読み込み済みプロファイルを `SECRETS_LOADED` に記録し、`list` の `*` と `unload` の既定対象に使う。
`unload` はプロファイルの変数をすべて消すので、include や重ね読みで共有している変数も消える。

# Python API

iTerm2自体をプログラムから操作する公式Python API。ウィンドウ/タブ/セッションの自動操作、Status Barの自作コンポーネント（[status-bar.md](status-bar.md)）、Triggerからの `Invoke Script Function`（[triggers.md](triggers.md)）呼び出し先など、他の機能の「裏側」として使われることが多い。

## 有効化

**Settings > General > Magic** の `Enable Python API` をONにする。これをオンにしないと、以降のスクリプトも `Invoke Script Function` も自作Status Barコンポーネントも一切動かない。トラブル時はまずここを疑う。

## スクリプトの置き場所と実行タイミング

```
~/Library/Application Support/iTerm2/Scripts/
├── AutoLaunch/      ← iTerm2起動時に自動実行される（常駐デーモンやStatus Bar/Triggerのハンドラ登録に使う）
└── （直下）          ← Scriptsメニューから手動実行する単発スクリプト
```

- 単発スクリプトは「1回実行して終わる」用途（例: 今開いているすべてのタブのタイトルを整える）。
- 常駐が必要な処理（Status Barの定期更新、Triggerからの関数呼び出しを待ち受ける、特定イベントを監視して通知するなど）は `AutoLaunch/` に置き、`iterm2.run_forever(main)` でイベントループを回し続ける。

## 実行環境（iterm2env）

iTerm2はスクリプトごとに専用の仮想環境（`iterm2env`）を自動生成する。`pip install` で依存を追加したい場合は、Scriptsメニューの「Manage Dependencies」またはスクリプト作成ウィザードから追加する（システムのPython環境を汚さない）。

## 基本パターン

```python
#!/usr/bin/env python3.11
import iterm2

async def main(connection):
    app = await iterm2.async_get_app(connection)
    window = app.current_terminal_window
    if window is not None:
        await window.async_create_tab()

# 単発実行の場合
iterm2.run_until_complete(main)

# 常駐（デーモン）の場合
# iterm2.run_forever(main)
```

## よく使うオブジェクト

| クラス | 役割 |
|---|---|
| `iterm2.App` | アプリ全体。`async_get_app` で取得、`current_terminal_window` などから辿る |
| `iterm2.Window` / `iterm2.Tab` / `iterm2.Session` | ウィンドウ/タブ/セッションの操作。`async_send_text`, `async_split_pane`, `async_activate` など |
| `iterm2.StatusBarComponent` | Status Barの自作コンポーネント（[status-bar.md](status-bar.md)参照） |
| `iterm2.Profile` | プロファイルの読み書き（実行時に動的に色やコマンドを変更する等） |
| `VariableMonitor` | セッション変数（`user.*` など）の変化を監視するコールバック登録 |

## Triggerから呼び出すRPC関数

Trigger の `Invoke Script Function` アクションから呼べる関数は、事前にRPCとして登録しておく必要がある:

```python
import iterm2

async def main(connection):
    @iterm2.RPC
    async def notify_on_error(session_id):
        session = await iterm2.async_get_app(connection)  # 必要に応じてsessionを辿る
        # 通知処理など

    await iterm2.Reference.async_register_rpc(connection, notify_on_error)

iterm2.run_forever(main)
```

登録した関数名を Trigger 側の `Invoke Script Function` に指定すると、正規表現マッチ時にこの関数が呼ばれる。単純な通知・ハイライトだけならTrigger単体の組み込みアクション（[triggers.md](triggers.md)）で足りるが、外部APIを叩く・複数セッションをまたいだ処理をするなど複雑なロジックが必要なときにPython APIを使う。

## デバッグ

- Scriptsメニューの `Console` （iTerm2 Python Console）でエラーログを確認できる。
- `Enable Python API` の直下に `Show Python API log` 的なログ出力先がある（バージョンにより文言が異なるので実機のMagic設定を確認する）。
- 一次情報が必要なとき（クラスの正確なメソッド名、非同期APIのシグネチャなど）は、公式リファレンス（https://iterm2.com/python-api/）をWebFetch/WebSearchで確認してから実装する。バージョンによってAPIが増減するため、うろ覚えで書くとメソッド名を間違えやすい。

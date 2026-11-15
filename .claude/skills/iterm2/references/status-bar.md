# Status Bar

セッションウィンドウ下部（または上部）に情報バーを出す機能。設定場所は **Settings > Profiles > Session > Status bar enabled** をONにしてから **Configure Status Bar** で編集する。

## 設定の流れ

1. Profile > Session > `Status bar enabled` をON
2. `Configure Status Bar` を開く
3. 画面下部のコンポーネント一覧から使いたいものを上部の配置エリアへドラッグ
4. 各コンポーネントをクリックすると `Configure Component` で背景色・文字色・優先度（幅が足りないときにどれを削るか）・最小幅などを個別設定できる
5. スペーサー（固定幅/可変幅の空白）を挟んでレイアウトを整える

## 組み込みコンポーネントの分類

- **システムリソース**: バッテリー残量、CPU使用率、メモリ使用率、ネットワークスループット
- **シェル情報**: カレントディレクトリ、ホスト名、ユーザー名、実行中ジョブ名、gitの状態（shell integrationが必要）
- **UI要素**: Composer（コマンドを送る前に編集できる入力欄）、検索、フィルタ、アクション、スニペット、トリガーボタン
- **その他**: 時計、区切り線、カスタムアクションボタン
- **補間文字列 (Interpolated String)**: `\(session.name)` のような変数展開文字列を自由に表示できる汎用コンポーネント。専用コンポーネントがない情報を出したいときはまずこれを検討する
- **スクリプト関数呼び出し**: Python APIに登録した関数の戻り値を表示するコンポーネント

## 自作コンポーネント（Python）

組み込みで足りない情報（外部API、独自メトリクスなど）を出したい場合はPython APIでカスタムコンポーネントを書く。`StatusBarComponent` を使い、定期的に値を更新するコルーチンを登録する。詳しい書き方・スクリプトの置き場所・起動方法は [python-api.md](python-api.md) を参照。自作コンポーネントは「Custom components show up at the end of the list」の通り、コンポーネント一覧の末尾に表示される。

イメージ:

```python
import iterm2

async def main(connection):
    component = iterm2.StatusBarComponent(
        short_description="現在の外気温",
        detailed_description="OpenWeatherMap APIから現在地の気温を取得",
        knobs=[],
        exemplar="22°C",
        update_cadence=300,  # 秒。ポーリング間隔
        identifier="com.example.iterm2.weather"
    )

    @iterm2.StatusBarRPC
    async def weather_status(knobs):
        # 実際には外部APIを叩いて気温を取得する
        return "22°C"

    await component.async_register(connection, weather_status)

iterm2.run_forever(main)
```

このスクリプトを `~/Library/Application Support/iTerm2/Scripts/AutoLaunch/` に置くと起動時に自動実行され、Status Barのコンポーネント一覧に「現在の外気温」が追加される。

## 実用例

- **git状態を出す**: 「シェル情報 > git状態」コンポーネントを追加するだけでよい。追加のPythonスクリプトは不要（shell integrationが有効な場合）
- **本番/検証環境を色で見分ける**: 補間文字列コンポーネントに `\(user.env)` のようなユーザー定義変数を表示し、Dynamic Profilesでプロファイルごとにその変数値と背景色を変える（[dynamic-profiles.md](dynamic-profiles.md) と組み合わせる）

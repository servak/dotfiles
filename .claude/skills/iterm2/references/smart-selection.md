# Smart Selection

ダブルクリックしたときの「賢い選択範囲」を正規表現で拡張する機能。設定場所は **Settings > Profiles > Advanced > Smart Selection**。Cmd+クリック（または右クリック）で、選択にひもづくアクションを実行できる。

## ルールの構成

各ルールは以下の2要素:

- **正規表現**: ダブルクリックした位置を含む範囲にマッチさせるパターン
- **Precision（重み）**: `Very Low` 〜 `Very High` の5段階。複数ルールがマッチする場合、Precisionが高いルールが優先される

組み込みルールの例: 「単語」は Low precision（ほぼ常にマッチする汎用ルール）、「HTTP URL」は Very High precision（誤検出がほぼない厳密なルール）。自作ルールを既存の「単語」より優先させたいときは、Precisionを上げる。

## アクション

マッチした範囲に対して、Cmd+クリック（既定）で以下のいずれかを実行できる:

| アクション | 内容 |
|---|---|
| Open File | 既定のアプリでファイルとして開く |
| Open URL | ブラウザで開く |
| Run Command | `/bin/sh -c` でコマンド実行 |
| Send Text | セッションにテキストを送る |
| Copy | クリップボードにコピー |

パラメータには [triggers.md](triggers.md) と同じ `\0`（全体マッチ）、`\1`〜`\9`（キャプチャグループ）が使える。

## 実用例

**JIRA/チケット番号（例: `PROJ-1234`）をクリックでブラウザ開き**
- 正規表現: `[A-Z][A-Z0-9]+-\d+`
- Precision: High
- アクション: Open URL
- URL: `https://your-jira.example.com/browse/\0`

**Kubernetes Pod名（例: `myapp-7f9c9d5c8b-abcde`）を選択してkubectl logsを実行**
- 正規表現: `[a-z0-9-]+-[a-f0-9]{9,10}-[a-z0-9]{5}`
- Precision: Very High（誤検出しやすいパターンなので厳しめに）
- アクション: Run Command
- コマンド: `kubectl logs \0 | less`

**gitのコミットハッシュ（7〜40桁の16進）を選択してブラウザで開く**
- 正規表現: `\b[0-9a-f]{7,40}\b`
- Precision: Medium
- アクション: Open URL
- URL: `https://github.com/yourorg/yourrepo/commit/\0`

## 注意点

- 汎用的すぎる正規表現（例: 数字だけ、英数字だけ）はPrecisionを上げても他の選択を邪魔しやすい。できるだけ固有のフォーマット（プレフィックス、桁数、区切り文字）を条件に含める。
- `Run Command` / `Send Text` アクションは、選択したテキストがそのままシェルに渡る。ログの中の任意文字列を誤って選択・実行してしまわないよう、正規表現を厳密にする（[triggers.md](triggers.md) のセキュリティ注意と同じ理由）。

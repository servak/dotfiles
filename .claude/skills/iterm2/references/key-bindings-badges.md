# Key Bindings & Badges

## Key Bindings

設定場所は **Settings > Keys > Key Bindings**（アプリ全体のグローバル設定）と **Settings > Profiles > Keys**（プロファイル単位。グローバルより優先）。

### 主なアクション

| アクション | 用途 |
|---|---|
| Send Text | 固定文字列を送る。`\n` `\e` `\a` `\t` などのエスケープが使える |
| Send Hex Code | `0x1B 0x5B 0x41` のように `0x` + 1〜2桁の16進を空白区切りで並べて任意バイト列を送る。ASCIIコード表の「Hx」列を参照 |
| Load Preset | プリセット化したキーバインドセットを一括適用（Natural Text Editing など） |
| Ignore | そのキーの入力を握りつぶす |
| Send Escape Sequence | ESC (`0x1B`) 始まりのシーケンスを送る（terminfo系のキー割当を上書きしたいときなど） |
| New Window/Tab with Profile | 指定プロファイルで新規ウィンドウ/タブを開く |
| Select Menu Item | メニュー項目をキー一発で実行 |
| Invoke Script Function | Python APIに登録した関数を呼ぶ（[python-api.md](python-api.md)参照） |
| Sequence... | 1つのキーに複数アクションを順番に登録する（下記参照） |

上記は代表例で網羅的ではない。Actionドロップダウンは検索欄で絞り込めるので、やりたいこと（`tab`, `pane`, `command` など）で検索して探すのが早い。

### Sequence... で複数アクションを1キーに束ねる

`+`でキーバインドを追加する際、Actionに `Sequence...` を選ぶと、そのキーで実行する既存アクションを複数個・順番に登録できる（例: `Select Output of Last Command` → `Copy` を1キーで）。

**できないこと**: Sequenceは既存の単発アクションを並べるだけで、「選択範囲を拡張する」ような合成はできない。たとえば「直前に実行したコマンド行 + その出力」をまとめて選択・コピーしたい場合、ネイティブアクションは `Select Output of Last Command`（出力のみ）と `Select Current Command`（今まさに入力中の行のみ、過去のコマンドは不可）の2つしかなく、両者を足し合わせる/選択範囲を上に伸ばすアクションが存在しないため、Sequenceだけでは実現できない。マウスでコマンド行や出力をクリックすると両方まとめて選択されるが、これは独立した挙動でキーバインドからは呼べない。この用途を完全に自動化するには結局Python API（[python-api.md](python-api.md)）でマークからコマンド文字列と出力を取得して連結するしかない。妥協案として、出力だけをSequenceでコピーし、直前のコマンド文字列はシェル側（zshなら `fc -ln -1`）で別途取得して連結する、という2段構えも検討に値する。

### キーバインドの生データを読む（plistのGlobalKeyMap）

キーバインドは `com.googlecode.iterm2.plist` の `GlobalKeyMap`（アプリ全体）またはプロファイル内の `Keys`（プロファイル単位）に保存される。dotfilesでこのplistをgit管理している場合、`git diff` でキーバインド変更を直接確認できる。

キーの形式は `0x<文字コード>-0x<修飾フラグ>-0x<仮想キーコード>`（すべて16進）。例:
- `0x74-0x40000-0x11` = 文字`t`(0x74) + Control(0x40000) + 仮想キーコード0x11(`T`キー) = `Ctrl+T`
- `0x79-0x1000000-0x10` = 文字`y`(0x79) + Leaderフラグ(0x1000000) + 仮想キーコード0x10(`Y`キー) = `Leader → Y`

修飾フラグはCocoaの `NSEventModifierFlags` がベース（`0x20000`=Shift, `0x40000`=Control, `0x80000`=Option, `0x100000`=Command）。`0x1000000` はCocoa標準にはない値で、iTerm2が「Leaderキーの後に続くキー」を示すために独自に立てているビットと見られる（Leaderキー自体は `Settings > Keys` の `Leader` に単体で `0x74-0x40000-0x11` のように保存される）。

値側の dict は以下のフィールドを持つ:

| キー | 内容 |
|---|---|
| `Action` | アクションの整数コード（後述） |
| `Text` | アクションによって使う文字列（`Send Text`の送信文字列、`Select Menu Item`のメニュー名、`Sequence`のJSON配列など）。使わないアクションは空文字列 |
| `Apply Mode` / `Escaping` / `Version` | 通常は触らなくてよい |

**`Action` が `0` でも「未設定」とは限らない**。iTerm2のアクション列挙は0始まりで、`0` にも `Next Tab` のような正当なアクションが割り当たっている。空の `Text` も、そのアクションが追加データを必要としないだけの場合がある。判別に迷ったら、GUIで実際にそのキーを押して動作確認するのが確実。

実際に確認できたAction番号の対応（バージョンによってズレる可能性があるので鵜呑みにせず、迷ったらGUIで確認し直すこと）:

| Action | 意味 |
|---|---|
| `0` | Next Tab |
| `2` | Previous Tab |
| `25` | Select Menu Item（`Text`にメニュー項目名） |
| `66` | Sequence（`Text`に各ステップのJSON配列） |
| `69` | Copy |

### Leaderキー（tmux風の二段階キーバインド）

iTerm2 3.5以降、**Leaderキー**を1つ指定し、「Leader押下 → 別のキー」の2段階バインドを組める（tmuxの `Ctrl-b` のような使い方）。

1. Settings > Keys > `Leader Key` にトリガーとなるキー（例: `Ctrl-t`）を設定
2. Key Bindings で「Leader」に続くキーの組み合わせとしてアクションを登録（例: `Leader` の後 `[` でCopy Modeに入る、`Leader` の後 `h`/`j`/`k`/`l` でペイン移動）

他のツール（tmux、WezTerm等）と同じキーをLeaderにすると衝突するため、既存の設定と被らないキーを選ぶ。

### 実用例: ペイン移動をvim風に

- Leader を `Ctrl-t` に設定
- `Leader` → `h`/`j`/`k`/`l`: Select Split Pane Left/Below/Above/Right
- `Leader` → `[`: Copy Mode に入る（コピーモード中は `hjkl` で移動、`v`/`V`/`r` で選択、`y` でクリップボードへ）

## Badges

セッション右上に薄く表示される文字列。設定場所は **Settings > Profiles > General > Badge**（初期値の文字列）、色は **Colors**、フォント/サイズは **General > Edit…**。

### 補間文字列として使う

Badgeは[interpolated string](python-api.md)（変数展開文字列）なので、静的テキストだけでなくセッション変数を埋め込める:

```
\(session.name) | \(user.gitBranch)
```

`user.*` は自分で定義したセッション変数で、シェル側から動的に設定できる（後述）。

### シェルから動的に更新する

OSC 1337 の `SetBadgeFormat` エスケープシーケンスに Base64 エンコードした文字列を渡すと、実行中にバッジを書き換えられる:

```bash
badge() {
  printf "\e]1337;SetBadgeFormat=%s\a" "$(printf '%s' "$1" | base64)"
}
badge "$(git branch --show-current 2>/dev/null)"
```

shell integrationのプロンプトフック（`precmd`/`chpwd`相当）にこれを仕込むと、ディレクトリ移動やコマンド実行のたびにバッジを最新化できる。

### 実用例

- 本番サーバーにSSHしているセッションだけバッジを赤字で `PRODUCTION` にする → Dynamic Profiles（[dynamic-profiles.md](dynamic-profiles.md)）でホストごとにプロファイルを分け、`Badge Text` と `Background Color` をプロファイル側で固定するのが最も事故が少ない（動的更新に頼らない）。

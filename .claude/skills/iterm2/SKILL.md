---
name: iterm2
description: iTerm2の設定を「配色を変える」レベルより一歩踏み込んで使いこなすためのスキル。Dynamic Profiles（JSONでプロファイルを動的生成）、Triggers（出力の正規表現マッチで色付け・通知・自動応答）、Smart Selection、Status Bar（システム情報や自作コンポーネント）、Badge、Python API（ウィンドウ/セッションの自動操作、常駐デーモン）、キーバインド（Leaderキー、hexコード送信、プリセット）、Semantic History、Coprocessesを扱う。「iTerm2でこれを自動化したい」「特定の出力にトリガーを仕込みたい」「SSH先ごとにプロファイルを自動生成したい」「ステータスバーに独自情報を出したい」「Pythonでiterm2を操作したい」「キーバインドをtmux風にしたい」といった依頼では積極的にこのスキルを使うこと。単なる配色・フォントのGUI設定変更だけならこのスキルは不要。
---

# iTerm2 深掘り設定ガイド

iTerm2はGUIの奥に、設定ファイル（JSON）とスクリプティングAPI（Python）でしか触れない機能を多く持つ。
このスキルは「もう一段踏み込んだ」設定・自動化をするための実務ガイド。目的別に該当するreferenceファイルを読み、そこに書かれた形式にそのまま従うこと（キー名やパスをうろ覚えで書かない）。

## まず確認すること

- 設定はすべて `com.googlecode.iterm2` の設定ドメイン（plist）に集約される。GUIで変更するのが基本だが、以下の機能はGUIだけでは完結せず、外部ファイル（JSON/Pythonスクリプト）を直接書く必要がある。
- 設定ファイル・スクリプトを直接編集するときは、必ず変更前にバックアップを取るか、gitなどで差分管理できる状態にしてから作業する。JSONを書いたら `plutil -lint` や `python3 -m json.tool` で構文チェックしてから保存する。
- **Triggers / Coprocess / Python APIは任意のコマンドを実行できる。** リモートホスト（SSH先など）が出力する文字列にマッチして `Run Command` や `Send Text` を自動実行する設定を作るときは、その出力が信頼できない相手から来る可能性（プロンプトインジェクション的な悪用）を考慮し、正規表現をできるだけ厳密にする。

## やりたいことから探す

| やりたいこと | 使う機能 | 詳細 |
|---|---|---|
| SSH先やプロジェクトごとにプロファイルを自動生成・一括管理したい | Dynamic Profiles | [references/dynamic-profiles.md](references/dynamic-profiles.md) |
| 特定の出力（エラー文字列、IPアドレス、プロンプトなど）に反応して色付け・通知・自動入力したい | Triggers | [references/triggers.md](references/triggers.md) |
| ダブルクリックや右クリックで独自のパターン（チケット番号、Pod名など）を賢く選択・実行したい | Smart Selection | [references/smart-selection.md](references/smart-selection.md) |
| ステータスバーにCPU/バッテリー/Git状態/独自情報を出したい | Status Bar | [references/status-bar.md](references/status-bar.md) |
| ウィンドウ/タブ/セッションをスクリプトで自動操作したい、常駐して監視・通知したい | Python API | [references/python-api.md](references/python-api.md) |
| tmux風のLeaderキーやhexコード送信など、キーバインドを凝った作りにしたい／バッジに動的情報を出したい | Key Bindings & Badges | [references/key-bindings-badges.md](references/key-bindings-badges.md) |

該当するreferenceファイルを開いて、そこに書かれたJSON/Pythonの型どおりに実装する。複数のreferenceにまたがる場合（例: Triggerからスクリプト関数を呼ぶ）は両方参照する。

## 横断的に効くTips

- **設定の反映方法はGUI操作が基本**。Dynamic Profiles用JSONと `~/Library/Application Support/iTerm2/Scripts/` 配下のPythonスクリプトは、iTerm2がファイル変更を検知して自動的に取り込む（フォルダを監視しているため、Dynamic Profilesは保存するだけで即座にプロファイル一覧へ反映される）。
- Preferences > General > Magic の **Enable Python API** を有効にしないと、Python APIもTriggerの `Invoke Script Function` もStatus Barの自作コンポーネントも動かない。まずここを確認する。
- Semantic History（Profile > Advanced）は、ファイルパスやURLをCmd+クリックしたときの挙動を差し替える機能で、エディタ連携（例: `subl {file}:{line}`）と相性がよい。Dynamic Profilesと組み合わせてプロジェクトごとに開くエディタを変えることもできる。
- 迷ったら公式ドキュメント（https://iterm2.com/documentation.html）が一次情報。referenceファイルに書いていない詳細な挙動や最新のキー名が必要なときは、実装前にWebFetch/WebSearchで一次情報を確認してから書く（バージョンによってキー名や挙動が変わることがあるため、うろ覚えで書かない）。

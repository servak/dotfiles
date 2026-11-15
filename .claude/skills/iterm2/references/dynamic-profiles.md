# Dynamic Profiles

JSONファイルでプロファイル（プロファイル一覧に出てくる設定の束）を宣言的に定義し、iTerm2に動的読み込みさせる機能。手でGUIから何十個もプロファイルを作らず、スクリプトで生成・更新できる。

## 配置場所

```
~/Library/Application Support/iTerm2/DynamicProfiles/*.json
```

このフォルダ内の `.json` ファイルは**保存した瞬間にiTerm2が自動で再読み込みする**（アプリの再起動不要）。ファイル名は任意（複数ファイルに分けてよい）。

## 基本スキーマ

```json
{
  "Profiles": [
    {
      "Name": "プロファイル名（プロファイル一覧に表示される）",
      "Guid": "グローバルに一意なID"
    }
  ]
}
```

- `Guid` は必須。`uuidgen` コマンドで生成するか、ホスト名など再現可能な文字列を使う（同じGuidで再読み込みすると同一プロファイルとして更新される＝スクリプトで冪等に管理できる）。
- `Name` も必須。

## よく使うキー

| キー | 用途 |
|---|---|
| `Dynamic Profile Parent Name` / `Dynamic Profile Parent GUID`（3.4.9+） | 既存プロファイルを継承し、差分だけ書く。継承元にないキーは継承元の値がそのまま使われる |
| `Rewritable` | `true` にすると、iTerm2のGUIからこのプロファイルを編集したときにこのJSONファイル自体が書き換えられる。`false`（省略時デフォルト）だとGUIでの変更はセッション限りで、ファイルを再読込すると消える |
| `Custom Command` | `"Yes"` にすると起動時に固定コマンドを実行するプロファイルになる |
| `Command` | `Custom Command` が `Yes` のとき実行するコマンド（例: `ssh foo.example.com`） |
| `Working Directory` / `Custom Directory` | 起動時のカレントディレクトリ |
| `Tags` | プロファイル一覧でのグルーピング用タグ（配列） |
| `Short Description` | プロファイル選択時の補足説明 |
| `Badge Text` | セッションバッジ（[key-bindings-badges.md](key-bindings-badges.md)参照） |
| 色・フォント系（`Ansi 0 Color`〜`Ansi 15 Color`, `Background Color`, `Foreground Color`, `Normal Font` など） | GUIでプロファイルを作って書き出した実際のplist/JSONの値を参考にするのが確実（キー名と値の型が厳密なため） |

## 実用例: SSH先ごとにプロファイルを自動生成

`~/.ssh/config` の `Host` エントリから、1ホスト1プロファイルを生成するスクリプト例（cronやシェルの起動時フックで実行し、DynamicProfilesディレクトリに書き出す）:

```python
#!/usr/bin/env python3
import json, re, pathlib, uuid

ssh_config = pathlib.Path.home() / ".ssh/config"
out = pathlib.Path.home() / "Library/Application Support/iTerm2/DynamicProfiles/ssh-hosts.json"

hosts = re.findall(r"^Host\s+(\S+)$", ssh_config.read_text(), re.MULTILINE)
profiles = []
for host in hosts:
    if "*" in host:
        continue
    profiles.append({
        "Name": f"ssh: {host}",
        # ホスト名から決定的に生成しておくと、再実行しても同一プロファイルとして更新される
        "Guid": str(uuid.uuid5(uuid.NAMESPACE_DNS, f"ssh-profile-{host}")),
        "Custom Command": "Yes",
        "Command": f"ssh {host}",
        "Tags": ["ssh"],
        "Dynamic Profile Parent Name": "Default",
    })

out.write_text(json.dumps({"Profiles": profiles}, indent=2))
```

保存直後にiTerm2のプロファイル一覧（Cmd+O のProfilesウィンドウなど）に反映される。

## 検証・トラブルシューティング

- 反映されないときは、まずJSON構文を疑う: `python3 -m json.tool ssh-hosts.json` でエラーが出ないか確認。
- `Guid` が既存プロファイルと衝突すると上書きになる。意図しない上書きは大抵Guidの重複が原因。
- `Rewritable` を `true` にしたプロファイルをGUIで編集すると、次回スクリプトで同じGuidのプロファイルを再生成したときに手動編集が失われる点に注意（自動生成と手動編集は原則どちらか一方にする）。

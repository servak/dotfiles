function __secrets_profiles
    command secrets list --names 2>/dev/null
end

set -l cmds list show load unload export run profile secret env check edit migrate help
complete -c secrets -f
complete -c secrets -n "not __fish_seen_subcommand_from $cmds" -a list -d 'プロファイル一覧'
complete -c secrets -n "not __fish_seen_subcommand_from $cmds" -a show -d '変数名・参照先・説明を表示'
complete -c secrets -n "not __fish_seen_subcommand_from $cmds" -a load -d 'プロファイルを読み込んで export'
complete -c secrets -n "not __fish_seen_subcommand_from $cmds" -a unload -d '読み込んだ変数を unset'
complete -c secrets -n "not __fish_seen_subcommand_from $cmds" -a export -d '各シェル・言語向けの形式で出力'
complete -c secrets -n "not __fish_seen_subcommand_from $cmds" -a run -d '変数を付けてコマンドを実行'
complete -c secrets -n "not __fish_seen_subcommand_from $cmds" -a profile -d 'プロファイルの追加・削除'
complete -c secrets -n "not __fish_seen_subcommand_from $cmds" -a secret -d '秘密の一覧を管理'
complete -c secrets -n "not __fish_seen_subcommand_from $cmds" -a env -d 'プロファイルの変数を追加・削除'
complete -c secrets -n "not __fish_seen_subcommand_from $cmds" -a check -d '設定ファイルを検証'
complete -c secrets -n "not __fish_seen_subcommand_from $cmds" -a edit -d '設定ファイルを編集'
complete -c secrets -n "not __fish_seen_subcommand_from $cmds" -a migrate -d '旧形式 .env を YAML へ変換'

complete -c secrets -n '__fish_seen_subcommand_from show load export run' -a '(__secrets_profiles)'
complete -c secrets -n '__fish_seen_subcommand_from unload' -a '(string split " " -- $SECRETS_LOADED)'
complete -c secrets -n '__fish_seen_subcommand_from export' -s f -l format -x -a 'sh bash zsh fish json dotenv'
complete -c secrets -n '__fish_seen_subcommand_from export' -l unset
complete -c secrets -n '__fish_seen_subcommand_from profile; and not __fish_seen_subcommand_from add rm' -a 'add rm'
complete -c secrets -n '__fish_seen_subcommand_from secret; and not __fish_seen_subcommand_from list add rm where' -a 'list add rm where'
complete -c secrets -n '__fish_seen_subcommand_from env; and not __fish_seen_subcommand_from add rm' -a 'add rm'
complete -c secrets -n '__fish_seen_subcommand_from profile; and __fish_seen_subcommand_from rm' -a '(__secrets_profiles)'
complete -c secrets -n '__fish_seen_subcommand_from secret; and __fish_seen_subcommand_from rm where' -a '(command secrets secret list --names 2>/dev/null)'
complete -c secrets -n '__fish_seen_subcommand_from env; and __fish_seen_subcommand_from add rm' -a '(__secrets_profiles; command secrets secret list --names 2>/dev/null)'
complete -c secrets -n '__fish_seen_subcommand_from migrate' -l force
complete -c secrets -n '__fish_seen_subcommand_from export' -s v -l verbose

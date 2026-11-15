function secrets --description '1Password-backed env profiles (wrapper for ~/.zsh/bin/secrets)'
    # load / unload は現在のシェルの環境変数を変えるため、本体の export 出力を source する
    switch "$argv[1]"
        case load
            set -l out (command secrets export --verbose --format fish $argv[2..-1] | string collect)
            or return 1
            printf '%s\n' $out | source
        case unload
            set -l out (command secrets export --verbose --format fish --unset $argv[2..-1] | string collect)
            or return 1
            printf '%s\n' $out | source
        case '' help -h --help
            command secrets --help
            echo "
shell commands (zsh / fish function):
  load   [profile...]  resolve with op and export into the current shell
  unload [profile...]  unset variables (default: every loaded profile)"
        case '*'
            command secrets $argv
    end
end

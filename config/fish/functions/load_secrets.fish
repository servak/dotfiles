function load_secrets --description 'Load environment secrets from 1Password templates'
    if not command -sq op
        echo "load_secrets: 1Password CLI 'op' is not installed" >&2
        return 1
    end

    set -l name current
    if test (count $argv) -gt 0
        set name $argv[1]
    end

    set -l template ~/.config/fish/secrets/$name.fish

    if not test -f $template
        echo "load_secrets: template not found: $template" >&2
        echo "copy one of the examples in ~/.config/fish/secrets/examples/ to $template and fill in your op:// references" >&2
        return 1
    end

    op inject -i $template | source
    set -l pipe_status $pipestatus
    set -l inject_status $pipe_status[1]
    set -l source_status $pipe_status[2]

    if test $inject_status -ne 0
        echo "load_secrets: op inject failed" >&2
        return $inject_status
    end

    if test $source_status -ne 0
        echo "load_secrets: failed to source injected template" >&2
        return $source_status
    end
end

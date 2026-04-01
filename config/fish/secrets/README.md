# fish secrets templates

`load_secrets` reads `~/.config/fish/secrets/current.local.fish` and runs it through `op inject`.

## Usage

Pick the example that matches your environment and copy it to `current.local.fish`.

```fish
cp ~/.config/fish/secrets/examples/home.local.fish.example ~/.config/fish/secrets/current.local.fish
```

Then update the file with your own 1Password secret references.

```fish
set -gx JIRA_API_TOKEN "{{ op://Personal/JIRA/credential }}"
```

Load secrets:

```fish
load_secrets
```

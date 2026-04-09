# fish secrets templates

`load_secrets` reads `~/.config/fish/secrets/current.fish` by default and runs it through `op inject`.
You can also pass a template name such as `load_secrets home`, which reads `~/.config/fish/secrets/home.fish`.

## Usage

Pick the example that matches your environment and copy it to `current.fish`.

```fish
cp ~/.config/fish/secrets/examples/home.fish.example ~/.config/fish/secrets/current.fish
```

Then update the file with your own 1Password secret references.

```fish
set -gx JIRA_API_TOKEN "{{ op://Personal/JIRA/credential }}"
```

Load the default template:

```fish
load_secrets
```

Load a named template:

```fish
load_secrets home
```

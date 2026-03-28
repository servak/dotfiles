# AGENTS

## Shell policy

- `fish` is intended for macOS laptop use only.
- Server work on Linux is expected to continue using `zsh`.
- When changing `config/fish/**`, optimize for the macOS local environment rather than Linux compatibility.
- When changing `zsh` or shared dotfiles, keep Linux server workflows in mind.

## Review guidance

- Treat `fish` settings as macOS-scoped unless a change explicitly states otherwise.
- Do not raise Linux compatibility findings for `fish`-only behavior by default.
- If a shell change affects both `fish` and `zsh`, review each target environment separately.

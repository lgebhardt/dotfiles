# codex

This topic manages local-only Codex configuration from inside the dotfiles repo
without committing machine-specific settings.

## Files

- `config.toml`: your untracked local Codex config.
- `config.toml.example`: example starting point.
- `models.zsh`: your untracked local Codex model definitions.
- `models.zsh.example`: example model definitions.
- `functions.zsh`: your untracked local Codex shell helpers.
- `functions.zsh.example`: example shell helpers.
- `install.sh`: initializes or replaces `~/.codex/config.toml` and the
  corresponding files under `~/.config/codex/`.

## Usage

1. Copy any needed `*.example` file to its local counterpart, or edit the local
   files already present in this directory.
2. Run:

```sh
script/install
```

If any managed target already exists and differs, the installer asks before
replacing it and keeps a one-time `.pre-dotfiles` backup.

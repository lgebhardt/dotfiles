# hosts

This topic manages a local-only hosts file fragment from inside the dotfiles
repo without committing machine-specific entries.

## Files

- `hosts.local`: your untracked local entries.
- `hosts.local.example`: example format.
- `install.sh`: merges `hosts.local` into `/etc/hosts` inside a managed block.

## Usage

1. Copy `hosts.local.example` to `hosts.local`.
2. Add the host entries you want to keep locally.
3. Run:

```sh
script/install
```

The installer keeps a one-time backup at `/etc/hosts.pre-dotfiles` and rewrites
only the managed block in `/etc/hosts`.

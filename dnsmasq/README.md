# dnsmasq

This topic tracks the `dnsmasq` configuration that sits outside your home
directory on macOS.

## What gets managed

- `dnsmasq.conf.template`: rendered into Homebrew's `etc/dnsmasq.conf` with the
  active Homebrew prefix.
- `dnsmasq.d/*.conf`: symlinked into Homebrew's `etc/dnsmasq.d/`.
- `resolver/*`: if present, symlinked into `/etc/resolver/` with `sudo`.
- The `dnsmasq` Homebrew service: started automatically if not already loaded,
  or restarted when the tracked config changes.

## Import from another Mac

Copy the files you actually use from the source machine into this repo:

- `$(brew --prefix)/etc/dnsmasq.d/*.conf` -> `dnsmasq/dnsmasq.d/`
- `/etc/resolver/*` -> `dnsmasq/resolver/`

These directories are gitignored except for their `.gitignore` files so you can
keep machine-specific DNS config locally without publishing it.

Then run:

```sh
script/install
```

If resolver files were added, or if `dnsmasq` needs to be started or restarted,
the installer will prompt for `sudo`.

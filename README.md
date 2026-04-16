# lgebhardt's dotfiles

Many thanks to [Zach Holman](https://github.com/holman) for providing the basis
for these dotfiles in [this repo](https://github.com/holman/dotfiles).

To understand the philosophy of this project, [read Zach's post on the
subject](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/).

## topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
files in there. Anything with an extension of `.zsh` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `script/bootstrap`.

## what's inside

A lot of stuff. Seriously, a lot of stuff. Check them out in the file browser
above and see what components may mesh up with you.
[Fork it](https://github.com/dgeb/dotfiles/fork), remove what you don't
use, and build on what you do use.

## components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded
  last and is expected to setup autocomplete.
- **topic/install.sh**: Any file named `install.sh` is executed when you run `script/install`. To avoid being loaded automatically, its extension is `.sh`, not `.zsh`.
- **topic/\*.symlink**: Any file ending in `*.symlink` gets symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.

## install

On a fresh Mac, install Xcode Command Line Tools first. This provides Git and
other basic developer tools:

```sh
xcode-select --install
```

Then run:

```sh
git clone https://github.com/lgebhardt/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

Put machine-specific environment variables and overrides in `~/.localrc`.
Keep repo-tracked shell files portable so a new machine can bootstrap cleanly.

`dot` is a simple script that installs some dependencies, sets sane macOS
defaults, and so on. Tweak this script, and occasionally run `dot` from
time to time to keep your environment fresh and up-to-date. You can find
this script in `bin/`.

By default the Homebrew install only applies the base package set. To also
install the larger optional toolchain, run:

```sh
DOTFILES_INSTALL_EXTRAS=1 script/bootstrap
```

## new machine checklist

1. Install Xcode Command Line Tools:

   ```sh
   xcode-select --install
   ```

2. Clone the repo:

   ```sh
   git clone https://github.com/lgebhardt/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

3. Optionally create `~/.localrc` for machine-specific environment variables
   and overrides.

4. Run the base bootstrap:

   ```sh
   script/bootstrap
   ```

5. If this machine still needs the optional toolchain, install extras too:

   ```sh
   DOTFILES_INSTALL_EXTRAS=1 script/bootstrap
   ```

6. Open a new shell so PATH and Homebrew environment changes are loaded.

7. Install anything not managed here, such as App Store apps, Docker Desktop,
   SSH keys, and language-specific runtimes.

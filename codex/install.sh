#!/bin/sh

set -e

DOTFILES_ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
CODEX_TOPIC_DIR="$DOTFILES_ROOT/codex"

configs_match() {
  normalized_source=$(mktemp)
  normalized_target=$(mktemp)

  perl -0pe 's/\n+\z/\n/' "$1" > "$normalized_source"
  perl -0pe 's/\n+\z/\n/' "$2" > "$normalized_target"

  if cmp -s "$normalized_source" "$normalized_target"
  then
    rm -f "$normalized_source" "$normalized_target"
    return 0
  fi

  rm -f "$normalized_source" "$normalized_target"
  return 1
}

install_managed_file() {
  name=$1
  target_dir=$2
  target_file=$3

  source_local="$CODEX_TOPIC_DIR/$name"
  source_example="$CODEX_TOPIC_DIR/$name.example"
  backup_file="${target_file}.pre-dotfiles"

  if [ -f "$source_local" ]
  then
    source_file="$source_local"
  elif [ -f "$source_example" ]
  then
    source_file="$source_example"
  else
    return 0
  fi

  mkdir -p "$target_dir"

  if [ ! -f "$target_file" ]
  then
    cp "$source_file" "$target_file"
    echo "  Initialized $target_file"
    return 0
  fi

  if configs_match "$source_file" "$target_file"
  then
    return 0
  fi

  printf "  Replace %s with %s? [y/N] " "$target_file" "$source_file"
  read answer

  case "$answer" in
    y|Y|yes|YES)
      if [ ! -f "$backup_file" ]
      then
        cp "$target_file" "$backup_file"
        echo "  Backed up $target_file to $backup_file"
      fi

      cp "$source_file" "$target_file"
      echo "  Updated $target_file"
      ;;
    *)
      echo "  Skipped $target_file"
      ;;
  esac
}

install_managed_file "config.toml" "$HOME/.codex" "$HOME/.codex/config.toml"
install_managed_file "models.zsh" "$HOME/.config/codex" "$HOME/.config/codex/models.zsh"
install_managed_file "functions.zsh" "$HOME/.config/codex" "$HOME/.config/codex/functions.zsh"

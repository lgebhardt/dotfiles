#!/bin/sh

set -e

if ! command -v brew >/dev/null 2>&1
then
  exit 0
fi

DOTFILES_ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
BREW_PREFIX=$(brew --prefix)
SERVICE_CHANGED=0

SOURCE_MAIN_TEMPLATE="$DOTFILES_ROOT/dnsmasq/dnsmasq.conf.template"
SOURCE_RULES_DIR="$DOTFILES_ROOT/dnsmasq/dnsmasq.d"
SOURCE_RESOLVER_DIR="$DOTFILES_ROOT/dnsmasq/resolver"

TARGET_MAIN="$BREW_PREFIX/etc/dnsmasq.conf"
TARGET_RULES_DIR="$BREW_PREFIX/etc/dnsmasq.d"
TARGET_RESOLVER_DIR="/etc/resolver"

backup_file() {
  target=$1
  backup="${target}.pre-dotfiles"

  if [ -e "$backup" ] || [ -L "$backup" ]
  then
    return 0
  fi

  mv "$target" "$backup"
  echo "  Backed up $target to $backup"
}

link_file() {
  source=$1
  target=$2

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]
  then
    return 0
  fi

  if [ -e "$target" ] || [ -L "$target" ]
  then
    backup_file "$target"
  fi

  ln -s "$source" "$target"
  SERVICE_CHANGED=1
  echo "  Linked $target"
}

write_main_config() {
  temp_file=$(mktemp)
  sed "s|{{BREW_PREFIX}}|$BREW_PREFIX|g" "$SOURCE_MAIN_TEMPLATE" > "$temp_file"

  if [ -e "$TARGET_MAIN" ] || [ -L "$TARGET_MAIN" ]
  then
    if ! cmp -s "$temp_file" "$TARGET_MAIN"
    then
      backup_file "$TARGET_MAIN"
      SERVICE_CHANGED=1
    else
      rm -f "$temp_file"
      return 0
    fi
  else
    SERVICE_CHANGED=1
  fi

  mv "$temp_file" "$TARGET_MAIN"
  echo "  Wrote $TARGET_MAIN"
}

manage_service() {
  if ! brew list dnsmasq >/dev/null 2>&1
  then
    return 0
  fi

  service_info=$(brew services info dnsmasq 2>/dev/null || true)

  if echo "$service_info" | grep -q "Loaded: true"
  then
    if [ "$SERVICE_CHANGED" = "1" ]
    then
      sudo brew services restart dnsmasq
    fi
  else
    sudo brew services start dnsmasq
  fi
}

mkdir -p "$TARGET_RULES_DIR"
write_main_config

if [ -d "$SOURCE_RULES_DIR" ]
then
  for source in "$SOURCE_RULES_DIR"/*.conf
  do
    if [ ! -f "$source" ]
    then
      continue
    fi

    link_file "$source" "$TARGET_RULES_DIR/$(basename "$source")"
  done
fi

if [ -d "$SOURCE_RESOLVER_DIR" ] && find "$SOURCE_RESOLVER_DIR" -maxdepth 1 -type f ! -name '.keep' | grep -q .
then
  sudo mkdir -p "$TARGET_RESOLVER_DIR"
  for source in "$SOURCE_RESOLVER_DIR"/*
  do
    if [ ! -f "$source" ]
    then
      continue
    fi

    target="$TARGET_RESOLVER_DIR/$(basename "$source")"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]
    then
      continue
    fi

    if sudo test -e "$target" || sudo test -L "$target"
    then
      if ! sudo test -e "${target}.pre-dotfiles" && ! sudo test -L "${target}.pre-dotfiles"
      then
        sudo mv "$target" "${target}.pre-dotfiles"
        echo "  Backed up $target to ${target}.pre-dotfiles"
      fi
    fi

    sudo ln -s "$source" "$target"
    echo "  Linked $target"
  done
fi

manage_service

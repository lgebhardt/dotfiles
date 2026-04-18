#!/bin/sh

set -e

DOTFILES_ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
SOURCE_FILE="$DOTFILES_ROOT/hosts/hosts.local"
TARGET_FILE="/etc/hosts"
BACKUP_FILE="/etc/hosts.pre-dotfiles"
START_MARKER="# >>> dotfiles hosts >>>"
END_MARKER="# <<< dotfiles hosts <<<"

if [ ! -f "$SOURCE_FILE" ]
then
  exit 0
fi

if [ ! -f "$BACKUP_FILE" ]
then
  sudo cp "$TARGET_FILE" "$BACKUP_FILE"
  echo "  Backed up $TARGET_FILE to $BACKUP_FILE"
fi

temp_file=$(mktemp)

sudo awk -v start="$START_MARKER" -v end="$END_MARKER" '
  $0 == start { in_block=1; next }
  $0 == end { in_block=0; next }
  !in_block { print }
' "$TARGET_FILE" > "$temp_file"

{
  cat "$temp_file"
  printf "\n%s\n" "$START_MARKER"
  cat "$SOURCE_FILE"
  printf "%s\n" "$END_MARKER"
} > "${temp_file}.new"

if sudo cmp -s "${temp_file}.new" "$TARGET_FILE"
then
  rm -f "$temp_file" "${temp_file}.new"
  exit 0
fi

sudo cp "${temp_file}.new" "$TARGET_FILE"
rm -f "$temp_file" "${temp_file}.new"
echo "  Updated $TARGET_FILE"

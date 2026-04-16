export PATH="$ZSH/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

if command -v brew >/dev/null 2>&1; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"

  if [ -d "$HOMEBREW_PREFIX/opt/bison/bin" ]; then
    export PATH="$HOMEBREW_PREFIX/opt/bison/bin:$PATH"
  fi

  if [ -d "$HOMEBREW_PREFIX/opt/libpq/bin" ]; then
    export PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"
  fi
fi

#export PATH="/usr/local/opt/node@14/bin:$PATH"

export MANPATH="/usr/local/man:/usr/local/git/man:$MANPATH"

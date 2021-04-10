# https://volta.sh/

export VOLTA_HOME="/Users/dgeb/.volta"
grep --silent "$VOLTA_HOME/bin" <<< $PATH || export PATH="$VOLTA_HOME/bin:$PATH"

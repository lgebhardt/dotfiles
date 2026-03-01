# sup yarn
# https://yarnpkg.com

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

if (( $+commands[yarn] ))
then
  export PATH="$PATH:`yarn global bin`"
fi

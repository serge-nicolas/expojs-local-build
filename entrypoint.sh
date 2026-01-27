#!bin/bash

echo "In folder $(pwd)"

# ensure package.json is present
if [ ! -f package.json ]; then
  echo "Error: package.json not found in $(pwd)" >&2
  exit 1
fi

source /root/.nvm/nvm.sh

NODE_VERSION_USER=$(sudo cat $(pwd)/package.json | jq -r '.engines.node')

echo .
echo installing node version ${NODE_VERSION_USER}

# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
# export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install $NODE_VERSION_USER

echo #### init git globally, needed for eas
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git restore .
git config --global --add safe.directory /root/build
git config --global --add safe.directory /root/build/.git

# installing expo globally
npm i -g expo-cli eas-cli @sentry/cli

# add your login credentials here here
sentry-cli login --auth-token sntrys_********

echo #### installing
yarn install

echo #### review and upgrade dependencies
npx expo doctor --fix-dependencies

echo #### build
# change for your package.json command to build
yarn run dev:build-local:preview

echo #### done

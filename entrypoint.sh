#!bin/sh
echo .

echo $(pwd)

# ensure package.json is present
if [ ! -f package.json ]; then
  echo "Error: package.json not found in $(pwd)" >&2
  exit 1
fi

# needed for EAS
git config --global --add safe.directory /root/build
git status

echo #### installing
yarn install

echo #### build
# change for your package.json command to build
yarn run dev:build-local:preview

echo #### done

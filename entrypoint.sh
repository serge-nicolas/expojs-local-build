#!bin/sh
echo .

echo $(pwd)

ls -la
# needed for EAS
git config --global --add safe.directory /root/build
git status

echo #### installing
yarn install

echo #### build
# change for your package.json command to build
yarn run dev:build-local:preview

echo #### done

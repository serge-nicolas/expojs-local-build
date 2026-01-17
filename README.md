# expojs-local-build

WIP - not working

Build your ExpoJS/EAS locally app with Docker.
Install in Docker all you need for Expo application, Android only.

## Versions

Node: 20.19.6

## How To

- create Github token
- create ExpoJS token

At docker host :
- create ~/repos/
- clone your repo

Create launcher in ~/repo :
```sh
echo -----------------------------------------

echo Launching build...
echo ...of:             $1
echo ...from image:     $2
echo ----------------------------------------

if [ -z "${EXPO_TOKEN}" ]; then
  echo "EXPO_TOKEN is not defined, see https://docs.expo.dev/accounts/programmatic-access/"
  exit 1
else
  echo "EXPO_TOKEN is defined"
fi

CWD=$(pwd)
REPO="$CWD/$1"

if [[ -d $REPO ]]; then
    echo "...$REPO is a directory"
    echo "...starting docker $2"
else
    echo "$REPO is not valid"
    exit 1
fi
```

Build Docker image
```sh
docker build . -t expojs-builder
```

Launch in ~/repos
```sh
export EXPO_TOKEN=XXXXXX && ./launcher.sh your_repo_dir expojs-builder
```

## package.json

Should have a line like
```
"dev:build-local:preview": "NODE_ENV=production npx eas-cli build --profile preview --platform android --local --clear-cache --freeze-credentials --non-interactive",
```


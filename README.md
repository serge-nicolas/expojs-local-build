# expojs-local-build

WIP - not working

Build your ExpoJS/EAS locally app with Docker.
Install in Docker all you need for Expo application, Android only.

## Versions

Node: 20.19.6

## warning

See https://docs.gradle.org/current/userguide/compatibility.html


## How To

- create Github token
- create ExpoJS token

At docker host :
- create ~/repos/
- clone your repo

Create launcher in ~/repo :
```sh
DEBUG=0

# Parse args
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    --debug)
      DEBUG=1
      shift # past argument
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}"

echo "-----------------------------------------"

echo "Launching build..."
echo "   of:             $1"
echo "   from image:     $2"
echo "   expo token :    $EXPO_TOKEN"
echo "   debug mode :    $DEBUG"
echo "----------------------------------------"

if [ -z "${EXPO_TOKEN}" ]; then
  echo "EXPO_TOKEN is not defined, see https://docs.expo.dev/accounts/programmatic-access/"
  exit 1
else
  echo "EXPO_TOKEN is defined"
fi

CWD=$(pwd)
REPO="$CWD/$1"

if [[ -d $REPO ]]; then
    echo "... $REPO is a directory"
    echo "... starting docker $2"
    if [ "$DEBUG" -eq 1 ]; then
        echo "... in debug mode"
        echo "The Docker $1-debug will be kept alive"
        docker run --name "$1-debug" -e EXPO_TOKEN="${EXPO_TOKEN}" --mount src="${REPO}",target=/root/build,type=bind "$2" tail -f /dev/null
    else
        echo "... in prod mode"
        docker run --name "$1" -e EXPO_TOKEN="${EXPO_TOKEN}" --mount src="${REPO}",target=/root/build,type=bind "$2"
        docker rm $1
    fi
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


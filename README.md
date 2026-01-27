# expojs-local-build

WIP - APK file generated but SDK/NDK and gradle are redownloaded and reinstalled.

Build your ExpoJS/EAS locally app with a prebuild Docker image.
Install in Docker all you need for Expo application, Android only.

## Versions

Node will be installed from your package.json ```{"engines" : { "node" : "20.19.6" }}``` using nvm
Default node version : 20.20.0

## warning

See https://docs.gradle.org/current/userguide/compatibility.html


## How To

- create Github token
- create ExpoJS token

At docker host :
- create ~/repos/
- clone your reo in a subfolder

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
        docker rm $1your_repo_dir
    fi
else
    echo "$REPO is not valid"
    exit 1
fi
```

Build the Docker image
```sh
docker build . -t expojs-builder
```

Launch in ~/repos, this create a docker named 'your_repo_dir'
```sh
export EXPO_TOKEN=XXXXXX && ./launcher.sh your_repo_dir expojs-builder
```

The APK/AAB file generated can be found in the ~/repos/your_repo_dir/.



Start the container for manually building strategy
```sh
export EXPO_TOKEN=XXXXXX && ./launcher.sh your_repo_dir expojs-builder --debug
docker exec -it your_repo_dir /bin/bash
```

## the generated file

To install the file in your device, use KDEConnect (easyiest) or use ADB.

To use ADB :
- download android tools : https://developer.android.com/tools/releases/platform-tools
On your device
Go to the developer settings
Press Enable Wireless debugging
Select Pair device with pairing code
You will see a dialog showing you IP address, port and a code.

On your computer
Open a command line window
Type adb pair <ip>:<port> and replace <ip> and <port> with the data seen on the device
You will be asked for the pairing code. Type it in and hit Enter
You will now see an output similar to Successfully paired to <ip>:<port>
To connect to the device, type adb connect <ip>:<port> and replace <ip> and <port> with the data seen on the Wireless debugging page after closing the pairing dialog
Additionally you will get a notification on your device.

(from https://wiki.lineageos.org/how-to/adb-over-wifi/)

Rename your file.

Push to your device :
```
adb push your.apk /your/destination/dir
```

Or install direclty
```
adb -s <ip>:<port> install -r your-builded.apk
```

your can find your destination dir with 
```
adb shell
```

Use a VPN if the host and the device are not on the same network.

## package.json

Should have a line like
```
"dev:build-local:preview": "NODE_ENV=production npx eas-cli build --profile preview --platform android --local --clear-cache --freeze-credentials --non-interactive",
```
or adjust the ```yarn run``` in entrypoint.sh.


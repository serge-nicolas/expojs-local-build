FROM node:20-alpine

ARG repo

# build-essential: compilers etc.
# devscripts: make command etc.
# java jdk: android sdk tools require it
RUN apk update

RUN apk add git curl unzip
RUN apk add npm
RUN apk add openjdk25-jdk

# install android sdk
# download URL: https://developer.android.com/studio#command-tools
ENV ANDROID_HOME=/root
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools
RUN curl -L https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip -o sdktools.zip && \
    unzip sdktools.zip -d /root && \
    rm sdktools.zip
RUN mkdir ~/.android && touch ~/.android/repositories.cfg && \
    yes | /root/cmdline-tools/bin/sdkmanager --sdk_root=/root/cmdline-tools/ "platform-tools" "build-tools;36.1.0" "platforms;android-36"

# install android ndk
# 'ndk-bundle' is the default directory name when NDK is installed through Android Studio so reusing that naming convention
# download URL: https://developer.android.com/ndk/downloads
RUN curl -L https://dl.google.com/android/repository/android-ndk-r29-linux.zip?hl=fr -o androidndk.zip && \
    unzip androidndk.zip -d /root && \
    rm androidndk.zip && \
    mv /root/android-ndk* /root/ndk-bundle

# setup env vars and paths
ENV CONTAINER=true \
    ANDROID_SDK_PATH=/root \
    ANDROID_SDK_ROOT=/root \
    ANDROID_NDK_PATH=/root/ndk-bundle \
    ANDROID_NDK_ROOT=/root/ndk-bundle

RUN npm i -g npm eas-cli

WORKDIR /root/build

COPY entrypoint.sh /docker-entrypoint.d/

RUN chmod +x /docker-entrypoint.d/entrypoint.sh
CMD ["sh", "/docker-entrypoint.d/entrypoint.sh"]

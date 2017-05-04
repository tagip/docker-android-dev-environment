FROM ubuntu:16.10

# Install dependencies
# Install nodejs, git, curl, etc...
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -yq libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386 --no-install-recommends && \
  apt-get install -yq --no-install-recommends nodejs npm git bzip2 curl openjdk-8-jdk unzip && \
  ln -s /usr/bin/nodejs /usr/bin/node && \
  node -v && \
  npm -v && \
  npm i -g phantomjs-prebuilt && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install cordova, bower and grunt with npm
RUN npm install -g cordova bower grunt-cli && \
  npm cache clean && \
  cordova -v && \
  grunt -V && \
  bower -v

# Download and untar SDK
ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN curl -L "${ANDROID_SDK_URL}" | tar --no-same-owner -xz -C /usr/local
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:${ANDROID_HOME}/build-tools/25.0.3/bin:$PATH

# Install Android SDK components
# License Id: android-sdk-license-ed0d0a5b
# ENV ANDROID_COMPONENTS platform-tools,build-tools-23.0.3,build-tools-24.0.0,build-tools-24.0.2,android-23,android-24
ENV ANDROID_COMPONENTS platform-tools,build-tools-25.0.3,android-25
# License Id: android-sdk-license-5be876d5
ENV GOOGLE_COMPONENTS extra-android-m2repository,extra-google-m2repository

RUN echo y | android update sdk --no-ui --all --filter "${ANDROID_COMPONENTS}" ; \
  echo y | android update sdk --no-ui --all --filter "${GOOGLE_COMPONENTS}"

# Cleaning up
RUN apt-get remove -y curl unzip && \
  apt-get clean && \
  apt-get autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* && \
  rm -fr /tmp/*

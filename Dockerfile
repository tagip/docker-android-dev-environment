FROM ubuntu:16.10

# Update apt-get
RUN apt-get update

# Install nodejs and git
RUN apt-get install -y --no-install-recommends nodejs npm git bzip2 && \
 ln -s /usr/bin/nodejs /usr/bin/node && \
 node -v && \
 npm -v

# Install cordova, bower and grunt with npm
RUN npm install -g cordova bower grunt-cli phantomjs-prebuilt && \
 npm cache clean && \
 cordova -v && \
 grunt -V && \
 bower -v

# Install android sdk
ENV ANDROID_HOME="/usr/lib/android-sdk/"
ENV PATH="/usr/lib/android-sdk/tools:${PATH}"
RUN apt-get install -y --no-install-recommends android-sdk && \
 ls $ANDROID_HOME

# Cleaning up
RUN apt-get remove -y curl && \
 apt-get clean && \
 apt-get autoremove -y && \
 rm -rf /var/lib/apt/lists/* && \
 rm -fr /tmp/*

# Nativescript Angular2 developer container
# Use at your own risk!
# alias tns="docker run -ti --rm --privileged -v /dev/bus/usb:/dev/bus/usb -v \$PWD:/myApp:rw bekkere/docker-nativescript:latest tns"
#

FROM ubuntu:16.04
ENV DEBIAN_FRONTEND=noninteractive

MAINTAINER bekkere <bekkere@gmail.com>

LABEL Description="Nativescript Dev container using /myApp volume, expose port 8100 and 35729, for your app directories"

# Update and install software-properties-common (required for add-apt-repository) and curl
RUN apt-get update && apt-get install -y software-properties-common curl

# Add Java ppa and update apt list
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
  && add-apt-repository -y ppa:webupd8team/java \
  && apt-get update

# Download and add Node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
# RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -

# install nodejs, npm and git
RUN apt-get install -y -q \
            lib32z1 \
            lib32ncurses5 \
            libbz2-1.0 \
            lib32stdc++6 \
            g++ \
            ant \
            python \
            make \
            python-software-properties \
            nodejs \
            git \
            oracle-java8-installer \
            && apt-get -y autoclean \
            && rm -rf /var/lib/apt/lists/* \
            && rm -rf /var/cache/oracle-jdk8-installer

# download and extract android sdk
RUN curl http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz | tar xz -C /usr/local/

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $PATH:$JAVA_HOME
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# update and accept licences
RUN ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | $ANDROID_HOME/tools/android update sdk --all --no-ui --filter tools,platform-tools,android-23,build-tools-23.0.3,extra-android-m2repository,extra-google-m2repository,extra-android-support


RUN npm install -g -y typescript --unsafe-perm
RUN npm install -g -y nativescript --unsafe-perm

#ENV GRADLE_USER_HOME /src/gradle
# Do NOT use VOLUME statement as it may result in orphaned volumes
# docker run --rm ... bash
# VOLUME /myApp
# VOLUME /src
# WORKDIR /src
WORKDIR /myApp

CMD ["bash"]
#EXPOSE 8100 35729

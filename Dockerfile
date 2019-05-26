#
# Minimum Docker image to build Android AOSP
#
FROM ubuntu:16.04

MAINTAINER Kyle Manna <kyle@kylemanna.com>

# /bin/sh points to Dash by default, reconfigure to use bash until Android
# build becomes POSIX compliant
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure -p critical dash

# Keep the dependency list as short as reasonable
RUN apt-get update && \
    apt-get install -y \
        bc \
        bison \
        bsdmainutils \
        build-essential \
        curl \
        flex \
        g++-multilib \
        gcc-multilib \
        git \
        git-core \
        gnupg \
        gperf \
        graphviz \
        lib32ncurses5-dev \
        lib32stdc++6 \
        lib32z-dev \
        lib32z1-dev \
        libc6-dev \
        libesd0-dev \
        libgl1-mesa-dev \
        liblz4-tool \
        libncurses5-dev \
        libsdl1.2-dev \
        libssl-dev \
        libswitch-perl \
        libwxgtk3.0-dev \
        libx11-dev \
        libxml-libxml-perl \
        libxml-simple-perl \
        libxml2-utils \
        lzop \
        minizip \
        openjdk-8-jdk \
        perl \
        pngcrush \
        rar \
        schedtool \
        squashfs-tools \
        sudo \
        unzip \
        vim \
        x11proto-core-dev \
        xsltproc \
        yasm \
        zip \
        zlib1g-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://commondatastorage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

# Install latest version of JDK
# See http://source.android.com/source/initializing.html#setting-up-a-linux-build-environment
WORKDIR /tmp

# All builds will be done by user aosp
COPY gitconfig /root/.gitconfig
COPY ssh_config /root/.ssh/config

# The persistent data will be in these two directories, everything else is
# considered to be ephemeral
VOLUME ["/tmp/ccache", "/aosp"]

# Work in the build directory, repo is expected to be init'd here
WORKDIR /aosp

COPY utils/docker_entrypoint.sh /root/docker_entrypoint.sh
RUN chmod 755 /root/docker_entrypoint.sh
ENTRYPOINT ["/root/docker_entrypoint.sh"]

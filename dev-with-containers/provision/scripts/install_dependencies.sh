#! /bin/sh
#
# Install dependencies
#
apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    apt-transport-https \
    binutils \
    build-essential \
    ca-certificates \
    clang \
    cmake \
    cmatrix \
    curl \
    dirmngr \
    dbus-user-session \
    dos2unix \
    ffmpeg \
    figlet \
    fuse-overlayfs \
    fzf \
    git \
    gnupg \
    gnupg2 \
    hexyl \
    httpie \
    jq \
    less \
    libatomic1 \
    libblas-dev \
    libc6-dev \
    libcairo2-dev \
    libcurl4 \
    libedit2 \
    libffi-dev \
    libgmp10 \
    libgmp-dev \
    liblapack-dev \
    libmagic-dev \
    libncurses-dev \
    libncurses5 \
    libpango1.0-dev \
    libpango-1.0-0 \
    libpython2.7 \
    libsqlite3-0 \
    libsqlite3-dev \
    libssl-dev \
    libtinfo5 \
    libtinfo-dev \
    libudev-dev \
    libxcb-shape0-dev \
    libxcb-xfixes0-dev \
    libxml2 \
    libz3-dev \
    libzmq3-dev \
    libzmq5 \
    libzmq5-dev \
    lld \
    lldb \
    nano \
    neovim \
    net-tools \
    netcat \
    netbase \
    openssh-server \
    openssl \
    pkg-config \
    python3-dev \
    python3-pip \
    python3-setuptools \
    rlwrap \
    screen \
    slirp4netns \
    snapd \
    sudo \
    tree \
    tzdata \
    unzip \
    uuid-dev \
    zip \
    zlib1g-dev \
    zsh
#
# Clean up
#
apt-get clean
rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*
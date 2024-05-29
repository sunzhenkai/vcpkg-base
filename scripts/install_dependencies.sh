#!/bin/bash
#set -x
# check os information
if [ -f "/etc/os-release" ]; then
    . /etc/os-release
elif [ -f "/etc/arch-release" ]; then
    export ID=arch
elif [[ "$OSTYPE" =~ ^darwin ]]; then
    export ID="darwin"
else
    echo "/etc/os-release missing."
    exit 1
fi

debian_packages=(
    curl
    zip
    unzip
    tar
    wget
    cmake
    autoconf
    ninja-build
    make
    git
    pkg-config
    libtool
    libpciaccess-dev
    xfslibs-dev
    libgnutls28-dev
    libsctp-dev
    systemtap-sdt-dev
    valgrind
    bison
    flex
    kernel-devel
)

fedora_packages=(
)

# centos7 & centos8 common packages
redhat_packages=(
    perl-IPC-Cmd
    perl-Data-Dumper
    flex
    bison
)

centos7_packages=(
    "${redhat_packages[@]}"
)

centos8_packages=(
    "${redhat_packages[@]}"
)

arch_packages=(
    curl
    zip
    unzip
    tar
    cmake
    ninja
    make
    git
)

opensuse_packages=(
)

brew_packages=(
)

case "$ID" in
ubuntu | debian | pop)
    apt-get install -y "${debian_packages[@]}"
    ;;
fedora)
    dnf install -y "${fedora_packages[@]}"
    ;;
# alinux: ali-yun linux os
alinux)
    if [ "$VERSION_ID" = "3" ]; then
        yum install -y "${redhat_packages[@]}"
    fi
    ;;
# amzn: amazon linux os
amzn)
    yum install -y "${redhat_packages[@]}"
    ;;
rhel | centos | rocky | alinux)
    if [ "$VERSION_ID" = "7" ]; then
        yum install -y epel-release centos-release-scl scl-utils
        yum install -y "${centos7_packages[@]}"
    elif [ "${VERSION_ID%%.*}" = "8" ]; then
        dnf install -y epel-release
        dnf install -y "${centos8_packages[@]}"
    fi
    ;;
opensuse-leap)
    zypper install -y "${opensuse_packages[@]}"
    ;;
arch | manjaro)
    if [ "$EUID" -eq "0" ]; then
        pacman -Sy --needed --noconfirm "${arch_packages[@]}"
    else
        echo "running without root. Skipping main dependencies (pacman)." 1>&2
    fi
    ;;
darwin)
    if ! which brew; then
        brew install "${brew_packages[@]}"
    fi
    ;;
*)
    echo "Your system ($ID) is not supported by this script. Please install dependencies manually."
    exit 1
    ;;
esac

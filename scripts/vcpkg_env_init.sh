#!/bin/bash
INSTALL_ROOT="$HOME/.local"
INSTALL_ROOT_BIN="$INSTALL_ROOT/bin"
PROFILE_FILE="$HOME/.bash_profile"
mkdir -p "$INSTALL_ROOT_BIN"
source "$HOME/.bash_profile"

# AppendIfNoExists {file} {text}
function AppendIfNoExists() {
    (! grep -q "$2" "${1}") && echo "append [ $2 ] into file ${1}" && echo "$2" >>"${1}"
}

function VerLte() {
    [ "$1" = "$(echo -e "$1\n$2" | sort -V | head -n1)" ]
}

gcc_version=$(gcc --version | grep 'gcc' | awk '{print $3}')
if VerLte "$gcc_version" "7.0.0"; then
    # aliyun linux
    if grep "Aliyun Linux" /etc/os-release && ! ls /etc/yum.repos.d/ | grep scl; then
        rpm -ivh https://cbs.centos.org/kojifiles/packages/centos-release-scl-rh/2/3.el7.centos/noarch/centos-release-scl-rh-2-3.el7.centos.noarch.rpm
        rpm -ivh https://cbs.centos.org/kojifiles/packages/centos-release-scl/2/3.el7.centos/noarch/centos-release-scl-2-3.el7.centos.noarch.rpm
    else
        yum install -y centos-release-scl
    fi
    yum install -y devtoolset-7-gcc devtoolset-7-gcc-c++ devtoolset-7-gdb
    yum remove -y gcc gcc-g++ gdb
    AppendIfNoExists "$PROFILE_FILE" "source /opt/rh/devtoolset-7/enable"
fi

# install packages
yum install -y flex bison perl-IPC-Cmd

# git
if ! command -v git || VerLte "$(git --version | awk '{print $3}')" "2.10.0"; then
    pushd "$INSTALL_ROOT"
    # aliyun linux
    if grep "Aliyun Linux" /etc/os-release && ! ls /etc/yum.repos.d/ | grep scl; then
        rpm -ivh https://cbs.centos.org/kojifiles/packages/centos-release-scl-rh/2/3.el7.centos/noarch/centos-release-scl-rh-2-3.el7.centos.noarch.rpm
        rpm -ivh https://cbs.centos.org/kojifiles/packages/centos-release-scl/2/3.el7.centos/noarch/centos-release-scl-2-3.el7.centos.noarch.rpm
    fi
    yum remove -y git
    yum install -y rh-git227-git
    AppendIfNoExists "$PROFILE_FILE" "source /opt/rh/httpd24/enable"
    AppendIfNoExists "$PROFILE_FILE" "source /opt/rh/rh-git227/enable"
    popd
fi

# install vcpkg
if [[ -z "$VCPKG_ROOT" ]]; then
    mkdir -p "$INSTALL_ROOT" && git clone https://github.com/Microsoft/vcpkg.git "$INSTALL_ROOT/vcpkg" && bash "$INSTALL_ROOT/vcpkg/bootstrap-vcpkg.sh"
    AppendIfNoExists "$PROFILE_FILE" "export PATH=$INSTALL_ROOT/vcpkg:\$PATH"
    AppendIfNoExists "$PROFILE_FILE" "export VCPKG_ROOT=$INSTALL_ROOT/vcpkg"
fi

if ! command -v ninja || VerLte "$(ninja --version)" "1.11.0"; then
    pushd "$INSTALL_ROOT_BIN"
    wget https://github.com/ninja-build/ninja/releases/download/v1.12.1/ninja-linux.zip
    unzip ninja-linux.zip
    ln -s ninja ninja-z
    AppendIfNoExists "$PROFILE_FILE" "export PATH=$INSTALL_ROOT_BIN:\$PATH"
    popd
fi

if ! command -v cmake || VerLte "$(cmake --version | grep 'cmake version' | awk '{print $3}')" "3.20.0"; then
    pushd "$INSTALL_ROOT"
    wget --no-check-certificate -O cmake.tar.gz https://github.com/Kitware/CMake/releases/download/v3.29.3/cmake-3.29.3-linux-x86_64.tar.gz
    mkdir -p cmake && tar -xf cmake.tar.gz --strip-components=1 -C cmake
    AppendIfNoExists "$PROFILE_FILE" "export PATH=$INSTALL_ROOT/cmake/bin:\$PATH"
    popd
fi

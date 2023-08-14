#!/bin/bash
set -e
# variables
BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
INSTALL_DIR=$HOME/.local

function usage() {
    echo "FOR YOUR INFORMATION: "
    echo "INSTALL_DIR: ${INSTALL_DIR}"
    echo "CMAKE_TOOLCHAIN_FILE: ${INSTALL_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake"
}

[ -e "$INSTALL_DIR/vcpkg/vcpkg" ] && usage && exit 0
[ -e "$INSTALL_DIR/vcpkg" ] && rm -rf "$INSTALL_DIR/vcpkg"
[ ! -e "$INSTALL_DIR" ] && mkdir -p "$INSTALL_DIR"
sudo bash "$BASE/install_dependencies.sh"
cd "$INSTALL_DIR"
#git clone https://gitee.com/mirrors/vcpkg.git
git clone https://github.com/Microsoft/vcpkg.git
bash "vcpkg/bootstrap-vcpkg.sh"

if [ -e "vcpkg/vcpkg" ]; then
    usage
    exit 0
else
    echo "install vcpkg failed."
    exit 1
fi

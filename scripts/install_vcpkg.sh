#!/bin/bash
set -ex
# variables
BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
INSTALL_DIR=$HOME/.local

[ -e "$INSTALL_DIR/vcpkg/vcpkg" ] && exit 0
[ ! -e "$INSTALL_DIR" ] && mkdir -p "$INSTALL_DIR" && cd "$INSTALL_DIR"
bash "$BASE/install_dependencies.sh"
git clone https://github.com/Microsoft/vcpkg.git
bash "vcpkg/bootstrap-vcpkg.sh"

if [ -e "vcpkg/vcpkg" ]; then
    exit 0
else
    echo "install vcpkg failed."
    exit 1
fi

#!/bin/bash
REPO=$1
VERSION=$2
wget https://codeload.github.com/"${REPO}"/tar.gz/refs/tags/"${VERSION}"
vcpkg hash "${VERSION}"

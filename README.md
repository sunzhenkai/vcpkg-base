# Registries
- [example](https://github.com/northwindtraders/vcpkg-registry)

# Ports
```shell
# generate git-tree
git rev-parse HEAD:ports/<port> # tips: commit first
# generate patch file
git diff > patch # tips: DO NOT COPY CONTENT, COPY FILE DIRECTLY
# generate sh512
wget https://codeload.github.com/{user}/{project}/tar.gz/refs/tags/{version}
vcpkg hash {version}
```

# Usage
## CMake
```
-DCMAKE_TOOLCHAIN_FILE=/{HOME}/.local/vcpkg/scripts/buildsystems/vcpkg.cmake
```

# Insall Vcpkg
```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/sunzhenkai/vcpkg-base/main/scripts/install_vcpkg_pure.sh)"
```
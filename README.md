# Registries
- [example](https://github.com/northwindtraders/vcpkg-registry)

# Ports
```shell
# generate git-tree
git rev-parse HEAD:ports/<port> # tips: commit first
# generate patch file
git diff > patch # tips: DO NOT COPY CONTENT, COPY FILE DIRECTLY
# generate SHA512
wget https://codeload.github.com/{user}/{project}/tar.gz/refs/tags/{version}
vcpkg hash {version}
```
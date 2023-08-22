# Registries
- [example](https://github.com/northwindtraders/vcpkg-registry)

# Ports
```shell
# generate git-tree
git rev-parse HEAD:ports/<port> # tips: commit first
# generate patch file
git diff > patch # tips: DO NOT COPY CONTENT, COPY FILE DIRECTLY
# generate sh512
vcpkg hash <file>
```
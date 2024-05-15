install:
	@bash scripts/install_vcpkg.sh
resolve:
	@bash scripts/install_dependencies.sh
update:
	@vcpkg --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions x-add-version --all --verbose --overwrite-version

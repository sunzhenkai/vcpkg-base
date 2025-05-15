install:
	@bash scripts/install_vcpkg.sh
resolve:
	@bash scripts/install_dependencies.sh
update-version:
	@vcpkg --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions x-add-version --all --verbose --overwrite-version
update:
	@git add .
	@git commit -m 'update' || echo 'no change'
	@vcpkg --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions x-add-version --all --verbose --overwrite-version
	@git add .
	@git commit -m 'update version' || echo 'no version change'
	@git push

build:
	@vcpkg remove $(name) || echo "not installed"
	@vcpkg install $(name) --overlay-ports=./ports
	@#vcpkg install $(name) --debug --overlay-ports=./ports

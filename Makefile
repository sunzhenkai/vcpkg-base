install:
	@bash scripts/install_vcpkg.sh
resolve:
	@bash scripts/install_dependencies.sh
update:
	@bash scripts/update_port.sh $(port)
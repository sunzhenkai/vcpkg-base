vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO sunzhenkai/cpp-common
        REF 0.0.6
        SHA512 f63292f14d422525e9ddab337159dbddb43f89ceca356ee6df99fcf4dbc9afe3fb32d81a2ed1bbd7b9af855024ac080e3ce231798c185f619ae54024ca69d7ab
        HEAD_REF main
)

message(STATUS "source path is ${SOURCE_PATH}, current packages dir is ${CURRENT_PACKAGES_DIR}")

vcpkg_cmake_configure(
        SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup()
vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO sunzhenkai/cpp-common
        REF 0.0.7
        SHA512 d36a6cbbe9613d1f278a4ba2a72ad9fdb3b0af26e53e9a63cf3cc745fd6568828e70b8d748cfcebbab322dc11630d0a6a14670cdec9dd38950d32504fdfd5d17
        HEAD_REF main
)

message(STATUS "source path is ${SOURCE_PATH}, current packages dir is ${CURRENT_PACKAGES_DIR}")

vcpkg_cmake_configure(
        SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup()
vcpkg_fixup_pkgconfig()

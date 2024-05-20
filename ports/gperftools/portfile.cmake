vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_git(
        OUT_SOURCE_PATH SOURCE_PATH
        URL https://github.com/gperftools/gperftools.git
        REF 365060c4213a48adb27f63d5dfad41b3dfbdd62e
        HEAD_REF master
        PATCHES build.patch
)

vcpkg_cmake_configure(
        SOURCE_PATH "${SOURCE_PATH}"
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME profiler_static)
vcpkg_cmake_config_fixup(PACKAGE_NAME tcmalloc_static)
vcpkg_cmake_config_fixup(PACKAGE_NAME tcmalloc_minimal_static)
vcpkg_cmake_config_fixup(PACKAGE_NAME tcmalloc_and_profiler_static)

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()
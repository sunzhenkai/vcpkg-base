vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_git(
        OUT_SOURCE_PATH SOURCE_PATH
        URL https://github.com/oliora/ppconsul.git
        REF 1a889ce54cc10be4186daa48ccf7003588ceaade
        HEAD_REF master
        PATCHES build.patch
)

# Force the use of the vcpkg installed versions
file(REMOVE_RECURSE "${SOURCE_PATH}/ext/json11")
#file(REMOVE_RECURSE "${SOURCE_PATH}/ext/catch")

vcpkg_cmake_configure(
        SOURCE_PATH "${SOURCE_PATH}"
        OPTIONS -DBUILD_STATIC_LIB=ON -DVERSION=0.2.3
)
vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH cmake)


file(INSTALL "${SOURCE_PATH}/LICENSE_1_0.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")


vcpkg_copy_pdbs()

vcpkg_fixup_pkgconfig()
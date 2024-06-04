vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_git(
        OUT_SOURCE_PATH SOURCE_PATH
        URL https://github.com/datastax/cpp-driver.git
        REF "e05897d72fdac08a212ed3136b7790232670e329"
        HEAD_REF master
        PATCHES cmake.patch
)

message(STATUS "source path is ${SOURCE_PATH}, current packages dir is ${CURRENT_PACKAGES_DIR}")

vcpkg_cmake_configure(
        SOURCE_PATH ${SOURCE_PATH}
        OPTIONS
        -DCASS_BUILD_SHARED=OFF
        -DCASS_BUILD_STATIC=ON
        -DCASS_USE_STATIC_LIBS=ON
        -DCASS_USE_STD_ATOMIC=ON
)

vcpkg_install_cmake()
vcpkg_fixup_pkgconfig(SKIP_CHECK)
# copy from ${CONFIG_PATH} to share/${PACKAGE_NAME}
vcpkg_cmake_config_fixup(PACKAGE_NAME "${PORT}" CONFIG_PATH "share/cassandra_static")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
vcpkg_check_linkage(ONLY_STATIC_LIBRARY)
include(vcpkg_common_functions)

vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        URL aerospike/aerospike-client-c
        REF 7.0.3
        HEAD_REF master
)
#REF d2ac108e3cda6cee7a7ee2ac774eecaeeb12b583

message(STATUS "source path is ${SOURCE_PATH}, current packages dir is ${CURRENT_PACKAGES_DIR}")

set(MAKE_OPTS "")
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    list(APPEND MAKE_OPTS "STATIC=1")
else()
    list(APPEND MAKE_OPTS "SHARED=1")
endif()

vcpkg_configure_make(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH .  # 如果项目的 Makefile 不在根目录，可以指定子路径
    OPTIONS ${MAKE_OPTS}
)

vcpkg_install_make()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
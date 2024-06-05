vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_git(
        OUT_SOURCE_PATH SOURCE_PATH
        URL https://github.com/polarismesh/polaris-cpp.git
        REF "ea0f459c8d71b9c64d6eef3626bb93a41efc962a"
        HEAD_REF main
)

message(STATUS "source path is ${SOURCE_PATH}, current packages dir is ${CURRENT_PACKAGES_DIR}")

vcpkg_execute_build_process(
    COMMAND make -j
    WORKING_DIRECTORY ${SOURCE_PATH})

# for debug
#execute_process(COMMAND mkdir -p ${SOURCE_PATH}/build64/lib COMMAND touch ${SOURCE_PATH}/build64/lib/libpolaris_api.a)

# debug
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug)
file(COPY ${SOURCE_PATH}/build64/lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug)
# release
file(COPY ${SOURCE_PATH}/build64/lib DESTINATION ${CURRENT_PACKAGES_DIR})
file(COPY ${SOURCE_PATH}/include DESTINATION ${CURRENT_PACKAGES_DIR})

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

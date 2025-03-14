vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

set(GIT_REF 7.0.3)
set(GIT_URL https://github.com/aerospike/aerospike-client-c.git)

# custome clone git repo
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/${GIT_REF})
file(MAKE_DIRECTORY ${SOURCE_PATH})
if(NOT EXISTS "${SOURCE_PATH}/.git")
        message(STATUS "Cloning")
        vcpkg_execute_required_process(
                COMMAND ${GIT} clone ${GIT_URL} ${SOURCE_PATH}
                WORKING_DIRECTORY ${SOURCE_PATH}
                LOGNAME clone
        )
endif()

message(STATUS "Checkout revision ${GIT_REF}")
vcpkg_execute_required_process(
        COMMAND ${GIT} checkout ${GIT_REF}
        WORKING_DIRECTORY ${SOURCE_PATH}
        LOGNAME checkout
)

message(STATUS "Fetching submodules")
vcpkg_execute_required_process(
        COMMAND ${GIT} submodule update --init
        WORKING_DIRECTORY ${SOURCE_PATH}
        LOGNAME submodule
)

vcpkg_execute_required_process(
        COMMAND bash -c "echo $PATH && echo $LD_LIBRARY_PATH"
        WORKING_DIRECTORY ${SOURCE_PATH}
        LOGNAME verbose)

vcpkg_configure_make(SOURCE_PATH "${SOURCE_PATH}" COPY_SOURCE SKIP_CONFIGURE)
vcpkg_build_make(OPTIONS STATIC=1 SHARED=0 DISABLE_PARALLEL)
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

# set(GIT_REF v${VERSION})
set(GIT_REF v0.0.17)
set(GIT_URL https://github.com/sunzhenkai/kung-fu-panda-protocols.git)

message(STATUS "protocols [version=${GIT_REF}]")
# custome clone git repo
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${GIT_REF})
file(MAKE_DIRECTORY ${SOURCE_PATH})
if(NOT EXISTS "${SOURCE_PATH}/.git")
  message(STATUS "Cloning")
  vcpkg_execute_required_process(
    COMMAND
    ${GIT}
    clone
    ${GIT_URL}
    ${SOURCE_PATH}
    WORKING_DIRECTORY
    ${SOURCE_PATH}
    LOGNAME
    clone)

  message(STATUS "Checkout revision ${GIT_REF}")
  vcpkg_execute_required_process(
    COMMAND
    ${GIT}
    checkout
    ${GIT_REF}
    WORKING_DIRECTORY
    ${SOURCE_PATH}
    LOGNAME
    checkout)

  message(STATUS "Fetching submodules")
  vcpkg_execute_required_process(
    COMMAND
    ${GIT}
    submodule
    update
    --init
    WORKING_DIRECTORY
    ${SOURCE_PATH}
    LOGNAME
    submodule)
endif()

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME "kung-fu-panda-protocols")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

configure_file("${CMAKE_CURRENT_LIST_DIR}/usage"
               "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" COPYONLY)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_git(
  OUT_SOURCE_PATH SOURCE_PATH URL https://github.com/sunzhenkai/cpp-common.git
  REF aa5ce4cfaa3837b36e7b70ca9b16b13f651fb6a4)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME "cppcommon")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(
  INSTALL "${SOURCE_PATH}/LICENSE"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)
configure_file("${CMAKE_CURRENT_LIST_DIR}/usage"
               "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" COPYONLY)

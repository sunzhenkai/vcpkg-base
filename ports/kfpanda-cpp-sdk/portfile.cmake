vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_git(
  OUT_SOURCE_PATH SOURCE_PATH URL
  https://github.com/sunzhenkai/kfpanda-cpp-sdk.git REF
  c87ee05c8b6a5aa0c1fc4bde3848d29687c0f709)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME "kfpanda")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(
  INSTALL "${SOURCE_PATH}/LICENSE"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)
configure_file("${CMAKE_CURRENT_LIST_DIR}/usage"
               "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" COPYONLY)

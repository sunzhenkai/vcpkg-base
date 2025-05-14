vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_git(
  OUT_SOURCE_PATH SOURCE_PATH URL
  https://github.com/sunzhenkai/kfpanda-cpp-sdk.git REF
  58c0a44009cea96f345c2b2faa387933ea32efcb)

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

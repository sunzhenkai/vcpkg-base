vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_git(
  OUT_SOURCE_PATH
  SOURCE_PATH
  URL
  https://github.com/Nordix/hiredis-cluster.git
  REF
  d92edb8ac58d1279f5015715947f7ade61daca72
  PATCHES
  static-library.patch)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}" OPTIONS -DENABLE_SSL=ON
                      -DDOWNLOAD_HIREDIS=OFF -DDISABLE_TESTS=ON)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME "hiredis_cluster")
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(
  INSTALL "${SOURCE_PATH}/COPYING"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)
configure_file("${CMAKE_CURRENT_LIST_DIR}/usage"
               "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" COPYONLY)

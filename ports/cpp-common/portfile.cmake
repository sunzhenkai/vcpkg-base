vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_git(
  OUT_SOURCE_PATH SOURCE_PATH URL https://github.com/sunzhenkai/cpp-common.git
  REF 8efdc62fb3251fe1234a5ec68656e0575417ef92)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS FEATURES objectstorage
                     WITH_OBJECT_STORAGE)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}" OPTIONS ${FEATURE_OPTIONS})
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME "cppcommon")
if(WITH_OBJECT_STORAGE)
  vcpkg_cmake_config_fixup(PACKAGE_NAME "objectstorage")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(
  INSTALL "${SOURCE_PATH}/LICENSE"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)
configure_file("${CMAKE_CURRENT_LIST_DIR}/usage"
               "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" COPYONLY)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_git(
  OUT_SOURCE_PATH
  SOURCE_PATH
  URL
  https://github.com/baidu/babylon.git
  REF
  "571cfb36eaa51eb1b6f1d5b63c515011f979f1bc"
  HEAD_REF
  master)

message(
  STATUS
    "source path is ${SOURCE_PATH}, current packages dir is ${CURRENT_PACKAGES_DIR}"
)

vcpkg_cmake_configure(SOURCE_PATH ${SOURCE_PATH})
vcpkg_install_cmake()
vcpkg_cmake_config_fixup(PACKAGE_NAME "${PORT}" CONFIG_PATH "lib/cmake/babylon")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/babylon/reusable/patch")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage"
     DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(
  INSTALL ${SOURCE_PATH}/LICENSE
  DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT}
  RENAME copyright)

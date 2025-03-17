vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_git(
  OUT_SOURCE_PATH
  SOURCE_PATH
  URL
  https://github.com/sunzhenkai/apollo-client-cpp.git
  REF
  e707348e6b3dd5fe746d6ce7a7bd64ee4739839d
  HEAD_REF
  master)

message(
  STATUS
    "source path is ${SOURCE_PATH}, current packages dir is ${CURRENT_PACKAGES_DIR}"
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_install_cmake()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage"
     DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(
  INSTALL "${SOURCE_PATH}/LICENSE"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)

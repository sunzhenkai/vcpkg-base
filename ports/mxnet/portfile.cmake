vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO apache/mxnet
        REF 1.9.1
        SHA512 7e0ddfce948a108d3c773bfd19c1c145d7cf56bc154e2f4c57f066b188c4f44ce637cdc88503542fd35c2e447fc32070a43169ab4722d4853c0f6fc5619459d7
        HEAD_REF main
)

message(STATUS "source path is ${SOURCE_PATH}, current packages dir is ${CURRENT_PACKAGES_DIR}")

vcpkg_cmake_configure(
        SOURCE_PATH ${SOURCE_PATH}
        OPTIONS
        -DUSE_CUDA=OFF
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup()
vcpkg_fixup_pkgconfig()

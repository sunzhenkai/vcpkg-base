vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO sunzhenkai/cpp-common
        REF 0.0.1
        SHA512 8b6ab9dd1fd84ad2eee54de2e4ef50cacd535f478f35ac279509f24eae9aae8c70b536bf9f96b8af33c1ff9c07151a0e8aa77dde88f07077c24f1bc786aa169b
        HEAD_REF main
)

message(STATUS "source path is ${SOURCE_PATH}, current packages dir is ${CURRENT_PACKAGES_DIR}")

vcpkg_cmake_configure(
        SOURCE_PATH ${SOURCE_PATH}
        OPTIONS
        -DCASS_BUILD_SHARED=OFF 
        -DCASS_BUILD_STATIC=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

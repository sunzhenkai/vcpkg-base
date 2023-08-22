vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO datastax/cpp-driver
        REF 2.17.0
        SHA512 9589a6399f536ab03c27755e646c1195dd911c47c465815c21c15226e809cc4f8691f7c5a74ca0866b9aef377da16532be415015f544a939ea46ecd5644dff18
        HEAD_REF master
        )

message(STATUS "source path of seastar is ${SOURCE_PATH}")
if (VCPKG_TARGET_IS_LINUX)
    message(STATUS "Seastar currently requires the following libraries from the system package manager:\n    libpciaccess\n    xfslibs\n    libgnutls28\n    libsctp\n    systemtap-sdt\n    libtool\n    valgrind \n\nThese can be installed on Ubuntu systems via apt-get install libpciaccess-dev xfslibs-dev libgnutls28-dev libsctp-dev systemtap-sdt-dev libtool valgrind")
endif ()

vcpkg_configure_cmake(
        SOURCE_PATH ${SOURCE_PATH}
        PREFER_NINJA
        OPTIONS 
        -DCASS_BUILD_SHARED=OFF 
        -DCASS_BUILD_STATIC=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

if (VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif ()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
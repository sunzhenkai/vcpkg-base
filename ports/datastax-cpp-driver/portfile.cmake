vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO datastax/cpp-driver
        REF 2.17.0
        SHA512 134a6558ead7bf122eb2c02e1059110784764d6c4a281f4e214ea20857ae4a74e4bcd2375671687cfc350d81823b66ceb20e169c0f5aaa7a8960a1bde38085f6
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
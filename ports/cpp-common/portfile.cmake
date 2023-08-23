vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO sunzhenkai/cpp-common
        REF 0.0.3
        SHA512 fa5075bdca9c2f431e2b44600abb933af33aca9d7ce75164bb05b488eaa0164db4a5034634eff0c6f56b8d28350612de70db899454c9e0a74a206cf8e2e3f560
        HEAD_REF main
)

message(STATUS "source path is ${SOURCE_PATH}, current packages dir is ${CURRENT_PACKAGES_DIR}")

vcpkg_cmake_configure(
        SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

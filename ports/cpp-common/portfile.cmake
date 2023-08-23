vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO sunzhenkai/cpp-common
        REF 0.0.5
        SHA512 b1cdf6d48fc5889ca8652cf9fda7dc7dc3951fa371cd55ed4a3ea390f285d17692fabbb738ee1b9c7647e02a234c7e933f19cc0b78be9e7f35ad3a6d8aa3e139
        HEAD_REF main
)

message(STATUS "source path is ${SOURCE_PATH}, current packages dir is ${CURRENT_PACKAGES_DIR}")

vcpkg_cmake_configure(
        SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup()
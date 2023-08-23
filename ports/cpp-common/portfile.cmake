vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO sunzhenkai/cpp-common
        REF 0.0.4
        SHA512 9910f70987d82ac1c6af15f575678d687f3e7eb33f040eec2cb2df66b413d395deedd2bdab8f3fd2c6b3910118c52b577338ccbf90aed2c2834133e054ff63ce
        HEAD_REF main
)

message(STATUS "source path is ${SOURCE_PATH}, current packages dir is ${CURRENT_PACKAGES_DIR}")

vcpkg_cmake_configure(
        SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup()
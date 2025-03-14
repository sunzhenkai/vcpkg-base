vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_git(
        OUT_SOURCE_PATH SOURCE_PATH
        URL https://github.com/lzeqian/apollo.git
        REF "734ae75cb35043c816aa5ed70c66822886c585fa"
        HEAD_REF master
)

message(STATUS "source path is ${SOURCE_PATH}, current packages dir is ${CURRENT_PACKAGES_DIR}")

vcpkg_cmake_configure(SOURCE_PATH ${SOURCE_PATH})
vcpkg_install_cmake()
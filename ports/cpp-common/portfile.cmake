vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO sunzhenkai/cpp-common
        REF 0.0.2
        SHA512 63925e74bfa31321a8efef689f6f591cec9fe3542c591da53215d8fa0e0f72820a2829250715aeccbdbb1fa4d431059bfd6bd49e487b85bbdac8315ddb9b2b61
        HEAD_REF main
)

message(STATUS "source path is ${SOURCE_PATH}, current packages dir is ${CURRENT_PACKAGES_DIR}")

vcpkg_cmake_configure(
        SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

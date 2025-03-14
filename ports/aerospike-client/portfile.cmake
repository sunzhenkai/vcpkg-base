vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

set(GIT_REF 7.0.3)
set(GIT_URL https://github.com/aerospike/aerospike-client-c.git)

# custome clone git repo
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${GIT_REF})
file(MAKE_DIRECTORY ${SOURCE_PATH})
if(NOT EXISTS "${SOURCE_PATH}/.git")
        message(STATUS "Cloning")
        vcpkg_execute_required_process(
                COMMAND ${GIT} clone ${GIT_URL} ${SOURCE_PATH}
                WORKING_DIRECTORY ${SOURCE_PATH}
                LOGNAME clone
        )

        message(STATUS "Checkout revision ${GIT_REF}")
        vcpkg_execute_required_process(
                COMMAND ${GIT} checkout ${GIT_REF}
                WORKING_DIRECTORY ${SOURCE_PATH}
                LOGNAME checkout
        )

        message(STATUS "Fetching submodules")
        vcpkg_execute_required_process(
                COMMAND ${GIT} submodule update --init
                WORKING_DIRECTORY ${SOURCE_PATH}
                LOGNAME submodule
        )


        # apply patch
        vcpkg_apply_patches(
                SOURCE_PATH ${SOURCE_PATH}
                PATCHES makefile.patch
        )
endif()

message(STATUS "PATH: $ENV{PATH}")
message(STATUS "LIBRARY_PATH: $ENV{LIBRARY_PATH}")
message(STATUS "LD_LIBRARY_PATH: $ENV{LD_LIBRARY_PATH}")
message(STATUS "CPATH: $ENV{CPATH}")
message(STATUS "AR: $ENV{AR}")
message(STATUS "CMAKE_AR: $ENV{CMAKE_AR}")
message(STATUS "CURRENT_PACKAGES_DIR: ${CURRENT_PACKAGES_DIR}")
message(STATUS "INSTALL_PREFIX: ${INSTALL_PREFIX}")
message(STATUS "CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "CURRENT_INSTALLED_DIR: ${CURRENT_INSTALLED_DIR}")

# install prefix fixup: 由于 aerospike client 没有 configure 脚本，所以需要手动设置安装路径 INSTALL_PREFIX
# INSTALL_PREFIX 是代码文件 pkg/install 内定义的
# 这里的 INSTALL_PREFIX 是 {prefix_dir}/{install_dir}
# vcpkg_configure_make 默认会指定 --prefix, 但是这里没有 configure 脚本，添加了 SKIP_CONFIGURE 选项
# 因此这里修复 INSTALL_PREFIX 为 {prefix_dir}/{install_dir}
# 不然这里会报错: https://github.com/microsoft/vcpkg/blob/master/scripts/cmake/vcpkg_build_make.cmake#L177C8-L177C102
# 报错代码： file(RENAME "${CURRENT_PACKAGES_DIR}_tmp${Z_VCPKG_INSTALL_PREFIX}" "${CURRENT_PACKAGES_DIR}") 
string(REGEX REPLACE "([a-zA-Z]):/" "/\\1/" Z_VCPKG_INSTALL_PREFIX "${CURRENT_INSTALLED_DIR}")
set(ENV_INSTALL_PREFIX_ "$ENV{INSTALL_PREFIX}")
set(ENV{INSTALL_PREFIX} "${CURRENT_PACKAGES_DIR}${Z_VCPKG_INSTALL_PREFIX}")

vcpkg_configure_make(SOURCE_PATH "${SOURCE_PATH}" COPY_SOURCE SKIP_CONFIGURE OPTIONS "CURRENT_INSTALLED_DIR=${CURRENT_INSTALLED_DIR}")
vcpkg_build_make()
vcpkg_install_make()
vcpkg_fixup_pkgconfig()

set(ENV{INSTALL_PREFIX} "$ENV_INSTALL_PREFIX_")
message(STATUS "recover ENV{INSTALL_PREFIX}: ${ENV_INSTALL_PREFIX_} - $ENV{INSTALL_PREFIX}")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

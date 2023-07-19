add_custom_target(vcpkg
        COMMAND bash ${CMAKE_CURRENT_LIST_DIR}/scripts/install_vcpkg.sh)
set(VCPKG_BINARY "$ENV{HOME}/.local/vcpkg/vcpkg")
#set(VCPKG_TOOLCHAIN_FILE "$ENV{HOME}/.local/vcpkg/scripts/buildsystems/vcpkg.cmake")
#add_definitions(CMAKE_TOOLCHAIN_FILE ${VCPKG_TOOLCHAIN_FILE})

macro(AddLibrary library)
    set(FLAG_OPT "")
    set(ONE_VALUE_OPT "VERSION")
    set(MUL_VALUE_OPT "")
    cmake_parse_arguments(ARG "${FLAG_OPT}" "${ONE_VALUE_OPT}" "${MUL_VALUE_OPT}" ${ARGN})

    if ("${ARG_VERSION}" STREQUAL "")
        set(VERSION_PARAM "")
    else ()
        set(VERSION_PARAM "-v ${ARG_VERSION}")
    endif ()
    execute_process(COMMAND ${VCPKG_BINARY} install ${library} ${VERSION_PARAM})
endmacro()
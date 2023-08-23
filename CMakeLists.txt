CMAKE_MINIMUM_REQUIRED(VERSION 3.24)
PROJECT(vcpkg-base)
OPTION(BUILD_EXE "add executable target" OFF)

INCLUDE(${CMAKE_CURRENT_LIST_DIR}/cmakes/tools.cmake)
INCLUDE(${CMAKE_CURRENT_LIST_DIR}/cmakes/protobuf.cmake)
INCLUDE(${CMAKE_CURRENT_LIST_DIR}/cmakes/flatbuffers.cmake)

IF (BUILD_EXE)
    # datastax-cpp-driver
    FIND_PACKAGE(PkgConfig REQUIRED)
    pkg_check_modules(cassandra_static REQUIRED IMPORTED_TARGET cassandra_static)
    # cpp-common
    pkg_check_modules(cpp-common REQUIRED IMPORTED_TARGET cpp-common)
    FIND_PACKAGE(cpp-common CONFIG REQUIRED)

    # target
    ADD_EXECUTABLE(main src/main.cpp)
    TARGET_LINK_LIBRARIES(main
            cpp-common::cpp-common
            # PkgConfig::cpp-common
            PkgConfig::cassandra_static
            )
ENDIF ()

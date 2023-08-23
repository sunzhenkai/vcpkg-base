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
    # cppcommon
    pkg_check_modules(cppcommon REQUIRED IMPORTED_TARGET cppcommon)
    FIND_PACKAGE(cppcommon CONFIG REQUIRED)

    # target
    ADD_EXECUTABLE(main src/main.cpp)
    TARGET_LINK_LIBRARIES(main
            cppcommon::cppcommon
            PkgConfig::cassandra_static
            )
ENDIF ()

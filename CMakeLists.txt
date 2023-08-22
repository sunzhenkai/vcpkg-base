CMAKE_MINIMUM_REQUIRED(VERSION 3.24)
PROJECT(vcpkg-base)
OPTION(BUILD_EXE "add executable target" OFF)

INCLUDE(${CMAKE_CURRENT_LIST_DIR}/cmakes/tools.cmake)
INCLUDE(${CMAKE_CURRENT_LIST_DIR}/cmakes/protobuf.cmake)
INCLUDE(${CMAKE_CURRENT_LIST_DIR}/cmakes/flatbuffers.cmake)

IF (BUILD_EXE)
    ADD_EXECUTABLE(main src/main.cpp)
ENDIF ()

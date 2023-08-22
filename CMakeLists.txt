CMAKE_MINIMUM_REQUIRED(VERSION 3.24)
PROJECT(vcpkg-base)

include(${CMAKE_CURRENT_LIST_DIR}/cmakes/tools.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmakes/protobuf.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmakes/flatbuffers.cmake)

add_executable(main src/main.cpp)
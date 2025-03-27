function(GenerateFlatBuffersMessage)
  cmake_parse_arguments(ARG "" "SRCS;BINARIES;OUTPUT" "FILES" ${ARGN})
  if(NOT TARGET flatbuffers::flatc)
    find_package(flatbuffers CONFIG REQUIRED)
    if(NOT TARGET flatbuffers::flatc)
      message(FATAL_ERROR "Target flatbuffers::flatc not found")
    endif()
  endif()
  file(MAKE_DIRECTORY ${ARG_OUTPUT})
  file(GLOB FB_PROTO_FILES ${ARG_FILES})
  get_property(
    FB_EXECUTABLE
    TARGET flatbuffers::flatc
    PROPERTY LOCATION)
  foreach(I ${FB_PROTO_FILES})
    cmake_path(GET I FILENAME I_F_N)
    cmake_path(REMOVE_EXTENSION I_F_N LAST_ONLY)
    execute_process(
      COMMAND ${FB_EXECUTABLE} --cpp --scoped-enums --reflect-names
              --gen-object-api -o ${ARG_OUTPUT} ${I} RESULT_VARIABLE rc)
    if(NOT "${rc}" STREQUAL "0")
      message(
        FATAL_ERROR
          "[GenerateFlatbuffersMessage] generate ${I} cpp code failed. [message=${rc}]"
      )
    else()
      list(APPEND ${ARG_SRCS} "${ARG_OUTPUT}/${I_F_N}_generated.h")
    endif()
    execute_process(COMMAND ${FB_EXECUTABLE} --binary --schema -o ${ARG_OUTPUT}
                            ${I} RESULT_VARIABLE rc)
    if(NOT "${rc}" STREQUAL "0")
      message(
        FATAL_ERROR
          "[GenerateFlatbuffersMessage] generate ${I} binary failed. [message=${rc}]"
      )
    else()
      list(APPEND ${ARG_BINARIES} "${ARG_OUTPUT}/${I_F_N}.bfbs")
    endif()
  endforeach()
  set(${ARG_SRCS}
      ${${ARG_SRCS}}
      PARENT_SCOPE)
  set(${ARG_BINARIES}
      ${${ARG_BINARIES}}
      PARENT_SCOPE)
endfunction(GenerateFlatBuffersMessage)

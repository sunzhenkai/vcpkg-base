macro(FIND_BIN_PROTOC)
  # find protoc
  if(NOT TARGET protobuf::protoc)
    find_package(Protobuf CONFIG REQUIRED)
    if(NOT TARGET protobuf::protoc)
      message(FATAL_ERROR "Target protobuf::protoc not found")
    endif()
  endif()
  get_property(
    PB_EXE
    TARGET protobuf::protoc
    PROPERTY LOCATION)
endmacro(FIND_BIN_PROTOC)

macro(PROCESS_IMPORT)
  string(LENGTH ${ARG_IMPORT} PROTO_PREFIX_LENGTH)
  set(IMPORT_ARGS "-I${ARG_IMPORT}")
  foreach(I IN LISTS ARG_EXTERN_IMPORT)
    set(IMPORT_ARGS "-I${I} ${IMPORT_ARGS}")
  endforeach()
endmacro(PROCESS_IMPORT)

function(generate_protobuf_message)
  cmake_parse_arguments(ARG "" "SRCS;HEADERS;OUTPUT;IMPORT"
                        "FILES;EXTERN_IMPORT" ${ARGN})
  find_bin_protoc()
  process_import()

  file(MAKE_DIRECTORY ${ARG_OUTPUT})
  file(GLOB PROTO_FILES ${ARG_FILES})
  # generate code for every protoc file
  foreach(I ${PROTO_FILES})
    # check prefix (import path should be proto file's prefix)
    string(LENGTH ${I} I_PATH_LENGTH)
    string(SUBSTRING ${I} 0 ${PROTO_PREFIX_LENGTH} I_PREFIX)
    if(NOT I_PREFIX STREQUAL ARG_IMPORT)
      message(FATAL_ERROR "proto file is not under import path. "
                          "[proto=${I_PREFIX}, import_path=${ARG_IMPORT}]")
    endif()
    # get relative path of proto file
    string(SUBSTRING ${I} ${PROTO_PREFIX_LENGTH} ${I_PATH_LENGTH} REV_PATH)
    stringstartswith(${REV_PATH} "/" REV_PATH_SLASH)
    # remove '/' if it's the first char of the relative path
    if(REV_PATH_SLASH)
      set(PROTO_PREFIX_LENGTH_TMP ${PROTO_PREFIX_LENGTH})
      math(EXPR PROTO_PREFIX_LENGTH_TMP "${PROTO_PREFIX_LENGTH_TMP}+1")
      string(SUBSTRING ${I} ${PROTO_PREFIX_LENGTH_TMP} ${I_PATH_LENGTH}
                       REV_PATH)
    endif()
    removeextension(${REV_PATH} REV_PATH)
    # generate code by execute protoc
    execute_process(
      COMMAND bash -c "${PB_EXE} ${IMPORT_ARGS} --cpp_out ${ARG_OUTPUT} ${I}"
      RESULT_VARIABLE rc)
    if(NOT "${rc}" STREQUAL "0")
      message(FATAL_ERROR "generate ${I} cpp code failed. [message=${rc}]")
    else()
      list(APPEND ${ARG_SRCS} "${ARG_OUTPUT}/${REV_PATH}.pb.cc")
      # LIST(APPEND ${ARG_HEADERS} "${ARG_OUTPUT}/${REV_PATH}.pb.h")
    endif()
  endforeach()

  # append header include directories
  list(FIND ARG_HEADERS ${ARG_OUTPUT} HEADER_DIR_EXISTS)
  if(HEADER_DIR_EXISTS EQUAL -1)
    list(APPEND ${ARG_HEADERS} "${ARG_OUTPUT}")
    set(${ARG_HEADERS}
        ${${ARG_HEADERS}}
        PARENT_SCOPE)
  endif()
  # set parent scope variables
  set(${ARG_SRCS}
      ${${ARG_SRCS}}
      PARENT_SCOPE)
endfunction(generate_protobuf_message)

function(generate_protobuf_message_go)
  cmake_parse_arguments(ARG "" "OUTPUT;IMPORT;GO_OPT_MODULE"
                        "FILES;EXTERN_IMPORT" ${ARGN})
  find_bin_protoc()
  process_import()

  # go opt
  if(NOT ${ARG_GO_OPT_MODULE} STREQUAL "")
    set(arg_go_opt "--go_opt=module=${ARG_GO_OPT_MODULE}")
  endif()
  message(STATUS "CKPT ${arg_go_opt}")

  file(MAKE_DIRECTORY ${ARG_OUTPUT})
  file(GLOB PROTO_FILES ${ARG_FILES})
  # generate code for every protoc file
  foreach(I ${PROTO_FILES})
    # check prefix (import path should be proto file's prefix)
    string(LENGTH ${I} I_PATH_LENGTH)
    string(SUBSTRING ${I} 0 ${PROTO_PREFIX_LENGTH} I_PREFIX)
    if(NOT I_PREFIX STREQUAL ARG_IMPORT)
      message(FATAL_ERROR "proto file is not under import path. "
                          "[proto=${I_PREFIX}, import_path=${ARG_IMPORT}]")
    endif()
    # get relative path of proto file
    string(SUBSTRING ${I} ${PROTO_PREFIX_LENGTH} ${I_PATH_LENGTH} REV_PATH)
    stringstartswith(${REV_PATH} "/" REV_PATH_SLASH)
    # remove '/' if it's the first char of the relative path
    if(REV_PATH_SLASH)
      set(PROTO_PREFIX_LENGTH_TMP ${PROTO_PREFIX_LENGTH})
      math(EXPR PROTO_PREFIX_LENGTH_TMP "${PROTO_PREFIX_LENGTH_TMP}+1")
      string(SUBSTRING ${I} ${PROTO_PREFIX_LENGTH_TMP} ${I_PATH_LENGTH}
                       REV_PATH)
    endif()
    removeextension(${REV_PATH} REV_PATH)
    # generate code by execute protoc
    execute_process(
      COMMAND
        bash -c
        "${PB_EXE} ${IMPORT_ARGS} --go_out ${ARG_OUTPUT} ${arg_go_opt} ${I}"
      RESULT_VARIABLE rc)
    if(NOT "${rc}" STREQUAL "0")
      message(FATAL_ERROR "generate ${I} go code failed. [message=${rc}]")
    endif()
  endforeach()
endfunction(generate_protobuf_message_go)

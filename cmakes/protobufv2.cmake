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

macro(prepare_gen_go)
  find_program(GO_EXE go)
  if("${ARG_GO_GEN_VERSION}" STREQUAL "")
    set(GO_GEN_VERSION_ "latest")
  else()
    set(GO_GEN_VERSION_ "${ARG_GO_GEN_VERSION}")
  endif()
  if("${ARG_GO_GEN_GRPC_VERSION}" STREQUAL "")
    set(GO_GEN_GRPC_VERSION_ "latest")
  else()
    set(GO_GEN_GRPC_VERSION_ "${ARG_GO_GEN_GRPC_VERSION}")
  endif()
  # go version
  execute_process(
    COMMAND go version
    OUTPUT_VARIABLE GO_VERSION_OUTPUT
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  message(
    STATUS
      "Versions: GO_VERSION=${GO_VERSION_OUTPUT}, GO_GEN_VERSION=${GO_GEN_VERSION_}, GO_GEN_GRPC_VERSION=${GO_GEN_GRPC_VERSION_}"
  )

  if(GO_EXE)
    message(STATUS "Found Go compiler: ${GO_EXE}")
    # releases page: https://github.com/protocolbuffers/protobuf-go/releases
    execute_process(
      COMMAND ${GO_EXE} install
              "google.golang.org/protobuf/cmd/protoc-gen-go@${GO_GEN_VERSION_}"
      OUTPUT_VARIABLE GO_PLUGIN_PATH
      ERROR_QUIET
      RESULT_VARIABLE EXIT_CODE)
    if(NOT EXIT_CODE EQUAL 0)
      message(FATAL_ERROR "go install protoc-gen-go failed")
    endif()

    if(ARG_GEN_GRPC)
      execute_process(
        COMMAND
          ${GO_EXE} install
          "google.golang.org/grpc/cmd/protoc-gen-go-grpc@${GO_GEN_GRPC_VERSION_}"
        OUTPUT_VARIABLE GO_PLUGIN_PATH
        ERROR_QUIET
        RESULT_VARIABLE EXIT_CODE)
      if(NOT EXIT_CODE EQUAL 0)
        message(FATAL_ERROR "go install protoc-gen-go-grpc failed")
      endif()
    endif()
  else()
    message(FATAL_ERROR "cannot find go executable binary")
  endif()
endmacro()

function(generate_protobuf_message_go)
  cmake_parse_arguments(
    ARG "GEN_GRPC"
    "OUTPUT;IMPORT;GO_OPT_MODULE;GO_GEN_VERSION;GO_GEN_GRPC_VERSION"
    "FILES;EXTERN_IMPORT" ${ARGN})
  find_bin_protoc()
  process_import()
  prepare_gen_go()

  # go opt
  if(NOT ${ARG_GO_OPT_MODULE} STREQUAL "")
    set(arg_go_opt "--go_opt=module=${ARG_GO_OPT_MODULE}")
  endif()
  # grpc opt
  if(ARG_GEN_GRPC)
    set(arg_grpc_opt
        "--go-grpc_out=${ARG_OUTPUT} --go-grpc_opt=module=${ARG_GO_OPT_MODULE}")
  endif()

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
        "${PB_EXE} ${IMPORT_ARGS} --go_out ${ARG_OUTPUT} ${arg_go_opt} ${arg_grpc_opt} ${I}"
      RESULT_VARIABLE rc)
    if(NOT "${rc}" STREQUAL "0")
      message(FATAL_ERROR "generate ${I} go code failed. [message=${rc}]")
    endif()
  endforeach()
endfunction(generate_protobuf_message_go)

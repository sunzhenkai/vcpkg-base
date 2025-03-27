macro(FIND_BIN_PROTOC)
  # find protoc
  if(NOT TARGET protobuf::protoc)
    find_package(Protobuf CONFIG REQUIRED)
    if(NOT TARGET protobuf::protoc)
      message(FATAL_ERROR "Target protobuf::protoc not found")
    endif()
  endif()
  file(MAKE_DIRECTORY ${ARG_OUTPUT})
  file(GLOB PROTO_FILES ${ARG_FILES})
  get_property(
    PB_EXECUTABLE
    TARGET protobuf::protoc
    PROPERTY LOCATION)
endmacro(FIND_BIN_PROTOC)

function(GenerateProtoBufMessage)
  cmake_parse_arguments(ARG "" "SRCS;HEADERS;OUTPUT;IMPORT"
                        "FILES;EXTERN_IMPORT" ${ARGN})
  find_bin_protoc()
  string(LENGTH ${ARG_IMPORT} PROTO_PREFIX_LENGTH)
  set(IMPORT_ARGS "-I${ARG_IMPORT}")
  foreach(I IN LISTS ARG_EXTERN_IMPORT)
    set(IMPORT_ARGS "-I${I} ${IMPORT_ARGS}")
  endforeach()
  foreach(I ${PROTO_FILES})
    string(LENGTH ${I} I_PATH_LENGTH)
    string(SUBSTRING ${I} 0 ${PROTO_PREFIX_LENGTH} I_PREFIX)
    if(NOT I_PREFIX STREQUAL ARG_IMPORT)
      message(
        FATAL_ERROR
          "[GenerateProtoBufMessage] proto file not with import path. "
          "[proto=${I_PREFIX}, import_path=${ARG_IMPORT}]")
    endif()
    string(SUBSTRING ${I} ${PROTO_PREFIX_LENGTH} ${I_PATH_LENGTH} REV_PATH)
    string_starts_with(${REV_PATH} "/" REV_PATH_SLASH)
    if(REV_PATH_SLASH)
      set(PROTO_PREFIX_LENGTH_TMP ${PROTO_PREFIX_LENGTH})
      math(EXPR PROTO_PREFIX_LENGTH_TMP "${PROTO_PREFIX_LENGTH_TMP}+1")
      string(SUBSTRING ${I} ${PROTO_PREFIX_LENGTH_TMP} ${I_PATH_LENGTH}
                       REV_PATH)
    endif()
    remove_extension(${REV_PATH} REV_PATH)
    execute_process(
      COMMAND bash -c
              "${PB_EXECUTABLE} ${IMPORT_ARGS} --cpp_out ${ARG_OUTPUT} ${I}"
      RESULT_VARIABLE rc)
    if(NOT "${rc}" STREQUAL "0")
      message(
        FATAL_ERROR
          "[GenerateProtoBufMessage] generate ${I} cpp code failed. [message=${rc}]"
      )
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
  set(${ARG_SRCS}
      ${${ARG_SRCS}}
      PARENT_SCOPE)
endfunction(GenerateProtoBufMessage)

function(generate_protobuf_message_go)
  cmake_parse_arguments(ARG "" "OUTPUT;IMPORT" "FILES;EXTERN_IMPORT" ${ARGN})
  find_bin_protoc()
  message(status "generate protobuf go code. [files=${arg_files}]")

  string(length ${arg_import} proto_prefix_length)
  set(import_args "-i${arg_import}")
  foreach(i in lists arg_extern_import)
    set(import_args "-i${i} ${import_args}")
  endforeach()
  foreach(i ${proto_files})
    string(length ${i} i_path_length)
    string(substring ${i} 0 ${proto_prefix_length} i_prefix)
    if(not i_prefix strequal arg_import)
      message(
        fatal_error
          "[generateprotobufmessage] proto file not with import path. "
          "[proto=${i_prefix}, import_path=${arg_import}]")
    endif()
    string(substring ${i} ${proto_prefix_length} ${i_path_length} rev_path)
    string_starts_with(${rev_path} "/" rev_path_slash)
    if(rev_path_slash)
      set(proto_prefix_length_tmp ${proto_prefix_length})
      math(expr proto_prefix_length_tmp "${proto_prefix_length_tmp}+1")
      string(substring ${i} ${proto_prefix_length_tmp} ${i_path_length}
                       rev_path)
    endif()
    remove_extension(${rev_path} rev_path)
    message(
      status
        "run command: ${pb_executable} ${import_args} --go_out ${arg_output} ${i}"
    )
    execute_process(
      command bash -c
              "${pb_executable} ${import_args} --go_out ${arg_output} ${i}"
      result_variable rc)
    if(not "${rc}" strequal "0")
      message(
        fatal_error
          "[generateprotobufmessage] generate ${i} go code failed. [message=${rc}]"
      )
    endif()
  endforeach()
endfunction(generate_protobuf_message_go)

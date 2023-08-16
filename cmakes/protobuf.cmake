FUNCTION(GenerateProtoBufMessage)
    CMAKE_PARSE_ARGUMENTS(ARG "" "SRCS;HEADERS;OUTPUT;IMPORT" "FILES" ${ARGN})
    # find protoc
    IF (NOT TARGET protobuf::protoc)
        FIND_PACKAGE(Protobuf CONFIG REQUIRED)
        IF (NOT TARGET protobuf::protoc)
            MESSAGE(FATAL_ERROR "Target protobuf::protoc not found")
        ENDIF ()
    ENDIF ()
    FILE(MAKE_DIRECTORY ${ARG_OUTPUT})
    FILE(GLOB PROTO_FILES ${ARG_FILES})
    GET_PROPERTY(PB_EXECUTABLE TARGET protobuf::protoc PROPERTY LOCATION)

    STRING(LENGTH ${ARG_IMPORT} PROTO_PREFIX_LENGTH)
    FOREACH (I ${PROTO_FILES})
        STRING(LENGTH ${I} I_PATH_LENGTH)
        STRING(SUBSTRING ${I} 0 ${PROTO_PREFIX_LENGTH} I_PREFIX)
        IF (NOT I_PREFIX STREQUAL ARG_IMPORT)
            MESSAGE(FATAL_ERROR "[GenerateProtoBufMessage] proto file not with import path. "
                    "[proto=${I_PREFIX}, import_path=${ARG_IMPORT}]")
        ENDIF ()
        STRING(SUBSTRING ${I} ${PROTO_PREFIX_LENGTH} ${I_PATH_LENGTH} REV_PATH)
        StringStartsWith(${REV_PATH} "/" REV_PATH_SLASH)
        IF (REV_PATH_SLASH)
            SET(PROTO_PREFIX_LENGTH_TMP ${PROTO_PREFIX_LENGTH})
            MATH(EXPR PROTO_PREFIX_LENGTH_TMP "${PROTO_PREFIX_LENGTH_TMP}+1")
            STRING(SUBSTRING ${I} ${PROTO_PREFIX_LENGTH_TMP} ${I_PATH_LENGTH} REV_PATH)
        ENDIF ()
        RemoveExtension(${REV_PATH} REV_PATH)
        EXECUTE_PROCESS(
                COMMAND ${PB_EXECUTABLE}
                -I ${ARG_IMPORT}
                --cpp_out ${ARG_OUTPUT}
                ${I}
                RESULT_VARIABLE rc
        )
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "[GenerateProtoBufMessage] generate ${I} cpp code failed. [message=${rc}]")
        else ()
            LIST(APPEND ${ARG_SRCS} "${ARG_OUTPUT}/${REV_PATH}.pb.cc")
            # LIST(APPEND ${ARG_HEADERS} "${ARG_OUTPUT}/${REV_PATH}.pb.h")
        endif ()
    ENDFOREACH ()

    # append header include directories
    LIST(FIND ARG_HEADERS ${ARG_OUTPUT} HEADER_DIR_EXISTS)
    IF (HEADER_DIR_EXISTS EQUAL -1)
        LIST(APPEND ${ARG_HEADERS} "${ARG_OUTPUT}")
        SET(${ARG_HEADERS} ${${ARG_HEADERS}} PARENT_SCOPE)
    ENDIF ()
    SET(${ARG_SRCS} ${${ARG_SRCS}} PARENT_SCOPE)
ENDFUNCTION(GenerateProtoBufMessage)
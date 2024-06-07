FUNCTION(RemoveExtension PT RESULT)
    # cmake version 3.20+ required
    CMAKE_PATH(REMOVE_EXTENSION PT LAST_ONLY)
    SET(${RESULT} ${PT} PARENT_SCOPE)
ENDFUNCTION(RemoveExtension)

FUNCTION(StringStartsWith STR SEARCH RESULT)
    STRING(FIND "${STR}" "${SEARCH}" out)
    IF ("${out}" EQUAL 0)
        SET(${RESULT} TRUE PARENT_SCOPE)
    ELSE ()
        SET(${RESULT} FALSE PARENT_SCOPE)
    ENDIF ()
ENDFUNCTION(StringStartsWith)

FUNCTION(PrintTargetProperties _tgt)
    IF (NOT CMAKE_PROPERTY_LIST)
        EXECUTE_PROCESS(COMMAND cmake --help-property-list OUTPUT_VARIABLE CMAKE_PROPERTY_LIST)

        # Convert command output into a CMake list
        STRING(REGEX REPLACE ";" "\\\\;" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
        STRING(REGEX REPLACE "\n" ";" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
        LIST(REMOVE_DUPLICATES CMAKE_PROPERTY_LIST)
    ENDIF ()

    IF (NOT TARGET ${_tgt})
        MESSAGE(STATUS "[TargetProperties] There is no target named '${_tgt}'")
        RETURN()
    ENDIF ()

    FOREACH (_property ${CMAKE_PROPERTY_LIST})
        STRING(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" property ${_property})

        # Fix https://stackoverflow.com/questions/32197663/how-can-i-remove-the-the-location-property-may-not-be-read-from-target-error-i
        IF (_property STREQUAL "LOCATION" OR _property MATCHES "^LOCATION_" OR _property MATCHES "_LOCATION$")
            CONTINUE()
        ENDIF ()

        GET_PROPERTY(_was_set TARGET ${_tgt} PROPERTY ${_property} SET)
        IF (_was_set)
            GET_TARGET_PROPERTY(_value ${_tgt} ${_property})
            IF (NOT _value STREQUAL "")
                MESSAGE("[TargetProperties] ${_tgt} ${_property} = ${_value}")
            ENDIF ()
        ENDIF ()
    ENDFOREACH ()
ENDFUNCTION(PrintTargetProperties)

MACRO(AddInstall)
    INCLUDE(GNUInstallDirs)
    cmake_parse_arguments(ARG "" "PROJECT;EXPORT_TARGET;INCLUDE_DIR;INCLUDE_INSTALL_DIR" "TARGETS" ${ARGN})
    IF (NOT DEFINED ARG_PROJECT)
        MESSAGE(FATAL_ERROR "[AddInstall] PROJECT must be set")
    ENDIF ()

    IF (NOT DEFINED ARG_INCLUDE_DIR)
        SET(ARG_INCLUDE_DIR include/)
    ENDIF ()
    IF (NOT DEFINED ARG_INCLUDE_INSTALL_DIR)
        SET(ARG_INCLUDE_INSTALL_DIR ${ARG_INCLUDE_DIR})
    ENDIF ()
    IF (NOT DEFINED ARG_EXPORT_TARGET)
        SET(ARG_EXPORT_TARGET ${ARG_PROJECT})
    ENDIF ()
    IF (NOT DEFINED ARG_TARGETS)
        SET(ARG_TARGETS ${ARG_EXPORT_TARGET})
    ENDIF ()
    INSTALL(TARGETS ${ARG_TARGETS}
            EXPORT ${ARG_EXPORT_TARGET}
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    INSTALL(DIRECTORY ${ARG_INCLUDE_DIR} DESTINATION ${ARG_INCLUDE_INSTALL_DIR})
    install(EXPORT ${ARG_EXPORT_TARGET}
            DESTINATION share/${ARG_PROJECT}
            FILE ${ARG_EXPORT_TARGET}Config.cmake
            NAMESPACE ${ARG_PROJECT}::)
ENDMACRO()
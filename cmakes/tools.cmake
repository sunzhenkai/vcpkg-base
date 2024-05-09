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

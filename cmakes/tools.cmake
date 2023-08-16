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
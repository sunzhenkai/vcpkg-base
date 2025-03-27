# internal
function(remove_extension PT RESULT)
  # cmake version 3.20+ required
  cmake_path(REMOVE_EXTENSION PT LAST_ONLY)
  set(${RESULT}
      ${PT}
      PARENT_SCOPE)
endfunction(remove_extension)

function(string_starts_with STR SEARCH RESULT)
  string(FIND "${STR}" "${SEARCH}" out)
  if("${out}" EQUAL 0)
    set(${RESULT}
        TRUE
        PARENT_SCOPE)
  else()
    set(${RESULT}
        FALSE
        PARENT_SCOPE)
  endif()
endfunction(string_starts_with)

# public
function(PrintTargetProperties _tgt)
  if(NOT CMAKE_PROPERTY_LIST)
    execute_process(COMMAND cmake --help-property-list
                    OUTPUT_VARIABLE CMAKE_PROPERTY_LIST)

    # Convert command output into a CMake list
    string(REGEX REPLACE ";" "\\\\;" CMAKE_PROPERTY_LIST
                         "${CMAKE_PROPERTY_LIST}")
    string(REGEX REPLACE "\n" ";" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
    list(REMOVE_DUPLICATES CMAKE_PROPERTY_LIST)
  endif()

  if(NOT TARGET ${_tgt})
    message(STATUS "[TargetProperties] There is no target named '${_tgt}'")
    return()
  endif()

  foreach(_property ${CMAKE_PROPERTY_LIST})
    string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" property ${_property})

    # Fix
    # https://stackoverflow.com/questions/32197663/how-can-i-remove-the-the-location-property-may-not-be-read-from-target-error-i
    if(_property STREQUAL "LOCATION"
       OR _property MATCHES "^LOCATION_"
       OR _property MATCHES "_LOCATION$")
      continue()
    endif()

    get_property(
      _was_set
      TARGET ${_tgt}
      PROPERTY ${_property}
      SET)
    if(_was_set)
      get_target_property(_value ${_tgt} ${_property})
      if(NOT _value STREQUAL "")
        message("[TargetProperties] ${_tgt} ${_property} = ${_value}")
      endif()
    endif()
  endforeach()
endfunction(PrintTargetProperties)

macro(AddInstall)
  include(GNUInstallDirs)
  cmake_parse_arguments(
    ARG "" "PROJECT;EXPORT_TARGET;INCLUDE_DIR;INCLUDE_INSTALL_DIR" "TARGETS"
    ${ARGN})
  if(NOT DEFINED ARG_PROJECT)
    message(FATAL_ERROR "[AddInstall] PROJECT must be set")
  endif()

  if(NOT DEFINED ARG_INCLUDE_DIR)
    set(ARG_INCLUDE_DIR include/)
  endif()
  if(NOT DEFINED ARG_INCLUDE_INSTALL_DIR)
    set(ARG_INCLUDE_INSTALL_DIR ${ARG_INCLUDE_DIR})
  endif()
  if(NOT DEFINED ARG_EXPORT_TARGET)
    set(ARG_EXPORT_TARGET ${ARG_PROJECT})
  endif()
  if(NOT DEFINED ARG_TARGETS)
    set(ARG_TARGETS ${ARG_EXPORT_TARGET})
  endif()
  install(
    TARGETS ${ARG_TARGETS}
    EXPORT ${ARG_EXPORT_TARGET}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
  install(DIRECTORY ${ARG_INCLUDE_DIR} DESTINATION ${ARG_INCLUDE_INSTALL_DIR})
  install(
    EXPORT ${ARG_EXPORT_TARGET}
    DESTINATION share/${ARG_PROJECT}
    FILE ${ARG_EXPORT_TARGET}Config.cmake
    NAMESPACE ${ARG_PROJECT}::)
endmacro()

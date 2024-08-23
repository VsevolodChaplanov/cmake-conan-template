cmake_minimum_required(VERSION 3.14)

macro(default name)
    if(NOT DEFINED "${name}")
        set("${name}" "${ARGN}")
    endif()
endmacro()

default(ROOT ${CMAKE_SOURCE_DIR})

default(FORMAT_COMMAND cmake-format)
default(PATTERNS ${ROOT}/*.cmake ${ROOT}/CMakeLists.txt)

file(GLOB_RECURSE cmake_files ${PATTERNS})

foreach(file ${cmake_files})
    execute_process(
        COMMAND ${FORMAT_COMMAND} -i ${file}
        WORKING_DIRECTORY ${ROOT}
        RESULT_VARIABLE result)
    if(result EQUAL 0)
        message(STATUS "formatted: ${file}")
    else()
        message(WARNING "Failed to format: ${file}, message ${result}")
    endif()
endforeach()

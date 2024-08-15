cmake_minimum_required(VERSION 3.14)

macro(default name)
    if(NOT DEFINED "${name}")
        set("${name}" "${ARGN}")
    endif()
endmacro()

default(FORMAT_ROOT_DIR ${CMAKE_SOURCE_DIR})

default(FORMAT_COMMAND cmake-format)
default(PATTERNS ${FORMAT_ROOT_DIR}/cmake/*.cmake ${FORMAT_ROOT_DIR}/CMakeLists.txt ${FORMAT_ROOT_DIR}/*.cmake
        ${FORMAT_ROOT_DIR}/test/CMakeLists.txt ${FORMAT_ROOT_DIR}/test_package/CMakeLists.txt)

file(GLOB cmake_files ${PATTERNS})

message("cmake files ${cmake_files}")

foreach(file ${cmake_files})
    execute_process(
        COMMAND ${FORMAT_COMMAND} -i ${file}
        WORKING_DIRECTORY ${FORMAT_ROOT_DIR}
        RESULT_VARIABLE result)
    if(result EQUAL 0)
        message(STATUS "formatted: ${file}")
    else()
        message(WARNING "Failed to format: ${file}, message ${result}")
    endif()
endforeach()

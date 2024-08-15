cmake_minimum_required(VERSION 3.12)

find_program(CMAKE_FORMAT NAMES cmake-format cmake-format.exe)

if(CMAKE_FORMAT)
    message(STATUS "cmake-format found, add cmake format target")

    # -D FORMAT_COMMAND=${CMAKE_FORMAT} -D FORMAT_ROOT_DIR=${PROJECT_SOURCE_DIR}
    add_custom_target(
        format_cmake_files
        COMMAND ${CMAKE_COMMAND} -P ${PROJECT_SOURCE_DIR}/cmake/cmake-format.cmake
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        COMMENT "Formatting CMake files"
        VERBATIM)
else()
    message(STATUS "cmake-format not found, skip cmake format target")
endif()

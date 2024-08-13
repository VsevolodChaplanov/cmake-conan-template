cmake_minimum_required(VERSION 3.12)

add_custom_target(
    format_cmake_files
    COMMAND ${CMAKE_COMMAND} -P ${PROJECT_SOURCE_DIR}/cmake/cmake-format-script.cmake ${PROJECT_SOURCE_DIR}
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    COMMENT "Formatting CMake files"
    VERBATIM)

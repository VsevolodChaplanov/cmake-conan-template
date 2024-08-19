cmake_minimum_required(VERSION 3.14)

project(${MAIN_PROJECT_NAME}Examples CXX)

include(../../cmake/project-is-top-level.cmake)
include(../../cmake/folders.cmake)
include(../../cmake/static-analyzers.cmake)

if(PROJECT_IS_TOP_LEVEL)
    find_package(${MAIN_PROJECT_NAME}-core REQUIRED)
endif()

add_custom_target(run-examples)

option(LINT_EXAMPLES "enable linters for examples" OFF)
function(add_example NAME)
    add_executable("${NAME}" "${NAME}.cpp")
    target_link_libraries("${NAME}" PRIVATE ${MAIN_PROJECT_NAME}::core)

    add_custom_target(
        "run_${NAME}"
        COMMAND "${NAME}"
        VERBATIM)
    add_dependencies("run_${NAME}" "${NAME}")
    add_dependencies(run-examples "run_${NAME}")

    if (BUILD_SHARED_LIBS)
        add_custom_command(TARGET ${NAME} POST_BUILD 
            COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:${NAME}> $<TARGET_FILE_DIR:${NAME}>)
    endif()
endfunction()

add_example(empty_example)

add_folders(Example)

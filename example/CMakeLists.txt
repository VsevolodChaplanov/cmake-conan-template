cmake_minimum_required(VERSION 3.14)

project(my_projectExamples CXX)

include(../cmake/project-is-top-level.cmake)
include(../cmake/folders.cmake)
include(../cmake/static-analyzers.cmake)

if(PROJECT_IS_TOP_LEVEL)
    find_package(my_project REQUIRED)
endif()

add_custom_target(run-examples)

option(LINT_EXAMPLES "enable linters for examples" OFF)
function(add_example NAME)
    add_executable("${NAME}" "${NAME}.cpp")
    target_link_libraries("${NAME}" PRIVATE my_project::my_project)
    if(LINT_EXAMPLES)
        target_cppcheck(${NAME} ${WARNINGS_AS_ERRORS} "")
        target_clangtidy(${NAME} ${WARNINGS_AS_ERRORS})
        target_include_what_you_use(${NAME})
    endif()
    add_custom_target(
        "run_${NAME}"
        COMMAND "${NAME}"
        VERBATIM)
    add_dependencies("run_${NAME}" "${NAME}")
    add_dependencies(run-examples "run_${NAME}")
endfunction()

add_example(empty_example)

add_folders(Example)

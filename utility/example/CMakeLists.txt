cmake_minimum_required(VERSION 3.14)

project(${MODULE_FULL_NAME}-examples CXX)

include(../../cmake/project-is-top-level.cmake)
include(../../cmake/folders.cmake)
include(../../cmake/static-analyzers.cmake)

if(PROJECT_IS_TOP_LEVEL)
    find_package(${MAIN_PROJECT_NAME}-${MODULE_NAME} REQUIRED)
endif()

add_custom_target(${PROJECT_NAME}-run-examples)

option(LINT_EXAMPLES "enable linters for examples" OFF)

function(add_example file)
    get_filename_component(NAME ${file} NAME_WE)

    add_executable(${NAME} ${file})
    target_link_libraries(${NAME} PRIVATE ${MAIN_PROJECT_NAME}::${MODULE_NAME})

    add_custom_target(
        ${PROJECT_NAME}-run-${NAME}
        COMMAND ${NAME}
        VERBATIM)
    add_dependencies(${PROJECT_NAME}-run-${NAME} ${NAME})
    add_dependencies(${PROJECT_NAME}-run-examples ${PROJECT_NAME}-run-${NAME})

    if(BUILD_SHARED_LIBS)
        add_custom_command(
            TARGET ${NAME}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:${NAME}> $<TARGET_FILE_DIR:${NAME}>)
    endif()
endfunction()

file(GLOB examples ${PROJECT_SOURCE_DIR}/*.cpp)
foreach(file ${examples})
    add_example(${file})
endforeach()

add_folders(Example)

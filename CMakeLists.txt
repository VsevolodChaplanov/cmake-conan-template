cmake_minimum_required(VERSION 3.28)

include(cmake/prelude.cmake)

set(MAIN_PROJECT_NAME
    "my_project"
    CACHE STRING "main project name")

project(
    ${MAIN_PROJECT_NAME}
    VERSION 0.1.0
    DESCRIPTION "Short description"
    HOMEPAGE_URL "https://example.com/"
    LANGUAGES CXX)

include(cmake/vsenvironment.cmake)
run_vcvarsall()

include(cmake/cpm.cmake)

include(options.cmake)
include(dependencies.cmake)

include(cmake/project-is-top-level.cmake)
include(cmake/variables.cmake)
include(cmake/ccache.cmake)
include(cmake/linker.cmake)
include(cmake/ipo.cmake)
include(cmake/coverage.cmake)

if(${MAIN_PROJECT_NAME}_ENABLE_CCACHE)
    enable_ccache()
endif()

enable_ipo()

add_subdirectory(utility)
add_subdirectory(core)

# ---- Developer mode ----

if(NOT ${MAIN_PROJECT_NAME}_DEVELOPER_MODE)
    return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
    message(AUTHOR_WARNING "Developer mode is intended for developers of ${MAIN_PROJECT_NAME}")
endif()

include(cmake/dev-mode.cmake)

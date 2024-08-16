cmake_minimum_required(VERSION 3.28)

include(cmake/prelude.cmake)

project(
    my_project
    VERSION 0.1.0
    DESCRIPTION "Short description"
    HOMEPAGE_URL "https://example.com/"
    LANGUAGES CXX)

include(cmake/vsenvironment.cmake)
run_vcvarsall()

include(options.cmake)
include(dependencies.cmake)

include(cmake/project-is-top-level.cmake)
include(cmake/variables.cmake)
include(cmake/ccache.cmake)
include(cmake/linker.cmake)
include(cmake/ipo.cmake)

if(my_project_ENABLE_CCACHE)
    my_project_enable_cache()
endif()

my_project_enable_ipo()

add_subdirectory(core)

# ---- Developer mode ----

if(NOT my_project_DEVELOPER_MODE)
    return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
    message(AUTHOR_WARNING "Developer mode is intended for developers of my_project")
endif()

include(cmake/dev-mode.cmake)

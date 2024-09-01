cmake_minimum_required(VERSION 3.28)

include(cmake/prelude.cmake)
include(cmake/common_options.cmake)

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
include(cmake/module-registry.cmake)
include(cmake/variables.cmake)
include(cmake/ccache.cmake)
include(cmake/linker.cmake)
include(cmake/ipo.cmake)
include(cmake/coverage.cmake)

if(${MAIN_PROJECT_NAME}_ENABLE_CCACHE)
    enable_ccache()
endif()

enable_ipo()

register_module(utility)
register_module(core)

# ---- Target to link with all library modules

add_library(${PROJECT_NAME} INTERFACE)
add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
target_link_libraries(${PROJECT_NAME} INTERFACE ${MODULES_REGISTRY})

# ---- Install rules for project interface library

include(cmake/install-rules.cmake)

# ---- Developer mode ----

if(NOT ${MAIN_PROJECT_NAME}_DEVELOPER_MODE)
    return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
    message(AUTHOR_WARNING "Developer mode is intended for developers of ${MAIN_PROJECT_NAME}")
endif()

include(cmake/dev-mode.cmake)

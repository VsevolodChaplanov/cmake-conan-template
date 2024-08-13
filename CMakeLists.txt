cmake_minimum_required(VERSION 3.28)

include(cmake/prelude.cmake)

include(cmake/vsenvironment.cmake)
run_vcvarsall()

project(
    my_project
    VERSION 0.1.0
    DESCRIPTION "Short description"
    HOMEPAGE_URL "https://example.com/"
    LANGUAGES CXX)

include(cmake/project-is-top-level.cmake)
include(cmake/variables.cmake)
include(cmake/ccache.cmake)
include(cmake/cmake-format.cmake)

project_enable_cache()

# ---- Project options target

add_library(${PROJECT_NAME}_options INTERFACE)
target_compile_features(${PROJECT_NAME}_options INTERFACE cxx_std_${CMAKE_CXX_STANDARD})

# ---- Declare library precompiled headers

add_library(${PROJECT_NAME}_PCH INTERFACE)
target_precompile_headers(${PROJECT_NAME}_PCH INTERFACE <string> <vector>)
target_link_libraries(${PROJECT_NAME}_PCH INTERFACE ${PROJECT_NAME}_options)

# ---- Declare library ----

add_library(${PROJECT_NAME})
add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

set_property(TARGET ${PROJECT_NAME} PROPERTY EXPORT_NAME ${PROJECT_NAME})

file(GLOB LIBRARY_INCLUDES ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/*)
file(GLOB LIBRARY_SOURCES ${PROJECT_SOURCE_DIR}/src/*)

target_sources(
    ${PROJECT_NAME}
    PUBLIC FILE_SET HEADERS BASE_DIRS ${PROJECT_SOURCE_DIR} FILES ${LIBRARY_INCLUDES}
    PRIVATE ${LIBRARY_SOURCES})

target_include_directories(${PROJECT_NAME} ${warning_guard} PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
                                                                   $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

find_package(fmt REQUIRED)
target_link_libraries(
    ${PROJECT_NAME}
    PUBLIC fmt::fmt ${PROJECT_NAME}_options
    PRIVATE ${PROJECT_NAME}_PCH)

set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE CXX)

# ---- Install rules ----

if(NOT CMAKE_SKIP_INSTALL_RULES)
    include(cmake/install-rules.cmake)
endif()

# ---- Examples ----

if(PROJECT_IS_TOP_LEVEL)
    option(BUILD_EXAMPLES "Build examples tree." "${my_project_DEVELOPER_MODE}")
    if(BUILD_EXAMPLES)
        add_subdirectory(example)
    endif()
endif()

# ---- Developer mode ----

if(NOT my_project_DEVELOPER_MODE)
    return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
    message(AUTHOR_WARNING "Developer mode is intended for developers of my_project")
endif()

include(cmake/dev-mode.cmake)

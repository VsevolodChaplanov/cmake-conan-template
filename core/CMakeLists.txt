cmake_minimum_required(VERSION 3.15)

include(GenerateExportHeader)

include(../cmake/folders.cmake)
include(../cmake/linker.cmake)
include(../cmake/sanitizers.cmake)
include(../cmake/static-analyzers.cmake)

set(MODULE_NAME core)
set(MODULE_FULL_NAME ${MAIN_PROJECT_NAME}-${MODULE_NAME})

include(cmake/options.cmake)
include(cmake/dependencies.cmake)

project(
    ${MODULE_FULL_NAME}
    VERSION
        ${${MAIN_PROJECT_NAME}_VERSION_MAJOR}.${${MAIN_PROJECT_NAME}_VERSION_MINOR}.${${MAIN_PROJECT_NAME}_VERSION_PATCH}
    LANGUAGES CXX)

# ---- Project options target

add_library(${PROJECT_NAME}_options INTERFACE)
target_compile_features(${PROJECT_NAME}_options INTERFACE cxx_std_${CMAKE_CXX_STANDARD})

# ---- Add sanitizers

target_sanitizers(
    ${PROJECT_NAME}_options
    SANITIZER_ADDRESS
    ${${PROJECT_NAME}_SANITIZER_ADDRESS}
    SANITIZER_LEAK
    ${${PROJECT_NAME}_SANITIZER_LEAK}
    SANITIZER_UNDEFINED_BEHAVIOR
    ${${PROJECT_NAME}_SANITIZER_UNDEFINED_BEHAVIOR}
    SANITIZER_THREAD
    ${${PROJECT_NAME}_SANITIZER_THREAD}
    SANITIZER_MEMORY
    ${${PROJECT_NAME}_SANITIZER_MEMORY})

# ---- Add coverage support

if(${PROJECT_NAME}_ENABLE_COVERAGE)
    target_add_coverage_flags(${PROJECT_NAME}_options INTERFACE)
endif()

# ---- Declare library precompiled headers

add_library(${PROJECT_NAME}_pch INTERFACE)
target_precompile_headers(${PROJECT_NAME}_pch INTERFACE <string> <vector>)
target_link_libraries(${PROJECT_NAME}_pch INTERFACE ${PROJECT_NAME}_options)

# ---- Declare library ----

add_library(${PROJECT_NAME})
add_library(${MAIN_PROJECT_NAME}::${MODULE_NAME} ALIAS ${PROJECT_NAME})

# ---- Generate export header

generate_export_header(${PROJECT_NAME} EXPORT_FILE_NAME
                       ${PROJECT_BINARY_DIR}/include/${MAIN_PROJECT_NAME}/${MODULE_NAME}/exports/exports.hpp)

# ---- Set target export name

set_property(TARGET ${PROJECT_NAME} PROPERTY EXPORT_NAME ${PROJECT_NAME})

# ---- Collect sources

file(GLOB LIBRARY_INCLUDES ${PROJECT_SOURCE_DIR}/include/${MAIN_PROJECT_NAME}/${MODULE_NAME}/*.hpp)
file(GLOB LIBRARY_SOURCES ${PROJECT_SOURCE_DIR}/src/*.cpp)

# ---- Set target sources

target_sources(
    ${PROJECT_NAME}
    PUBLIC FILE_SET HEADERS BASE_DIRS ${PROJECT_SOURCE_DIR}/include FILES ${LIBRARY_INCLUDES}
    PRIVATE ${LIBRARY_SOURCES})

# ---- Set target include dirs

target_include_directories(
    ${PROJECT_NAME} ${warning_guard}
    PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include> $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>
           $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

# ---- Add libraries

target_link_libraries(
    ${PROJECT_NAME}
    PUBLIC fmt::fmt 
    ${MAIN_PROJECT_NAME}::utility
    ${PROJECT_NAME}_options 
    PRIVATE ${PROJECT_NAME}_pch)

# ---- Configure linker

target_configure_linker(${PROJECT_NAME})

# TODO mb better soultion to don't forget to add sources
set(ALL_SOURCE_FILES ${LIBRARY_INCLUDES} ${LIBRARY_SOURCES})

if(${PROJECT_NAME}_ENABLE_CLANGTIDY_ON_BUILD)
    target_clangtidy(${PROJECT_NAME} "${ALL_SOURCE_FILES}")
endif()
if(${PROJECT_NAME}_ENABLE_CPPCHECK_ON_BUILD)
    target_cppcheck(${PROJECT_NAME} "${ALL_SOURCE_FILES}")
endif()
if(${PROJECT_NAME}_ENABLE_IWYU_ON_BUILD)
    target_include_what_you_use(${PROJECT_NAME} "${ALL_SOURCE_FILES}")
endif()

# ---- Doxygen

if(${MODULE_FULL_NAME}_BUILD_DOCS)
    include(../cmake/docs.cmake)
    wrap_doxygen_add_docs(${MODULE_FULL_NAME} SOURCE_DIRS "${ALL_SOURCE_FILES}"
                          OUTPUT "doxygen")
endif()

# ---- Build examples

if(${PROJECT_NAME}_BUILD_EXAMPLES)
    add_subdirectory(example)
endif()

# ---- Build tests

include(CTest)
if(BUILD_TESTING AND ${PROJECT_NAME}_BUILD_TESTS)
    add_subdirectory(test)
endif()

# ---- Configure install rules

if(NOT CMAKE_SKIP_INSTALL_RULES)
    include(cmake/install-rules.cmake)
endif()

# ---- Project outline

add_folders(${PROJECT_NAME})

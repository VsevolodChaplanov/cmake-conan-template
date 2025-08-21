cmake_minimum_required(VERSION 3.15)

set(PARENT_PROJECT_NAME ${PROJECT_NAME})

project(
    core
    VERSION
        ${${PARENT_PROJECT_NAME}_VERSION_MAJOR}.${${PARENT_PROJECT_NAME}_VERSION_MINOR}.${${PARENT_PROJECT_NAME}_VERSION_PATCH}
    LANGUAGES CXX)

include(cmake/options.cmake)

# ---- Project options target

add_library(${PROJECT_NAME}-options INTERFACE)

# ---- Link with project wide options

target_link_libraries(${PROJECT_NAME}-options INTERFACE $<BUILD_INTERFACE:${PARENT_PROJECT_NAME}-options>)

# ---- Declare library precompiled headers

add_library(${PROJECT_NAME}-pch INTERFACE) # declare library if pch is off prevent install rule error for unknown target
if(${PROJECT_NAME}_ENABLE_PCH)
    target_precompile_headers(${PROJECT_NAME}-pch INTERFACE <string> <vector>)
    target_link_libraries(${PROJECT_NAME}-pch INTERFACE $<BUILD_INTERFACE:${PROJECT_NAME}-options>)
endif()

# ---- Declare library ----

if(${PROJECT_NAME}_BUILD_SHARED_LIBS)
    add_library(${PROJECT_NAME} SHARED)
else()
    add_library(${PROJECT_NAME} STATIC)
endif()
add_library(${PARENT_PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# ---- Generate export header

generate_export_header(${PROJECT_NAME} EXPORT_FILE_NAME
                       ${PROJECT_BINARY_DIR}/include/${PARENT_PROJECT_NAME}/${PROJECT_NAME}/exports/exports.hpp)

# ---- Collect sources

file(GLOB LIBRARY_INCLUDES ${PROJECT_SOURCE_DIR}/include/${PARENT_PROJECT_NAME}/${PROJECT_NAME}/*.hpp)
file(GLOB LIBRARY_SOURCES ${PROJECT_SOURCE_DIR}/src/*.cpp)

# ---- Set target sources

# cmake-format: off
target_sources(
    ${PROJECT_NAME}
    PUBLIC FILE_SET ${PROJECT_NAME}_Headers
           TYPE HEADERS
           BASE_DIRS ${PROJECT_SOURCE_DIR}/include
           FILES ${LIBRARY_INCLUDES}
    PUBLIC FILE_SET ${PROJECT_NAME}_GeneratedHeaders
           TYPE HEADERS
           BASE_DIRS ${PROJECT_BINARY_DIR}/include
           FILES ${PROJECT_BINARY_DIR}/include/${PARENT_PROJECT_NAME}/${PROJECT_NAME}/exports/exports.hpp
    PRIVATE ${LIBRARY_SOURCES})
# cmake-format: on

# ---- Set target include dirs

target_include_directories(
    ${PROJECT_NAME} ${warning_guard}
    PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include> $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>
           $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

# ---- Add libraries

target_link_libraries(
    ${PROJECT_NAME}
    PUBLIC fmt::fmt ${PARENT_PROJECT_NAME}::utility
    PRIVATE $<BUILD_INTERFACE:${PROJECT_NAME}-pch> $<BUILD_INTERFACE:${PROJECT_NAME}-options>)

# ---- RPATH patching

target_patch_rpath(${PROJECT_NAME} IF ${PROJECT_NAME}_MODIFY_INSTALL_RPATH)

# ---- Properties

set_target_properties(
    ${PROJECT_NAME}
    PROPERTIES DEBUG_POSTFIX ${${PROJECT_NAME}_DEBUG_POSTFIX}
               VERSION ${PROJECT_VERSION}
               SOVERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR})

# ---- Development export

export(
    TARGETS ${PROJECT_NAME} ${PROJECT_NAME}-pch ${PROJECT_NAME}-options
    NAMESPACE ${PARENT_PROJECT_NAME}::
    FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake)

# ---- Clang-tidy target

if(${PROJECT_NAME}_ENABLE_CLANGTIDY)
    target_clangtidy(TARGET ${PROJECT_NAME} WARNINGS_AS_ERRORS ${${PROJECT_NAME}_WARNINGS_AS_ERRORS})
endif()

# ---- Cppcheck target

if(${PROJECT_NAME}_ENABLE_CPPCHECK)
    target_cppcheck(TARGET ${PROJECT_NAME} WARNINGS_AS_ERRORS ${${PROJECT_NAME}_WARNINGS_AS_ERRORS})
endif()

# ---- IWYU target

if(${PROJECT_NAME}_ENABLE_IWYU)
    target_include_what_you_use(TARGET ${PROJECT_NAME})
endif()

# ---- Add coverage support

if(${PROJECT_NAME}_ENABLE_COVERAGE)
    target_add_coverage_flags(${PROJECT_NAME})
endif()

# ---- Build examples

if(${PROJECT_NAME}_BUILD_EXAMPLES)
    add_subdirectory(example)
endif()

# ---- Build tests

include(CTest)
if(BUILD_TESTING AND ${PROJECT_NAME}_BUILD_TESTING)
    add_subdirectory(test)
endif()

# ---- Configure install rules

if(NOT CMAKE_SKIP_INSTALL_RULES AND NOT ${PROJECT_NAME}_SKIP_INSTALL_RULES)
    # cmake-format: off
    install(
        TARGETS ${PROJECT_NAME}
        EXPORT ${PARENT_PROJECT_NAME}Targets
        RUNTIME COMPONENT Runtime
        LIBRARY COMPONENT Runtime NAMELINK_COMPONENT Development
        ARCHIVE COMPONENT Development
        FILE_SET ${PROJECT_NAME}_Headers COMPONENT Development
        FILE_SET ${PROJECT_NAME}_GeneratedHeaders COMPONENT Development)
    # cmake-format: on
endif()

# ---- Project outline

add_folders(${PROJECT_NAME})

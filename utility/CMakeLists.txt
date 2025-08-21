cmake_minimum_required(VERSION 3.15)

set(PARENT_PROJECT_NAME ${PROJECT_NAME})

project(
    utility
    VERSION
        ${${PARENT_PROJECT_NAME}_VERSION_MAJOR}.${${PARENT_PROJECT_NAME}_VERSION_MINOR}.${${PARENT_PROJECT_NAME}_VERSION_PATCH}
    LANGUAGES CXX)

include(cmake/options.cmake)

# ---- Project options target

add_library(${PROJECT_NAME}-options INTERFACE)

# ---- Link with project wide options

target_link_libraries(${PROJECT_NAME}-options INTERFACE $<BUILD_INTERFACE:${PARENT_PROJECT_NAME}-options>)

# ---- Declare library precompiled headers

# ---- Not needed for a library of type INTERFACE

# ---- Declare library ----

add_library(${PROJECT_NAME} INTERFACE)
add_library(${PARENT_PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# ---- Generate export header

# ---- Not needed for a library of type INTERFACE

# ---- Collect sources

file(GLOB LIBRARY_INCLUDES ${PROJECT_SOURCE_DIR}/include/${PARENT_PROJECT_NAME}/${PROJECT_NAME}/*.hpp)

# ---- Set target sources

target_sources(
    ${PROJECT_NAME}
    PUBLIC FILE_SET
           ${PROJECT_NAME}_Headers
           TYPE
           HEADERS
           BASE_DIRS
           ${PROJECT_SOURCE_DIR}/include
           FILES
           ${LIBRARY_INCLUDES})

# ---- Set target include dirs

target_include_directories(${PROJECT_NAME} ${warning_guard} INTERFACE $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
                                                                      $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

# ---- Add libraries

target_link_libraries(${PROJECT_NAME} INTERFACE $<BUILD_INTERFACE:${PROJECT_NAME}-options>)

# ---- Development export

export(
    TARGETS ${PROJECT_NAME} ${PROJECT_NAME}-options
    NAMESPACE ${PARENT_PROJECT_NAME}::
    FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake)

# ---- Clang-tidy target

if(${PROJECT_NAME}_ENABLE_CLANGTIDY)
    target_clangtidy(${PROJECT_NAME} WARNINGS_AS_ERRORS ${${PROJECT_NAME}_WARNINGS_AS_ERRORS})
endif()

# ---- Cppcheck target

if(${PROJECT_NAME}_ENABLE_CPPCHECK)
    target_cppcheck(${PROJECT_NAME} WARNINGS_AS_ERRORS ${${PROJECT_NAME}_WARNINGS_AS_ERRORS})
endif()

# ---- IWYU target

if(${PROJECT_NAME}_ENABLE_IWYU)
    target_include_what_you_use(${PROJECT_NAME} USE_ON_BUILD)
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
        FILE_SET ${PROJECT_NAME}_Headers COMPONENT Development)
    # cmake-format: on
endif()

# ---- Project outline

add_folders(${PROJECT_NAME})

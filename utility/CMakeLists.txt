cmake_minimum_required(VERSION 3.15)

include(GenerateExportHeader)

include(../cmake/folders.cmake)
include(../cmake/linker.cmake)
include(../cmake/sanitizers.cmake)
include(../cmake/static-analyzers.cmake)
include(../cmake/lint-targets.cmake)

set(MODULE_NAME utility)
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

# ---- Set compile features

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

# ---- Declare library precompiled headers

# ---- Not needed for a library of type INTERFACE

# ---- Declare library ----

add_library(${PROJECT_NAME} INTERFACE)
add_library(${MAIN_PROJECT_NAME}::${MODULE_NAME} ALIAS ${PROJECT_NAME})

# ---- Generate export header

# ---- Not needed for a library of type INTERFACE

# ---- Collect sources

file(GLOB LIBRARY_INCLUDES ${PROJECT_SOURCE_DIR}/include/${MAIN_PROJECT_NAME}/${MODULE_NAME}/*.hpp)

# ---- Set target sources

target_sources(${PROJECT_NAME} PUBLIC FILE_SET HEADERS BASE_DIRS ${PROJECT_SOURCE_DIR}/include FILES
                                      ${LIBRARY_INCLUDES})

# ---- Set target include dirs

target_include_directories(${PROJECT_NAME} ${warning_guard} INTERFACE $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
                                                                      $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

# ---- Add libraries

target_link_libraries(${PROJECT_NAME} INTERFACE ${PROJECT_NAME}_options)

# ---- Configure linker

target_configure_linker(${PROJECT_NAME})

# ---- Collect all sources for static analysis

set(ALL_SOURCE_FILES ${LIBRARY_INCLUDES})

# ---- Clang-tidy target

target_clangtidy(${PROJECT_NAME} "${ALL_SOURCE_FILES}" WARNINGS_AS_ERRORS "${WARNINGS_AS_ERRORS}" USE_ON_BUILD
                 "${PROJECT_NAME}_ENABLE_CLANGTIDY_ON_BUILD")

# ---- Cppcheck target

target_cppcheck(${PROJECT_NAME} "${ALL_SOURCE_FILES}" WARNINGS_AS_ERRORS "${WARNINGS_AS_ERRORS}" USE_ON_BUILD
                "${PROJECT_NAME}_ENABLE_CPPCHECK_ON_BUILD")

# ---- IWYU target

target_include_what_you_use(${PROJECT_NAME} "${ALL_SOURCE_FILES}" USE_ON_BUILD "${PROJECT_NAME}_ENABLE_IWYU_ON_BUILD")

# ---- Clang-format target

target_clang_format(${PROJECT_NAME} "${ALL_SOURCE_FILES}")

# ---- Doxygen

if(${MODULE_FULL_NAME}_BUILD_DOCS)
    include(../cmake/docs.cmake)
    wrap_doxygen_add_docs(${MODULE_FULL_NAME} SOURCE_DIRS "${ALL_SOURCE_FILES}" OUTPUT "doxygen")
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

if(NOT CMAKE_SKIP_INSTALL_RULES AND NOT ${MODULE_FULL_NAME}_SKIP_INSTALL_RULES)
    include(cmake/install-rules.cmake)
endif()

# ---- Project outline

add_folders(${PROJECT_NAME})

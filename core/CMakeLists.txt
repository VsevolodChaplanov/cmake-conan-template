cmake_minimum_required(VERSION 3.15)

include(GenerateExportHeader)

include(../cmake/folders.cmake)
include(../cmake/linker.cmake)
include(../cmake/sanitizers.cmake)
include(../cmake/static-analyzers.cmake)

include(cmake/options.cmake)
include(cmake/dependencies.cmake)

set(MODULE_NAME core)

project(${MODULE_NAME}
        VERSION ${my_project_VERSION_MAJOR}.${my_project_VERSION_MINOR}.${my_project_VERSION_PATCH}
        LANGUAGES CXX)

# ---- Project options target

add_library(${PROJECT_NAME}_options INTERFACE)
target_compile_features(${PROJECT_NAME}_options INTERFACE cxx_std_${CMAKE_CXX_STANDARD})
target_sanitizers(${PROJECT_NAME}_options
        SANITIZER_ADDRESS ${core_SANITIZER_ADDRESS}
        SANITIZER_LEAK ${core_SANITIZER_LEAK}
        SANITIZER_UNDEFINED_BEHAVIOR ${core_SANITIZER_UNDEFINED_BEHAVIOR}
        SANITIZER_THREAD ${core_SANITIZER_THREAD}
        SANITIZER_MEMORY ${core_SANITIZER_MEMORY})

# ---- Declare library precompiled headers

add_library(${PROJECT_NAME}_PCH INTERFACE)
target_precompile_headers(${PROJECT_NAME}_PCH INTERFACE <string> <vector>)
target_link_libraries(${PROJECT_NAME}_PCH INTERFACE ${PROJECT_NAME}_options)

# ---- Declare library ----

add_library(${PROJECT_NAME})
add_library(my_project::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# ---- Generate export header

generate_export_header(${PROJECT_NAME} EXPORT_FILE_NAME ${PROJECT_BINARY_DIR}/include/my_project/${PROJECT_NAME}/exports/exports.hpp)

# ---- Set target export name

set_property(TARGET ${PROJECT_NAME} PROPERTY EXPORT_NAME ${PROJECT_NAME})

# ---- Collect sources

file(GLOB LIBRARY_INCLUDES ${PROJECT_SOURCE_DIR}/include/my_project/${PROJECT_NAME}/*.hpp)
file(GLOB LIBRARY_SOURCES ${PROJECT_SOURCE_DIR}/src/*.cpp)

# ---- Set target sources

target_sources(
    ${PROJECT_NAME}
    PUBLIC FILE_SET HEADERS BASE_DIRS ${PROJECT_SOURCE_DIR}/include FILES ${LIBRARY_INCLUDES}
    PRIVATE ${LIBRARY_SOURCES})

# ---- Set target include dirs

target_include_directories(${PROJECT_NAME} ${warning_guard} PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
                                                                   $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>
                                                                   $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

# ---- Add libraries 

target_link_libraries(
    ${PROJECT_NAME}
    PUBLIC fmt::fmt ${PROJECT_NAME}_options
    PRIVATE ${PROJECT_NAME}_PCH)

target_configure_linker(${PROJECT_NAME})

# TODO mb better soultion to don't forget to add sources
set(ALL_SOURCE_FILES ${LIBRARY_INCLUDES} ${LIBRARY_SOURCES})

target_clangtidy(${PROJECT_NAME} "${ALL_SOURCE_FILES}")
target_cppcheck(${PROJECT_NAME} "${ALL_SOURCE_FILES}")
target_include_what_you_use(${PROJECT_NAME} "${ALL_SOURCE_FILES}")

# ---- Build examples

if(core_BUILD_EXAMPLES)
    add_subdirectory(example)
endif()

# ---- Build tests

include(CTest)
if (BUILD_TESTING AND core_BUILD_TESTS)
    add_subdirectory(test)
endif()

if(NOT CMAKE_SKIP_INSTALL_RULES)
    include(cmake/install-rules.cmake)
endif()

add_folders(${PROJECT_NAME})
cmake_minimum_required(VERSION 3.15)

include(GenerateExportHeader)

include(../cmake/linker.cmake)
include(../cmake/sanitizers.cmake)
include(../cmake/static-analyzers.cmake)
include(../cmake/static-analyzers-targets.cmake)

include(cmake/options.cmake)
include(cmake/dependencies.cmake)

project(my_project-core
        LANGUAGES CXX)

# ---- Project options target

add_library(${PROJECT_NAME}_options INTERFACE)
target_compile_features(${PROJECT_NAME}_options INTERFACE cxx_std_${CMAKE_CXX_STANDARD})

# ---- Declare library precompiled headers

add_library(${PROJECT_NAME}_PCH INTERFACE)
target_precompile_headers(${PROJECT_NAME}_PCH INTERFACE <string> <vector>)
target_link_libraries(${PROJECT_NAME}_PCH INTERFACE ${PROJECT_NAME}_options)

# ---- Declare library ----

add_library(${PROJECT_NAME})
add_library(my_project::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# ---- Generate export header

generate_export_header(${PROJECT_NAME})

# ---- Set target export name

set_property(TARGET ${PROJECT_NAME} PROPERTY EXPORT_NAME ${PROJECT_NAME})

# ---- Collect sources

file(GLOB LIBRARY_INCLUDES ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/*.hpp)
file(GLOB LIBRARY_SOURCES ${PROJECT_SOURCE_DIR}/src/*.cpp)

# ---- Set target sources

target_sources(
    ${PROJECT_NAME}
    PUBLIC FILE_SET HEADERS BASE_DIRS ${PROJECT_SOURCE_DIR}/include FILES ${LIBRARY_INCLUDES}
    PRIVATE ${LIBRARY_SOURCES})

# ---- Set target include dirs

target_include_directories(${PROJECT_NAME} ${warning_guard} PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
                                                                   $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

# ---- Add libraries 

target_link_libraries(
    ${PROJECT_NAME}
    PUBLIC fmt::fmt ${PROJECT_NAME}_options
    PRIVATE ${PROJECT_NAME}_PCH)

target_configure_linker(${PROJECT_NAME})

# ---- Build examples

if(core_BUILD_EXAMPLES)
    add_subdirectory(example)
endif()

# ---- Build tests

include(CTest)
if (BUILD_TESTING AND core_BUILD_TESTS)
    add_subdirectory(test)
endif()
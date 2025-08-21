cmake_minimum_required(VERSION 3.14)

set(PARENT_PROJECT_NAME ${PROJECT_NAME})

project(${PARENT_PROJECT_NAME}-tests LANGUAGES CXX)

include(memory)

# ---- Find testing frameworks

find_package(Catch2 REQUIRED)
include(Catch)

# ---- Collect test files

file(GLOB TEST_SOURCES ${PROJECT_SOURCE_DIR}/src/*.cpp)

# ---- Tests ----

add_executable(${PROJECT_NAME})

target_link_libraries(${PROJECT_NAME} PRIVATE ${PARENT_PROJECT_NAME} Catch2::Catch2WithMain)

target_sources(${PROJECT_NAME} PRIVATE ${TEST_SOURCES})

# ---- Static analyzers for test target

# ---- Discover Catch2 tests

catch_discover_tests(${PROJECT_NAME})

# ---- Add coverage

if(${PROJECT_NAME}_ENABLE_COVERAGE)
    add_coverage_lcov_target(${PROJECT_NAME})
    add_coverage_llvm_target(${PROJECT_NAME})
endif()

# ---- Add valgrind target

option(${PROJECT_NAME}_VALGRIND "Add valgrind run target" ON)
if(${PROJECT_NAME}_VALGRIND)
    valgrind_target(${PROJECT_NAME})
    memcheck_target(${PROJECT_NAME})
endif()

# ---- End-of-file commands ----

add_folders(Test)

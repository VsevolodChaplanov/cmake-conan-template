cmake_minimum_required(VERSION 3.14)

project(${MODULE_FULL_NAME}-tests LANGUAGES CXX)

include(../../cmake/project-is-top-level.cmake)
include(../../cmake/folders.cmake)
include(../../cmake/static-analyzers.cmake)

# ---- Dependencies ----

if(PROJECT_IS_TOP_LEVEL)
    find_package(${MAIN_PROJECT_NAME} REQUIRED)
    enable_testing()
endif()

# ---- Find testing frameworks

find_package(Catch2 REQUIRED)
include(Catch)

# ---- Collect test files

file(GLOB TEST_SOURCES ${PROJECT_SOURCE_DIR}/src/*.cpp)

# ---- Tests ----

add_executable(${PROJECT_NAME})
target_link_libraries(${PROJECT_NAME} PRIVATE ${MAIN_PROJECT_NAME}::${MODULE_NAME} Catch2::Catch2WithMain)
target_sources(${PROJECT_NAME} PRIVATE ${TEST_SOURCES})

option(LINT_TESTS "enable static analyzers for tests" OFF)

if(LINT_TESTS)
    target_cppcheck(${PROJECT_NAME} "${TEST_SOURCES}")
    target_clangtidy(${PROJECT_NAME} "${TEST_SOURCES}")
    target_include_what_you_use(${PROJECT_NAME} "${TEST_SOURCES}")
endif()

# ---- Discover Catch2 tests

catch_discover_tests(${PROJECT_NAME})

# ---- Add coverage

if(${MODULE_FULL_NAME}_ENABLE_COVERAGE)
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

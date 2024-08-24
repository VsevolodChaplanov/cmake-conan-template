cmake_minimum_required(VERSION 3.14)

project(${MODULE_FULL_NAME}-tests LANGUAGES CXX)

include(../../cmake/project-is-top-level.cmake)
include(../../cmake/folders.cmake)
include(../../cmake/static-analyzers.cmake)
include(../../cmake/memory.cmake)

# ---- Dependencies ----

if(PROJECT_IS_TOP_LEVEL)
    find_package(${MAIN_PROJECT_NAME} REQUIRED)
    enable_testing()
endif()

find_package(Catch2 REQUIRED)
include(Catch)

# ---- Tests ----

add_executable(${PROJECT_NAME} ${PROJECT_SOURCE_DIR}/source/${MODULE_NAME}_test.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE ${MAIN_PROJECT_NAME}::${MODULE_NAME} Catch2::Catch2WithMain)

# ---- Static analyzers for test target

option(LINT_TESTS "enable static analyzers for tests" OFF)
if(LINT_TESTS)
    target_cppcheck(${PROJECT_NAME} ${WARNINGS_AS_ERRORS} "")
    target_clangtidy(${PROJECT_NAME} ${WARNINGS_AS_ERRORS})
    target_include_what_you_use(${PROJECT_NAME})
endif()

# ---- Discover Catch2 tests

catch_discover_tests(${PROJECT_NAME})

# ---- Add coverage

if(${MODULE_FULL_NAME}_ENABLE_COVERAGE)
    coverage_target(${PROJECT_NAME})
endif()

# ---- Add valgrind target

option(${PROJECT_NAME}_VALGRIND "Add valgrind run target" ON)
if(${PROJECT_NAME}_VALGRIND)
    valgrind_target(${PROJECT_NAME})
    memcheck_target(${PROJECT_NAME})
endif()

# ---- End-of-file commands ----

add_folders(Test)

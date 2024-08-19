cmake_minimum_required(VERSION 3.14)

project(${MAIN_PROJECT_NAME}-tests LANGUAGES CXX)

include(../../cmake/project-is-top-level.cmake)
include(../../cmake/folders.cmake)
include(../../cmake/static-analyzers.cmake)

# ---- Dependencies ----

if(PROJECT_IS_TOP_LEVEL)
    find_package(${MAIN_PROJECT_NAME} REQUIRED)
    enable_testing()
endif()

find_package(Catch2 REQUIRED)
include(Catch)

# ---- Tests ----

add_executable(${PROJECT_NAME} ${PROJECT_SOURCE_DIR}/source/${MAIN_PROJECT_NAME}_test.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE ${MAIN_PROJECT_NAME}::core Catch2::Catch2WithMain)

option(LINT_TESTS "enable static analyzers for tests" OFF)

if(LINT_TESTS)
    target_cppcheck(${PROJECT_NAME} ${WARNINGS_AS_ERRORS} "")
    target_clangtidy(${PROJECT_NAME} ${WARNINGS_AS_ERRORS})
    target_include_what_you_use(${PROJECT_NAME})
endif()

catch_discover_tests(${PROJECT_NAME})

if(${MODULE_NAME}_ENABLE_COVERAGE)
    coverage_target(${MODULE_NAME})
endif()

# ---- End-of-file commands ----

add_folders(Test)

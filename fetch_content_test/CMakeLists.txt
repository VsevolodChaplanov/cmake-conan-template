cmake_minimum_required(VERSION 3.16)

project(fetch_content_test LANGUAGES CXX)

include(../cmake/common_options.cmake)
include(FetchContent)

set(CMAKE_CXX_STANDARD 20)

FetchContent_Declare(
    fmt
    GIT_REPOSITORY https://github.com/fmtlib/fmt.git
    GIT_TAG 10.2.1
    FIND_PACKAGE_ARGS NAMES fmt)
FetchContent_MakeAvailable(fmt)

FetchContent_Declare(
    Catch2
    GIT_REPOSITORY https://github.com/catchorg/Catch2.git
    GIT_TAG v3.7.0
    FIND_PACKAGE_ARGS)
FetchContent_MakeAvailable(Catch2)
include(Catch)

FetchContent_Declare(
    ${MAIN_PROJECT_NAME}
    GIT_REPOSITORY https://github.com/VsevolodChaplanov/cmake-conan-template.git
    GIT_TAG master
    FIND_PACKAGE_ARGS NAMES ${MAIN_PROJECT_NAME})
FetchContent_MakeAvailable(${MAIN_PROJECT_NAME})

if(TARGET ${MAIN_PROJECT_NAME}::${MAIN_PROJECT_NAME})
    message("sfsdfsd")
endif()

add_executable(${PROJECT_NAME} src/fetch_content_test.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE ${MAIN_PROJECT_NAME}::core Catch2::Catch2WithMain)

enable_testing()
catch_discover_tests(${PROJECT_NAME})

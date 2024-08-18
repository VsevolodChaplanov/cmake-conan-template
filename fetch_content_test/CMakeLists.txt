cmake_minimum_required(VERSION 3.16)

project(my_projectFetchContentTest LANGUAGES CXX)

include(FetchContent)

set(CMAKE_CXX_STANDARD 20)

FetchContent_Declare(
  fmt
  GIT_REPOSITORY https://github.com/fmtlib/fmt.git
  GIT_TAG 10.2.1
  FIND_PACKAGE_ARGS NAMES fmt
)
FetchContent_MakeAvailable(fmt)

FetchContent_Declare(
  Catch2
  GIT_REPOSITORY https://github.com/catchorg/Catch2.git
  GIT_TAG        605a34765aa5d5ecbf476b4598a862ada971b0cc # v3.0.1
  FIND_PACKAGE_ARGS
)
FetchContent_MakeAvailable(Catch2)
include(Catch)

FetchContent_Declare(
  my_project
  GIT_REPOSITORY https://github.com/VsevolodChaplanov/cmake-conan-template.git
  GIT_TAG master
)
FetchContent_MakeAvailable(my_project)

add_executable(${PROJECT_NAME} src/fetch_content_test.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE my_project::core Catch2::Catch2WithMain)

enable_testing()
catch_discover_tests(${PROJECT_NAME})

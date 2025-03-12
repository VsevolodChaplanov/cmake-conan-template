cmake_minimum_required(VERSION 3.15)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project(conan_test_package CXX)

find_package(fmt CONFIG REQUIRED)
find_package(my_project CONFIG REQUIRED)

get_target_property(FMT_INCLUDE_DIRS fmt::fmt INTERFACE_INCLUDE_DIRECTORIES)
message(STATUS "fmt include directories: ${FMT_INCLUDE_DIRS}")

add_executable(${PROJECT_NAME} src/conan_package_test.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE fmt::fmt my_project::my_project)

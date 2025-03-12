cmake_minimum_required(VERSION 3.15)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project(conan_test_package CXX)

find_package(fmt CONFIG REQUIRED)
find_package(my_project CONFIG REQUIRED)

add_executable(${PROJECT_NAME} src/conan_package_test.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE fmt::fmt my_project::my_project)

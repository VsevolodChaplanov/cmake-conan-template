cmake_minimum_required(VERSION 3.15)
project(conan_test_package CXX)

include(../cmake/common-options.cmake)

find_package(my_project CONFIG REQUIRED)

add_executable(${PROJECT_NAME} src/conan_package_test.cpp)
target_link_libraries(${PROJECT_NAME} my_project::my_project)

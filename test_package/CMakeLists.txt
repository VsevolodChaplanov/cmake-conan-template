cmake_minimum_required(VERSION 3.15)
project(my_projectTestPackage CXX)

find_package(my_project CONFIG REQUIRED)

add_executable(${PROJECT_NAME} src/conan_package_test.cpp)
target_link_libraries(${PROJECT_NAME} my_project::my_project)

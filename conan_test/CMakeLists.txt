cmake_minimum_required(VERSION 3.15)
project(conan_test_package CXX)

include(../cmake/common_options.cmake)

find_package(${MAIN_PROJECT_NAME} CONFIG REQUIRED)

add_executable(${PROJECT_NAME} src/conan_package_test.cpp)
target_link_libraries(${PROJECT_NAME} ${MAIN_PROJECT_NAME}::${MAIN_PROJECT_NAME})

cmake_minimum_required(VERSION 3.15)
project(TEMPLATE_PROJECT_NAMETestPackage CXX)

find_package(TEMPLATE_PROJECT_NAME CONFIG REQUIRED)

add_executable(${PROJECT_NAME} src/example.cpp)
target_link_libraries(${PROJECT_NAME} TEMPLATE_PROJECT_NAME::TEMPLATE_PROJECT_NAME)

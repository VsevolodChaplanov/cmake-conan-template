cmake_minimum_required(VERSION 3.15)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project(conan_test_package CXX)

find_package(fmt CONFIG REQUIRED)
find_package(my_project CONFIG REQUIRED COMPONENTS core utility)

# check can be built with only required components

# ---- utility ----
add_executable(${PROJECT_NAME}-utility src/conan_utility_component_test.cpp)
target_link_libraries(${PROJECT_NAME}-utility PRIVATE fmt::fmt my_project::utility)

# ---- core ----
add_executable(${PROJECT_NAME}-core src/conan_package_test.cpp)
target_link_libraries(${PROJECT_NAME}-core PRIVATE fmt::fmt my_project::core)

# ---- all -----
add_executable(${PROJECT_NAME} src/conan_package_test.cpp) # same as for core component
target_link_libraries(${PROJECT_NAME} PRIVATE fmt::fmt my_project::my_project)

cmake_minimum_required(VERSION 3.14)

project(my_projectTests LANGUAGES CXX)

include(../cmake/project-is-top-level.cmake)
include(../cmake/folders.cmake)

# ---- Dependencies ----

if(PROJECT_IS_TOP_LEVEL)
    find_package(my_project REQUIRED)
    enable_testing()
endif()

find_package(Catch2 REQUIRED)
include(Catch)

# ---- Tests ----

add_executable(${PROJECT_NAME} ${PROJECT_SOURCE_DIR}/source/my_project_test.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE my_project::my_project Catch2::Catch2WithMain)

catch_discover_tests(${PROJECT_NAME})

# ---- End-of-file commands ----

add_folders(Test)

cmake_minimum_required(VERSION 3.14)

project(TEMPLATE_PROJECT_NAMETests LANGUAGES CXX)

include(../cmake/project-is-top-level.cmake)
include(../cmake/folders.cmake)

# ---- Dependencies ----

if(PROJECT_IS_TOP_LEVEL)
  find_package(TEMPLATE_PROJECT_NAME REQUIRED)
  enable_testing()
endif()

find_package(Catch2 REQUIRED)
include(Catch)

# ---- Tests ----

add_executable(${PROJECT_NAME} source/ex_test.cpp)
target_link_libraries(
    ${PROJECT_NAME} PRIVATE
    TEMPLATE_PROJECT_NAME::TEMPLATE_PROJECT_NAME
    Catch2::Catch2WithMain
)
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)

catch_discover_tests(${PROJECT_NAME})

# ---- End-of-file commands ----

add_folders(Test)

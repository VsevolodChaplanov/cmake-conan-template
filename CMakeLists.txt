cmake_minimum_required(VERSION 3.28)

include(cmake/prelude.cmake)

project(
    TEMPLATE_PROJECT_NAME
    VERSION 0.1.0
    DESCRIPTION "Short description"
    HOMEPAGE_URL "https://example.com/"
    LANGUAGES NONE
)

include(cmake/project-is-top-level.cmake)
include(cmake/variables.cmake)
include(cmake/vsenvironment.cmake)

run_vcvarsall()

# ---- Declare library ----

add_library(${PROJECT_NAME})
add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

set_property(
    TARGET ${PROJECT_NAME} PROPERTY
    EXPORT_NAME ${PROJECT_NAME}
)

target_include_directories(
  ${PROJECT_NAME} ${warning_guard}
    PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
    $<ISNTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

target_compile_features(${PROJECT_NAME} INTERFACE cxx_std_20)

find_package(fmt REQUIRED)
target_link_libraries(${PROJECT_NAME} INTERFACE fmt::fmt)

# ---- Install rules ----

if(NOT CMAKE_SKIP_INSTALL_RULES)
  include(cmake/install-rules.cmake)
endif()

# ---- Examples ----

if(PROJECT_IS_TOP_LEVEL)
  option(BUILD_EXAMPLES "Build examples tree." "${TEMPLATE_PROJECT_NAME_DEVELOPER_MODE}")
  if(BUILD_EXAMPLES)
    add_subdirectory(example)
  endif()
endif()

# ---- Developer mode ----

if(NOT TEMPLATE_PROJECT_NAME_DEVELOPER_MODE)
  return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
  message(
      AUTHOR_WARNING
      "Developer mode is intended for developers of TEMPLATE_PROJECT_NAME"
  )
endif()

include(cmake/dev-mode.cmake)

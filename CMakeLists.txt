cmake_minimum_required(VERSION 3.28)

if(POLICY CMP0167)
    cmake_policy(SET CMP0167 NEW)
endif()

include(cmake/prelude.cmake)
include(cmake/vsenvironment.cmake)

run_vcvarsall()

include(cmake/cpm.cmake)
include(cmake/conan_provider.cmake)

# cmake-format: off
project(my_project
        VERSION 0.1.0
        DESCRIPTION "Short description"
        HOMEPAGE_URL "https://example.com/"
        LANGUAGES CXX)
# cmake-format: on

include(CTest)
include(GNUInstallDirs)

include(options.cmake)
include(dependencies.cmake)

include(cmake/project-is-top-level.cmake)
include(cmake/module-registry.cmake)
include(cmake/variables.cmake)
include(cmake/ccache.cmake)
include(cmake/linker.cmake)
include(cmake/ipo.cmake)
include(cmake/coverage.cmake)
include(cmake/sanitizers.cmake)


if(${PROJECT_NAME}_ENABLE_CCACHE)
    enable_ccache()
endif()

enable_ipo()

file(RELATIVE_PATH origin_relative ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_INSTALL_BINDIR}
     ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_INSTALL_RPATH $ORIGIN $ORIGIN/${origin_relative})

# ---- Project options

add_library(${PROJECT_NAME}-options INTERFACE)

# ---- Compile options

target_compile_options(${PROJECT_NAME}-options INTERFACE $<$<CXX_COMPILER_ID:MSVC>:/bigobj>)

# ---- Set cxx standard project wide

target_compile_features(${PROJECT_NAME}-options INTERFACE cxx_std_${CMAKE_CXX_STANDARD})

# ---- Project wide sanitizers enable

target_sanitizers(
    ${PROJECT_NAME}-options
    SANITIZER_ADDRESS
    ${${PROJECT_NAME}_SANITIZER_ADDRESS}
    SANITIZER_LEAK
    ${${PROJECT_NAME}_SANITIZER_LEAK}
    SANITIZER_UNDEFINED_BEHAVIOR
    ${${PROJECT_NAME}_SANITIZER_UNDEFINED_BEHAVIOR}
    SANITIZER_THREAD
    ${${PROJECT_NAME}_SANITIZER_THREAD}
    SANITIZER_MEMORY
    ${${PROJECT_NAME}_SANITIZER_MEMORY})

register_module(utility)
register_module(core)

# ---- Target to link with all library modules

add_library(${PROJECT_NAME} INTERFACE)
add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
target_link_libraries(${PROJECT_NAME} INTERFACE ${MODULES_REGISTRY})

# ---- Install rules for project interface library

include(cmake/install-rules.cmake)

# ---- Developer mode ----

if(NOT ${PROJECT_NAME}_DEVELOPER_MODE)
    return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
    message(AUTHOR_WARNING "Developer mode is intended for developers of my_project")
endif()

include(cmake/dev-mode.cmake)

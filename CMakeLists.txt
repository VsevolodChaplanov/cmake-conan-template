cmake_minimum_required(VERSION 3.28)

if(POLICY CMP0167)
    cmake_policy(SET CMP0167 NEW)
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(prelude) # prevent in-source builds

# cmake-format: off
# ---- Enable CPM or conan packagers 
# ---- CPM - cmake based package manager 
# include(cmake/cpm.cmake) 
# ---- Install conan eps with cmake configure command may increase configuration time and not recommended
# include(cmake/conan_provider.cmake)
# cmake-format: on

# conan search for project name and version and bases on this formatting
# cmake-format: off
project(my_project
        VERSION 0.1.0
        DESCRIPTION "Short description"
        HOMEPAGE_URL "https://example.com/"
        LANGUAGES CXX)
# cmake-format: on

include(vsenvironment) # setup msvc environment

run_vcvarsall()

include(CTest)
include(GNUInstallDirs)
include(GenerateExportHeader)

include(options.cmake)
include(dependencies.cmake)

include(variables)
include(ccache)
include(ipo)
include(coverage)
include(utility)
include(folders)
include(static-analyzers)

if(${PROJECT_NAME}_ENABLE_CCACHE)
    enable_ccache()
endif()

enable_ipo()

# ---- Project options

add_library(${PROJECT_NAME}-options INTERFACE)

# ---- Compile options

target_compile_options(${PROJECT_NAME}-options INTERFACE $<$<CXX_COMPILER_ID:MSVC>:/bigobj>)

# ---- Set cxx standard project wide

target_compile_features(${PROJECT_NAME}-options INTERFACE cxx_std_${CMAKE_CXX_STANDARD})

export(
    TARGETS ${PROJECT_NAME}-options
    NAMESPACE ${PROJECT_NAME}::
    FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Options.cmake)

add_subdirectory(utility)
add_subdirectory(core)

# ---- Target to link with all library modules

add_library(${PROJECT_NAME} INTERFACE)
add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
target_link_libraries(${PROJECT_NAME} INTERFACE ${PROJECT_NAME}::utility ${PROJECT_NAME}::core)

install(TARGETS ${PROJECT_NAME} EXPORT ${PROJECT_NAME}Targets)

# ---- Install rules for project interface library

include(install-rules)

# ---- Developer mode ----

if(NOT ${PROJECT_NAME}_DEVELOPER_MODE)
    return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
    message(AUTHOR_WARNING "Developer mode is intended for developers of ${PROJECT_NAME}")
endif()

include(dev-mode)

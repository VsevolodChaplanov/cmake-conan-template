include_guard(GLOBAL)

set(_script_path "${CMAKE_BINARY_DIR}/cmake/conan_provider.cmake")
set(_link "https://github.com/conan-io/cmake-conan/raw/refs/heads/develop2/conan_provider.cmake")
if(NOT EXISTS "${_script_path}")
    message(STATUS "Downloading conan_provider.cmake from https://github.com/conan-io/cmake-conan")
    file(DOWNLOAD ${_link} ${_script_path} SHOW_PROGRESS)
endif()

list(APPEND CMAKE_PROJECT_TOP_LEVEL_INCLUDES ${_script_path})
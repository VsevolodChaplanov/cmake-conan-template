include(cmake/folders.cmake)

option(BUILD_DOCS "Build documentation using Doxygen" OFF)
if(BUILD_DOCS)
    include(cmake/docs.cmake)
endif()

option(ENABLE_COVERAGE "Enable coverage support separate from CTest's" OFF)
if(ENABLE_COVERAGE)
    include(cmake/coverage.cmake)
endif()

include(cmake/lint-targets.cmake)
include(cmake/spell-targets.cmake)
include(cmake/cmake-format-targets.cmake)

add_folders(Project)

include(cmake/folders.cmake)

include(CTest)
if(BUILD_TESTING)
    add_subdirectory(test)
endif()

option(BUILD_MCSS_DOCS "Build documentation using Doxygen and m.css" OFF)
if(BUILD_MCSS_DOCS)
    include(cmake/docs.cmake)
endif()

option(ENABLE_COVERAGE "Enable coverage support separate from CTest's" OFF)
if(ENABLE_COVERAGE)
    include(cmake/coverage.cmake)
endif()

include(cmake/lint-targets.cmake)
include(cmake/spell-targets.cmake)
include(cmake/static_analyzers.cmake)

option(WARNINGS_AS_ERRORS "thread warnings as errors for static analyzers" ON)
option(OVERRIDE_CPPCHECK "override cppcheck options" "")

if(my_project_ENABLE_CPPCHECK)
    my_project_enable_cppcheck(${WARNINGS_AS_ERRORS} ${OVERRIDE_CPPCHECK}) # use default options
endif()

if(my_project_ENABLE_CLANGTIDY)
    my_project_enable_clang_tidy(${PROJECT_NAME} ${WARNINGS_AS_ERRORS})
endif()

add_folders(Project)

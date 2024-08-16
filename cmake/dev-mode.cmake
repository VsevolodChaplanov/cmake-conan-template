include(cmake/folders.cmake)
include(cmake/static_analyzers.cmake)

option(my_project_ENABLE_CPPCHECK "enable cppcheck static analyzer for ${PROJECT_NAME}" OFF)
if(my_project_ENABLE_CPPCHECK)
    target_cppcheck(${PROJECT_NAME} ${WARNINGS_AS_ERRORS} "") # empty string can not be defined as option
endif()

option(my_project_ENABLE_CLANGTIDY "enable clang-tidy static analyzer for ${PROJECT_NAME}" OFF)
if(my_project_ENABLE_CLANGTIDY)
    target_clangtidy(${PROJECT_NAME} ${WARNINGS_AS_ERRORS})
endif()

option(my_project_ENABLE_INCLUDE_WHAT_YOU_USE "enable include what you use for ${PROJECT_NAME}" OFF)
if(my_project_ENABLE_INCLUDE_WHAT_YOU_USE)
    target_include_what_you_use(${PROJECT_NAME})
endif()

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
include(cmake/cmake-format-targets.cmake)

add_folders(Project)

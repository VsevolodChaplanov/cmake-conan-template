include(cmake/docs.cmake)
project_documentation()

include(cmake/spell-targets.cmake)

codespell_target()

if(PROJECT_IS_TOP_LEVEL)
    include(cmake/packaging.cmake)
    include(CPack)
endif()

add_folders(Project)

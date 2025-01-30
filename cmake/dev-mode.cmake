include(cmake/folders.cmake)

if(my_project_BUILD_DOCS)
    include(cmake/docs.cmake)

    wrap_doxygen_add_docs(${PROJECT_NAME})
endif()

include(cmake/lint-targets.cmake)
include(cmake/spell-targets.cmake)

add_folders(Project)

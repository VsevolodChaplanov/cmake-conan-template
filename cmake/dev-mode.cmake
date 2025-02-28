include(cmake/folders.cmake)

if(${PROJECT_NAME}_BUILD_DOCS)
    include(cmake/docs.cmake)

    wrap_doxygen_add_docs(${PROJECT_NAME} OUTPUT docs)
endif()

include(cmake/lint-targets.cmake)
include(cmake/spell-targets.cmake)

if(PROJECT_IS_TOP_LEVEL)
    include(cmake/packaging.cmake)
    include(CPack)
endif()

add_folders(Project)

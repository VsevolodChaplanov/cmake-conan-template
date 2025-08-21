option(${PROJECT_NAME}_BUILD_EXAMPLES "Build examples for core part of project"
       ${${PARENT_PROJECT_NAME}_BUILD_EXAMPLES})
option(${PROJECT_NAME}_BUILD_TESTING "Build tests for core part of project" ${${PARENT_PROJECT_NAME}_BUILD_TESTING})

option(${PROJECT_NAME}_ENABLE_COVERAGE "Enable coverage flags" ${${PARENT_PROJECT_NAME}_ENABLE_COVERAGE})

option(${PROJECT_NAME}_MODIFY_INSTALL_RPATH "Modify install rpath for project ${PROJECT_NAME}"
       ${${PARENT_PROJECT_NAME}_MODIFY_INSTALL_RPATH})

option(${PROJECT_NAME}_ENABLE_CLANGTIDY "Enable clang-tidy during the build" ${${PARENT_PROJECT_NAME}_ENABLE_CLANGTIDY})
option(${PROJECT_NAME}_ENABLE_CPPCHECK "Enable cppcheck during the build" ${${PARENT_PROJECT_NAME}_ENABLE_CPPCHECK})
option(${PROJECT_NAME}_ENABLE_IWYU "Enable include-what-you-use during the build" ${${PARENT_PROJECT_NAME}_ENABLE_IWYU})

option(${PROJECT_NAME}_ENABLE_PCH "Enable precompiled headers for the ${PROJECT_NAME} project"
       ${${PARENT_PROJECT_NAME}_ENABLE_PCH})

option(${PROJECT_NAME}_BUILD_SHARED_LIBS "Select library type for the ${PROJECT_NAME} project"
       ${${PARENT_PROJECT_NAME}_BUILD_SHARED_LIBS})

option(${PROJECT_NAME}_SKIP_INSTALL_RULES "Skip install rules for the ${PROJECT_NAME} project"
       ${${PARENT_PROJECT_NAME}_SKIP_INSTALL_RULES})

set(${PROJECT_NAME}_DEBUG_POSTFIX
    ${${PARENT_PROJECT_NAME}_DEBUG_POSTFIX}
    CACHE STRING "Postfix for debug builds")
mark_as_advanced(${PROJECT_NAME}_DEBUG_POSTFIX)

option(${PROJECT_NAME}_WARNINGS_AS_ERRORS "Treat warnings as errors for static analyzers for ${PROJECT_NAME} project"
       ${${PARENT_PROJECT_NAME}_SKIP_INSTALL_RULES})

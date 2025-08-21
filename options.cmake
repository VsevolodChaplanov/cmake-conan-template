# List project customization options here. ${PROJECT_NAME} depends on current context since this options can be included
# in subprojects as well. All subprojects will have same/similar options as parent project

option(${PROJECT_NAME}_BUILD_SHARED_LIBS "Build shared libraries for ${PROJECT_NAME}" ${BUILD_SHARED_LIBS})
option(${PROJECT_NAME}_BUILD_EXAMPLES "Enable build examples for ${PROJECT_NAME}" OFF)
option(${PROJECT_NAME}_BUILD_TESTING "Enable build tests for ${PROJECT_NAME}" ${BUILD_TESTING})

option(${PROJECT_NAME}_ENABLE_CCACHE "Enable ccache" ON)

option(${PROJECT_NAME}_MODIFY_INSTALL_RPATH "Modify install rpath for all projects" ON)

option(${PROJECT_NAME}_ENABLE_COVERAGE "Enable coverage info on default" OFF)

option(${PROJECT_NAME}_ENABLE_CLANGTIDY "Enable clang-tidy analyzer on default" OFF)
option(${PROJECT_NAME}_ENABLE_CPPCHECK "Enable cppcheck analyzer on default" OFF)
option(${PROJECT_NAME}_ENABLE_IWYU "Enable iwyu analyzer on default" OFF)

option(${PROJECT_NAME}_ENABLE_PCH "Enable precompiled headers for the ${PROJECT_NAME} project" ON)

option(${PROJECT_NAME}_SKIP_INSTALL_RULES "Skip install rules for all projects" OFF)

option(${PROJECT_NAME}_WARNINGS_AS_ERRORS "Treat warnings as errors for static analyzers" OFF)

set(${PROJECT_NAME}_DEBUG_POSTFIX
    d
    CACHE STRING "Postfix for debug builds")
mark_as_advanced(${PROJECT_NAME}_DEBUG_POSTFIX)

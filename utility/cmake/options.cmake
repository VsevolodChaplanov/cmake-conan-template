option(${PROJECT_NAME}_BUILD_EXAMPLES "Build examples for ${PROJECT_NAME} part of project"
       ${${PARENT_PROJECT_NAME}_BUILD_EXAMPLES})
option(${PROJECT_NAME}_BUILD_TESTING "Build tests for ${PROJECT_NAME} part of project"
       ${${PARENT_PROJECT_NAME}_BUILD_TESTING})

option(${PROJECT_NAME}_ENABLE_COVERAGE "Enable coverage flags" ${${PARENT_PROJECT_NAME}_ENABLE_COVERAGE})

option(${PROJECT_NAME}_ENABLE_CLANGTIDY "Enable clang-tidy during the build" ${${PARENT_PROJECT_NAME}_ENABLE_CLANGTIDY})
option(${PROJECT_NAME}_ENABLE_CPPCHECK "Enable cppcheck during the build" ${${PARENT_PROJECT_NAME}_ENABLE_CPPCHECK})
option(${PROJECT_NAME}_ENABLE_IWYU "Enable include-what-you-use during the build" ${${PARENT_PROJECT_NAME}_ENABLE_IWYU})

option(${PROJECT_NAME}_SKIP_INSTALL_RULES "Skip install rules for the ${PROJECT_NAME} project"
       ${${PARENT_PROJECT_NAME}_SKIP_INSTALL_RULES})

option(${PROJECT_NAME}_WARNINGS_AS_ERRORS "Treat warnings as errors for static analyzers for ${PROJECT_NAME} project"
       ${${PARENT_PROJECT_NAME}_SKIP_INSTALL_RULES})

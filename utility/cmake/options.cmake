option(${PROJECT_NAME}_BUILD_EXAMPLES "Build examples for ${PROJECT_NAME} part of project"
       ${my_project_BUILD_EXAMPLES})
option(${PROJECT_NAME}_BUILD_TESTS "Build tests for ${PROJECT_NAME} part of project"
       ${my_project_BUILD_TESTS})

option(${PROJECT_NAME}_ENABLE_COVERAGE "Enable coverage flags" ${my_project_ENABLE_COVERAGE})

option(${PROJECT_NAME}_ENABLE_CLANGTIDY_ON_BUILD "Enable clang-tidy during the build"
       ${my_project_ENABLE_CLANGTIDY_ON_BUILD})
option(${PROJECT_NAME}_ENABLE_CPPCHECK_ON_BUILD "Enable cppcheck during the build"
       ${my_project_ENABLE_CPPCHECK_ON_BUILD})
option(${PROJECT_NAME}_ENABLE_IWYU_ON_BUILD "Enable include-what-you-use during the build"
       ${my_project_ENABLE_IWYU_ON_BUILD})

option(${PROJECT_NAME}_SANITIZER_ADDRESS "Enable SANITIZER_ADDRESS for the ${PROJECT_NAME} project"
       ${my_project_SANITIZER_ADDRESS})
option(${PROJECT_NAME}_SANITIZER_LEAK "Enable SANITIZER_LEAK for the ${PROJECT_NAME} project"
       ${my_project_SANITIZER_LEAK})
option(${PROJECT_NAME}_SANITIZER_UNDEFINED_BEHAVIOR
       "Enable SANITIZER_UNDEFINED_BEHAVIOR for the ${PROJECT_NAME} project"
       ${my_project_SANITIZER_UNDEFINED_BEHAVIOR})
option(${PROJECT_NAME}_SANITIZER_THREAD "Enable SANITIZER_THREAD for the ${PROJECT_NAME} project"
       ${my_project_SANITIZER_THREAD})
option(${PROJECT_NAME}_SANITIZER_MEMORY "Enable SANITIZER_MEMORY for the ${PROJECT_NAME} project"
       ${my_project_SANITIZER_MEMORY})

option(${PROJECT_NAME}_BUILD_DOCS "Enable SANITIZER_MEMORY for the ${PROJECT_NAME} project"
       ${my_project_BUILD_DOCS})

option(${PROJECT_NAME}_SKIP_INSTALL_RULES "Skip install rules for the ${PROJECT_NAME} project"
       ${CMAKE_SKIP_INSTALL_RULES})

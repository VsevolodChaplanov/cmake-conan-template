option(${MODULE_FULL_NAME}_BUILD_EXAMPLES "Build examples for core part of project"
       ${${MAIN_PROJECT_NAME}_DEVELOPER_MODE})
option(${MODULE_FULL_NAME}_BUILD_TESTS "Build tests for core part of project" ${${MAIN_PROJECT_NAME}_DEVELOPER_MODE})

option(${MODULE_FULL_NAME}_ENABLE_COVERAGE "Enable coverage flags" ${${MAIN_PROJECT_NAME}_ENABLE_COVERAGE})

option(${MODULE_FULL_NAME}_ENABLE_CLANGTIDY_ON_BUILD "Enable clang-tidy during the build"
       ${${MAIN_PROJECT_NAME}_ENABLE_CLANGTIDY_ON_BUILD})
option(${MODULE_FULL_NAME}_ENABLE_CPPCHECK_ON_BUILD "Enable cppcheck during the build"
       ${${MAIN_PROJECT_NAME}_ENABLE_CPPCHECK_ON_BUILD})
option(${MODULE_FULL_NAME}_ENABLE_IWYU_ON_BUILD "Enable include-what-you-use during the build"
       ${${MAIN_PROJECT_NAME}_ENABLE_IWYU_ON_BUILD})

option(${MODULE_FULL_NAME}_SANITIZER_ADDRESS "Enable SANITIZER_ADDRESS for the ${MODULE_NAME} project"
       ${${MAIN_PROJECT_NAME}_SANITIZER_ADDRESS})
option(${MODULE_FULL_NAME}_SANITIZER_LEAK "Enable SANITIZER_LEAK for the ${MODULE_NAME} project"
       ${${MAIN_PROJECT_NAME}_SANITIZER_LEAK})
option(${MODULE_FULL_NAME}_SANITIZER_UNDEFINED_BEHAVIOR
       "Enable SANITIZER_UNDEFINED_BEHAVIOR for the ${MODULE_NAME} project"
       ${${MAIN_PROJECT_NAME}_SANITIZER_UNDEFINED_BEHAVIOR})
option(${MODULE_FULL_NAME}_SANITIZER_THREAD "Enable SANITIZER_THREAD for the ${MODULE_NAME} project"
       ${${MAIN_PROJECT_NAME}_SANITIZER_THREAD})
option(${MODULE_FULL_NAME}_SANITIZER_MEMORY "Enable SANITIZER_MEMORY for the ${MODULE_NAME} project"
       ${${MAIN_PROJECT_NAME}_SANITIZER_MEMORY})

option(${MODULE_FULL_NAME}_BUILD_DOCS "Enable SANITIZER_MEMORY for the ${MODULE_NAME} project"
       ${${MAIN_PROJECT_NAME}_BUILD_DOCS})

# List project customization options here. Development options like static analysis and coverage are not included.

option(${MAIN_PROJECT_NAME}_BUILD_EXAMPLES "Enable coverage info on default" ${${MAIN_PROJECT_NAME}_DEVELOPER_MODE})
option(${MAIN_PROJECT_NAME}_BUILD_TESTS "Enable coverage info on default" ${${MAIN_PROJECT_NAME}_DEVELOPER_MODE})

option(${MAIN_PROJECT_NAME}_ENABLE_COVERAGE "Enable coverage info on default" ${${MAIN_PROJECT_NAME}_DEVELOPER_MODE})

option(${MAIN_PROJECT_NAME}_ENABLE_CLANGTIDY_ON_BUILD "Enable clang-tidy analyzer on default"
       ${${MAIN_PROJECT_NAME}_DEVELOPER_MODE})
option(${MAIN_PROJECT_NAME}_ENABLE_CPPCHECK_ON_BUILD "Enable cppcheck analyzer on default"
       ${${MAIN_PROJECT_NAME}_DEVELOPER_MODE})
option(${MAIN_PROJECT_NAME}_ENABLE_IWYU_ON_BUILD "Enable iwyu analyzer on default"
       ${${MAIN_PROJECT_NAME}_DEVELOPER_MODE})

option(${MAIN_PROJECT_NAME}_SANITIZER_ADDRESS "Enable SANITIZER_ADDRESS for the `${MAIN_PROJECT_NAME}` project" OFF)
option(${MAIN_PROJECT_NAME}_SANITIZER_LEAK "Enable SANITIZER_LEAK for the `${MAIN_PROJECT_NAME}` project" OFF)
option(${MAIN_PROJECT_NAME}_SANITIZER_UNDEFINED_BEHAVIOR
       "Enable SANITIZER_UNDEFINED_BEHAVIOR for the `${MAIN_PROJECT_NAME}` project" OFF)
option(${MAIN_PROJECT_NAME}_SANITIZER_THREAD "Enable SANITIZER_THREAD for the `${MAIN_PROJECT_NAME}` project" OFF)
option(${MAIN_PROJECT_NAME}_SANITIZER_MEMORY "Enable cSANITIZER_MEMORY for the `${MAIN_PROJECT_NAME}` project" OFF)

option(${MAIN_PROJECT_NAME}_BUILD_DOCS "Generate docs using Doxygen and doxygen-awesome-css"
       ${${MAIN_PROJECT_NAME}_DEVELOPER_MODE})

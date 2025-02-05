# List project customization options here. ${PROJECT_NAME} depends on current context since this options can be included
# in subprojects as well. All subprojects will have same options as parent project

option(BUILD_SHARED_LIBS "Build shared libraries" OFF)
option(CMAKE_SKIP_INSTALL_RULES "Build shared libraries" OFF)

option(${PROJECT_NAME}_BUILD_SHARED_LIBS "Build shared libraries for ${PROJECT_NAME}" ${BUILD_SHARED_LIBS})
option(${PROJECT_NAME}_BUILD_EXAMPLES "Enable build examples for ${PROJECT_NAME}" OFF)
option(${PROJECT_NAME}_BUILD_TESTING "Enable build tests for ${PROJECT_NAME}" ${BUILD_TESTING})

option(${PROJECT_NAME}_ENABLE_COVERAGE "Enable coverage info on default" OFF)

option(${PROJECT_NAME}_ENABLE_CLANGTIDY "Enable clang-tidy analyzer on default" OFF)
option(${PROJECT_NAME}_ENABLE_CPPCHECK "Enable cppcheck analyzer on default" OFF)
option(${PROJECT_NAME}_ENABLE_IWYU "Enable iwyu analyzer on default" OFF)

option(${PROJECT_NAME}_SANITIZER_ADDRESS "Enable SANITIZER_ADDRESS for the `${PROJECT_NAME}` project" OFF)
option(${PROJECT_NAME}_SANITIZER_LEAK "Enable SANITIZER_LEAK for the `${PROJECT_NAME}` project" OFF)
option(${PROJECT_NAME}_SANITIZER_UNDEFINED_BEHAVIOR
       "Enable SANITIZER_UNDEFINED_BEHAVIOR for the `${PROJECT_NAME}` project" OFF)
option(${PROJECT_NAME}_SANITIZER_THREAD "Enable SANITIZER_THREAD for the `${PROJECT_NAME}` project" OFF)
option(${PROJECT_NAME}_SANITIZER_MEMORY "Enable SANITIZER_MEMORY for the `${PROJECT_NAME}` project" OFF)

option(${PROJECT_NAME}_BUILD_DOCS "Generate docs using Doxygen and doxygen-awesome-css" ON)

option(${PROJECT_NAME}_ENABLE_PCH "Enable precompiled headers for the ${PROJECT_NAME} project" ON)

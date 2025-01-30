# List project customization options here. Development options like static analysis and coverage are not included.

option(my_project_BUILD_EXAMPLES "Enable coverage info on default" OFF)
option(my_project_BUILD_TESTS "Enable coverage info on default" OFF)

option(my_project_ENABLE_COVERAGE "Enable coverage info on default" OFF)

option(my_project_ENABLE_CLANGTIDY_ON_BUILD "Enable clang-tidy analyzer on default" OFF)
option(my_project_ENABLE_CPPCHECK_ON_BUILD "Enable cppcheck analyzer on default" OFF)
option(my_project_ENABLE_IWYU_ON_BUILD "Enable iwyu analyzer on default" OFF)

option(my_project_SANITIZER_ADDRESS "Enable SANITIZER_ADDRESS for the `my_project` project" OFF)
option(my_project_SANITIZER_LEAK "Enable SANITIZER_LEAK for the `my_project` project" OFF)
option(my_project_SANITIZER_UNDEFINED_BEHAVIOR
       "Enable SANITIZER_UNDEFINED_BEHAVIOR for the `my_project` project" OFF)
option(my_project_SANITIZER_THREAD "Enable SANITIZER_THREAD for the `my_project` project" OFF)
option(my_project_SANITIZER_MEMORY "Enable cSANITIZER_MEMORY for the `my_project` project" OFF)

option(my_project_BUILD_DOCS "Generate docs using Doxygen and doxygen-awesome-css" OFF)

option(core_BUILD_EXAMPLES "Build examples for core part of project" ${my_project_DEVELOPER_MODE})
option(core_BUILD_TESTS "Build tests for core part of project" ${my_project_DEVELOPER_MODE})

option(core_ENABLE_CLANGTIDY_ON_BUILD " " ${my_project_ENABLE_CLANGTIDY})
option(core_ENABLE_CPPCHECK_ON_BUILD " " ${my_project_ENABLE_CPPCHECK})
option(core_ENABLE_IWYU_ON_BUILD " " ${my_project_ENABLE_INCLUDE_WHAT_YOU_USE})

option(core_SANITIZER_ADDRESS "Enable SANITIZER_ADDRESS for the `core` project" ${my_project_DEVELOPER_MODE})
option(core_SANITIZER_LEAK "Enable SANITIZER_LEAK for the `core` project" OFF)
option(core_SANITIZER_UNDEFINED_BEHAVIOR "Enable SANITIZER_UNDEFINED_BEHAVIOR for the `core` project" ${my_project_DEVELOPER_MODE})
option(core_SANITIZER_THREAD "Enable SANITIZER_THREAD for the `core` project" OFF)
option(core_SANITIZER_MEMORY "Enable cSANITIZER_MEMORY for the `core` project" OFF)
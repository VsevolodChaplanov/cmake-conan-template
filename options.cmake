# List project customization options here. Development options like static analysis and coverage are not included.

option(${MAIN_PROJECT_NAME}_ENABLE_COVERAGE "Enable coverage info on default" ON)

option(${MAIN_PROJECT_NAME}_ENABLE_CLANGTIDY_ON_BUILD "Enable clang-tidy analyzer on default" OFF)
option(${MAIN_PROJECT_NAME}_ENABLE_CPPCHECK_ON_BUILD "Enable cppcheck analyzer on default" OFF)
option(${MAIN_PROJECT_NAME}_ENABLE_IWYU_ON_BUILD "Enable iwyu analyzer on default" OFF)

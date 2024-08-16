cmake_minimum_required(VERSION 3.14)

macro(default name)
    if(NOT DEFINED "${name}")
        set("${name}" "${ARGN}")
    endif()
endmacro()

default(CLANGTIDY clang-tidy)

default(COMPILE_COMMANDS_DIR ${CMAKE_BINARY_DIR})
default(CLANGTIDY_CONFIG ${CMAKE_SOURCE_DIR}/.clang-tidy)

set(DEFAULT_CLANGTIDY_RUN_CMD
    ${CLANGTIDY}
    --config-file=${CLANGTIDY_CONFIG}
    -extra-arg=-Wno-unknown-warning-option
    -extra-arg=-Wno-ignored-optimization-argument
    -extra-arg=-Wno-unused-command-line-argument
    -p
    ${COMPILE_COMMANDS_DIR})

default(CLANGTIDY_COMMAND ${DEFAULT_CLANGTIDY_RUN_CMD})

default(LINT_FILES "")

execute_process(COMMAND ${CLANGTIDY_COMMAND} ${LINT_FILES} COMMAND_ECHO STDOUT RESULT_VARIABLE result)
if(result EQUAL 0)
    message(STATUS "analysis complete")
else()
    message(WARNING "failed to analyze - result: `${result}`")
endif()

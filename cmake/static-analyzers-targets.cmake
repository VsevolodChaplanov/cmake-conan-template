include(CMakeParseArguments)

macro(add_clang_tidy_target_to target files)
    find_program(CLANGTIDY clang-tidy)

    if(CLANGTIDY)
        message(STATUS "clang-tidy found, add analysis target")

        cmake_parse_arguments(ARGUMENTS "WARNINGS_AS_ERRORS" "" "" ${ARGN})

        get_target_property(TARGET_CXX_STANDARD ${target} CXX_STANDARD)

        # construct the clang-tidy command line
        set(CLANGTIDY_CMD
            ${CLANGTIDY}
            --config-file=${CMAKE_SOURCE_DIR}/.clang-tidy
            -extra-arg=-Wno-unknown-warning-option
            -extra-arg=-Wno-ignored-optimization-argument
            -extra-arg=-Wno-unused-command-line-argument
            -p
            ${CMAKE_BINARY_DIR})
        # set standard
        if(NOT "${TARGET_CXX_STANDARD}" STREQUAL "")
            if(UNIX)
                set(CLANGTIDY_CMD ${CLANGTIDY_CMD} -extra-arg=-std=c++${TARGET_CXX_STANDARD})
            else()
                if(${CMAKE_CXX_CLANG_TIDY_DRIVER_MODE} STREQUAL "cl" AND NOT ${CMAKE_GENERATOR} MATCHES "Ninja")
                    set(CLANGTIDY_CMD ${CLANGTIDY_CMD} -extra-arg=/std:c++${TARGET_CXX_STANDARD})
                else()
                    set(CLANGTIDY_CMD ${CLANGTIDY_CMD} -extra-arg=-std=c++${TARGET_CXX_STANDARD})
                endif()
            endif()
        endif()

        # set warnings as errors
        if(ARGUMENTS_WARNINGS_AS_ERRORS)
            list(APPEND CLANGTIDY_CMD -warnings-as-errors=*)
        endif()

        add_custom_target(
            ${target}-clang-tidy
            COMMAND ${CLANGTIDY_CMD} ${files}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            COMMENT "running ${target}-clang-tidy")
    else()
        message(WARNING "clang-tidy not found, skip add ${target}-clang-tidy analysis target")
    endif()
endmacro()

macro(add_cppcheck_target_to target files)
    find_program(CPPCHECK cppcheck)

    if(CPPCHECK)
        message(STATUS "cppcheck found, add analysis target")
        
        cmake_parse_arguments(ARGUMENTS "WARNINGS_AS_ERRORS" "" "" ${ARGN})

        get_target_property(TARGET_CXX_STANDARD ${target} CXX_STANDARD)

        if(CMAKE_GENERATOR MATCHES ".*Visual Studio.*")
            set(CPPCHECK_TEMPLATE "vs")
        else()
            set(CPPCHECK_TEMPLATE "gcc")
        endif()

        set(SUPPRESS_DIR "*:${CMAKE_CURRENT_BINARY_DIR}/_deps/*.h")
        set(TARGET_CXX_CPPCHECK
            ${CPPCHECK}
            --template=${CPPCHECK_TEMPLATE}
            --enable=style,performance,warning,portability
            --inline-suppr
            # We cannot act on a bug/missing feature of cppcheck
            --suppress=cppcheckError
            --suppress=internalAstError
            # if a file does not have an internalAstError, we get an unmatchedSuppression error
            --suppress=unmatchedSuppression
            # noisy and incorrect sometimes
            --suppress=passedByValue
            # ignores code that cppcheck thinks is invalid C++
            --suppress=syntaxError
            --suppress=preprocessorErrorDirective
            --inconclusive
            --suppress=${SUPPRESS_DIR})

        if(NOT "${TARGET_CXX_STANDARD}" STREQUAL "")
            set(TARGET_CXX_CPPCHECK ${TARGET_CXX_CPPCHECK} --std=c++${TARGET_CXX_STANDARD})
        endif()

        if(ARGUMENTS_WARNINGS_AS_ERRORS)
            list(APPEND TARGET_CXX_CPPCHECK --error-exitcode=2)
        endif()

        add_custom_target(
            ${target}-cppcheck
            COMMAND ${TARGET_CXX_CPPCHECK} ${files}
            COMMENT "running ${files}-cppcheck")
    else()
        message(WARNING "cppcheck not found, skip add ${target}-cppcheck analysis target")
    endif()
endmacro()

macro(add_include_what_you_use_target_to target files)
    find_program(IWYU include-what-you-use)
    find_program(IWYU_TOOL NAMES iwyu_tool.py)
    find_program(IWYU_FIX NAMES fix_includes.py)

    find_package(Python3)

    if(IWYU)
        message(STATUS "include-what-you-use found, add analysis and fix target")

        add_custom_target(
            ${target}-iwyu-tool
            COMMENT "run ${target}-iwyu-tool"
            WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
            COMMAND ${Python3_EXECUTABLE} ${IWYU_TOOL} ${files} -p ${CMAKE_BINARY_DIR} --jobs 8 -- -w -Xiwyu
                    --update_comments -w -Xiwyu --no_fwd_decls > IWYU_TOOL.out)

        add_custom_target(
            ${target}-iwyu-fix
            COMMENT "run ${target}-iwyu-fix"
            DEPENDS run-iwyu-tool
            COMMAND ${Python3_EXECUTABLE} ${IWYU_FIX} < IWYU_TOOL.out)

        add_custom_target(
            ${target}-iwyu
            DEPENDS run-iwyu-fix
            COMMENT "run ${target}-iwyu")
    else()
        message(WARNING "include-what-you-use not found, skip add analysis and fix target")
    endif()

endmacro()

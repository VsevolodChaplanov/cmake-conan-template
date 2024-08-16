option(WARNINGS_AS_ERRORS "thread warnings as errors for static analyzers" OFF)

function(target_cppcheck target WARNINGS_AS_ERRORS CPPCHECK_OPTIONS)
    find_program(CPPCHECK cppcheck)
    if(CPPCHECK)

        if(CMAKE_GENERATOR MATCHES ".*Visual Studio.*")
            set(CPPCHECK_TEMPLATE "vs")
        else()
            set(CPPCHECK_TEMPLATE "gcc")
        endif()

        if("${CPPCHECK_OPTIONS}" STREQUAL "")
            # Enable all warnings that are actionable by the user of this toolset style should enable the other 3, but
            # we'll be explicit just in case
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
        else()
            # if the user provides a CPPCHECK_OPTIONS with a template specified, it will override this template
            set(TARGET_CXX_CPPCHECK ${CPPCHECK} --template=${CPPCHECK_TEMPLATE} ${CPPCHECK_OPTIONS})
        endif()

        if(NOT "${CMAKE_CXX_STANDARD}" STREQUAL "")
            set(TARGET_CXX_CPPCHECK ${TARGET_CXX_CPPCHECK} --std=c++${CMAKE_CXX_STANDARD})
        endif()
        if(${WARNINGS_AS_ERRORS})
            list(APPEND TARGET_CXX_CPPCHECK --error-exitcode=2)
        endif()

        message(STATUS "cppcheck options for target ${target}: ${TARGET_CXX_CPPCHECK}")
        set_target_properties(${target} PROPERTIES CXX_CPPCHECK ${TARGET_CXX_CPPCHECK})
    else()
        message(WARNING "cppcheck requested but executable not found")
    endif()
endfunction()

function(target_clangtidy target WARNINGS_AS_ERRORS)
    find_program(CLANGTIDY clang-tidy)
    if(CLANGTIDY)
        if(NOT CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
            get_target_property(TARGET_PCH ${target} INTERFACE_PRECOMPILE_HEADERS)

            if("${TARGET_PCH}" STREQUAL "TARGET_PCH-NOTFOUND")
                get_target_property(TARGET_PCH ${target} PRECOMPILE_HEADERS)
            endif()

            if(NOT ("${TARGET_PCH}" STREQUAL "TARGET_PCH-NOTFOUND"))
                message(
                    SEND_ERROR
                        "clang-tidy cannot be enabled with non-clang compiler and PCH, clang-tidy fails to handle gcc's PCH file"
                )
            endif()
        endif()

        # construct the clang-tidy command line --config-file=${CMAKE_SOURCE_DIR}/.clang-tidy;-p;${CMAKE_BINARY_DIR}
        set(TARGET_CXX_CLANGTIDY
            ${CLANGTIDY};--config-file=${CMAKE_SOURCE_DIR}/.clang-tidy;-extra-arg=-Wno-unknown-warning-option;-extra-arg=-Wno-ignored-optimization-argument;-extra-arg=-Wno-unused-command-line-argument;-p;${CMAKE_BINARY_DIR}
        )
        # set standard
        if(NOT "${CMAKE_CXX_STANDARD}" STREQUAL "")
            if(UNIX)
                set(TARGET_CXX_CLANGTIDY ${TARGET_CXX_CLANGTIDY} -extra-arg=-std=c++${CMAKE_CXX_STANDARD})
            else()
                if(${CMAKE_CXX_CLANG_TIDY_DRIVER_MODE} STREQUAL "cl" AND NOT ${CMAKE_GENERATOR} MATCHES "Ninja")
                    set(TARGET_CXX_CLANGTIDY ${TARGET_CXX_CLANGTIDY} -extra-arg=/std:c++${CMAKE_CXX_STANDARD})
                else()
                    set(TARGET_CXX_CLANGTIDY ${TARGET_CXX_CLANGTIDY} -extra-arg=-std=c++${CMAKE_CXX_STANDARD})
                endif()
            endif()
        endif()

        # set warnings as errors
        if(${WARNINGS_AS_ERRORS})
            list(APPEND TARGET_CXX_CLANGTIDY -warnings-as-errors=*)
        endif()

        message(STATUS "clang-tidy options for target ${target}: ${TARGET_CXX_CLANGTIDY}")
        set_target_properties(${target} PROPERTIES CXX_CLANG_TIDY "${TARGET_CXX_CLANGTIDY}")
    else()
        message(WARNING "clang-tidy requested but executable not found")
    endif()
endfunction()

function(target_include_what_you_use target)
    find_program(INCLUDE_WHAT_YOU_USE include-what-you-use)
    if(INCLUDE_WHAT_YOU_USE)
        message(STATUS "include-what-you-use found and enabled")
        set(TARGET_IWYU_OPTIONS ${INCLUDE_WHAT_YOU_USE};-Xiwyu;--max_line_length=120)
        set_target_properties(${target} PROPERTIES CXX_INCLUDE_WHAT_YOU_USE ${TARGET_IWYU_OPTIONS})
    else()
        message(WARNING "include-what-you-use requested but executable not found")
    endif()
endfunction()

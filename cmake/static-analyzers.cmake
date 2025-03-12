include(CMakeParseArguments)

function(get_default_cppcheck_options OPTIONS TEMPLATE)
    # Enable all warnings that are actionable by the user of this toolset style should enable the other 3, but we'll be
    # explicit just in case
    set(SUPPRESS_DIR "*:${CMAKE_CURRENT_BINARY_DIR}/_deps/*.h")

    set(OPTIONS
        --template=${TEMPLATE}
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

    set(OPTIONS
        "${OPTIONS}"
        PARENT_SCOPE)
endfunction()

# cmake-format: off
##
# Function: target_cppcheck
# 
# This function sets up and integrates the cppcheck static analysis tool for a specified target in a CMake project.
# It locates the cppcheck executable and configures it with the appropriate options and target properties.
# 
# Signature:
#
#   target_cppcheck(TARGET <target>
#                   WARNINGS_AS_ERRORS <bool>
#                   [OPTIONS] <list>)
#
# Parameters:
# 
# - TARGET: The name of the target to analyze with cppcheck.
# - WARNINGS_AS_ERRORS: Optional flag indicating whether warnings should be treated as errors.
# - OPTIONS: overwrite options to be passed when executing the tool.
# 
# This function relies on the `cmake_parse_arguments` function to parse input arguments and
# `get_target_property` to retrieve target-specific properties such as the CXX standard.
##
# cmake-format: on
function(target_cppcheck)
    find_program(CPPCHECK cppcheck)
    if(CPPCHECK)
        cmake_parse_arguments(ARGUMENTS "" "TARGET;WARNINGS_AS_ERRORS" "OPTIONS" "${ARGV}")

        if(NOT ARGUMENTS_TARGET)
            message(FATAL_ERROR "TARGET is required for `target_cppcheck` function")
        endif()

        get_target_property(TARGET_CXX_STANDARD ${ARGUMENTS_TARGET} CXX_STANDARD)

        if(CMAKE_GENERATOR MATCHES ".*Visual Studio.*")
            set(CPPCHECK_TEMPLATE "vs")
        else()
            set(CPPCHECK_TEMPLATE "gcc")
        endif()

        if(ARGUMENTS_OPTIONS)
            set(TARGET_CXX_CPPCHECK "${CPPCHECK};${ARGUMENTS_OPTIONS}")
        else()
            get_default_cppcheck_options(OPTIONS ${CPPCHECK_TEMPLATE})
            # if the user provides a OPTIONS with a template specified, it will override this template
            set(TARGET_CXX_CPPCHECK ${CPPCHECK} --template=${CPPCHECK_TEMPLATE} "${OPTIONS}")
        endif()

        if(TARGET_CXX_STANDARD)
            set(TARGET_CXX_CPPCHECK ${TARGET_CXX_CPPCHECK} --std=c++${TARGET_CXX_STANDARD})
        endif()

        if(ARGUMENTS_WARNINGS_AS_ERRORS)
            if(${ARGUMENTS_WARNINGS_AS_ERRORS})
                list(APPEND TARGET_CXX_CPPCHECK --error-exitcode=2)
            endif()
        endif()

        message(STATUS "using cppcheck analyzer on build for project ${target}")
        set_target_properties(${ARGUMENTS_TARGET} PROPERTIES CXX_CPPCHECK "${TARGET_CXX_CPPCHECK}")
    else()
        message(WARNING "cppcheck requested but executable not found")
    endif()
endfunction()

function(get_clang_tidy_default_options OPTIONS)
    set(DEFAULT_OPTIONS
        --config-file=${CMAKE_SOURCE_DIR}/.clang-tidy -extra-arg=-Wno-unknown-warning-option
        -extra-arg=-Wno-ignored-optimization-argument -extra-arg=-Wno-unused-command-line-argument -p
        ${CMAKE_BINARY_DIR})
    set(OPTIONS
        "${DEFAULT_OPTIONS}"
        PARENT_SCOPE)
endfunction()

# cmake-format: off
##
# Function: target_clangtidy
# 
# This function sets up and integrates the clang-tidy static analysis tool for a specified target in a CMake project.
# It locates the clang-tidy executable and configures it with the appropriate options and target properties.
# 
# Signature:
#
#   target_clangtidy(TARGET <target>
#                    WARNINGS_AS_ERRORS <bool>
#                    [OPTIONS] <list>)
#
# Parameters:
# 
# - TARGET: The name of the target to analyze with cppcheck.
# - WARNINGS_AS_ERRORS: Optional flag indicating whether warnings should be treated as errors.
# - OPTIONS: overwrite options to be passed when executing the tool.
# 
# This function relies on the `cmake_parse_arguments` function to parse input arguments and
# `get_target_property` to retrieve target-specific properties such as the CXX standard.
##
# cmake-format: on
function(target_clangtidy)
    find_program(CLANGTIDY clang-tidy)
    if(CLANGTIDY)
        cmake_parse_arguments(ARGUMENTS "" "TARGET;WARNINGS_AS_ERRORS" "OPTIONS" "${ARGV}")

        if(NOT ARGUMENTS_TARGET)
            message(FATAL_ERROR "TARGET is required for `target_clangtidy` function")
        endif()

        get_target_property(TARGET_CXX_STANDARD ${ARGUMENTS_TARGET} CXX_STANDARD)

        if(NOT CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
            get_target_property(TARGET-pch ${target} INTERFACE_PRECOMPILE_HEADERS)

            if("${TARGET-pch}" STREQUAL "TARGET-pch-NOTFOUND")
                get_target_property(TARGET-pch ${ARGUMENTS_TARGET} PRECOMPILE_HEADERS)
            endif()

            if(NOT ("${TARGET-pch}" STREQUAL "TARGET-pch-NOTFOUND"))
                message(
                    SEND_ERROR
                        "clang-tidy cannot be enabled with non-clang compiler and PCH, clang-tidy fails to handle gcc's PCH file"
                )
            endif()
        endif()

        if(ARGUMENTS_OPTIONS)
            set(TARGET_CXX_CLANGTIDY "${CLANGTIDY};${ARGUMENTS_OPTIONS}")
        else()
            get_clang_tidy_default_options(OPTIONS)
            set(TARGET_CXX_CLANGTIDY "${CLANGTIDY};${OPTIONS}")
        endif()
        # set standard
        if(TARGET_CXX_STANDARD)
            if(UNIX)
                set(TARGET_CXX_CLANGTIDY ${TARGET_CXX_CLANGTIDY} -extra-arg=-std=c++${TARGET_CXX_STANDARD})
            else()
                if(${CMAKE_CXX_CLANG_TIDY_DRIVER_MODE} STREQUAL "cl" AND NOT ${CMAKE_GENERATOR} MATCHES "Ninja")
                    set(TARGET_CXX_CLANGTIDY ${TARGET_CXX_CLANGTIDY} -extra-arg=/std:c++${TARGET_CXX_STANDARD})
                else()
                    set(TARGET_CXX_CLANGTIDY ${TARGET_CXX_CLANGTIDY} -extra-arg=-std=c++${TARGET_CXX_STANDARD})
                endif()
            endif()
        endif()

        # set warnings as errors
        if(ARGUMENTS_WARNINGS_AS_ERRORS)
            if(${ARGUMENTS_WARNINGS_AS_ERRORS})
                list(APPEND TARGET_CXX_CLANGTIDY -warnings-as-errors=*)
            endif()
        endif()

        message(STATUS "using clang-tidy analyzer on build for project ${ARGUMENTS_TARGET}")
        set_target_properties(${ARGUMENTS_TARGET} PROPERTIES CXX_CLANG_TIDY "${TARGET_CXX_CLANGTIDY}")
    else()
        message(WARNING "clang-tidy requested but executable not found")
    endif()
endfunction()

function(get_default_iwyu_options OPTIONS)
    set(DEFAULT_OPTIONS
        -w
        -Xiwyu
        --max_line_length=120
        -Xiwyu
        --no_comments
        -Xiwyu
        --no_fwd_decls)
    set(OPTIONS
        "${DEFAULT_OPTIONS}"
        PARENT_SCOPE)
endfunction()

# cmake-format: off
##
# Function: target_include_what_you_use
# 
# This function sets up and integrates the "include-what-you-use" (IWYU) tool for a specified target in a CMake project.
# It locates the IWYU executable and configures it with the appropriate options and target properties.
# 
# Signature:
#
#   target_include_what_you_use(TARGET <target>
#                               [OPTIONS] <list>)
#
# Parameters:
# 
# - TARGET: The name of the target to analyze with include-what-you-use.
# - OPTIONS: Optional list of additional options to be passed to the IWYU command.
# 
# This function relies on the `cmake_parse_arguments` function to parse input arguments.
##
# cmake-format: on
function(target_include_what_you_use)
    find_program(INCLUDE_WHAT_YOU_USE include-what-you-use)

    if(INCLUDE_WHAT_YOU_USE)
        cmake_parse_arguments(ARGUMENTS "" "TARGET" "OPTIONS" "${ARGV}")

        if(NOT ARGUMENTS_TARGET)
            message(FATAL_ERROR "TARGET is required for `target_include_what_you_use` function")
        endif()

        if(ARGUMENTS_IWYU_OPTIONS)
            set(TARGET_IWYU_OPTIONS "${ARGUMENTS_IWYU_OPTIONS}")
        else()
            get_default_iwyu_options(OPTIONS)
            set(TARGET_IWYU_OPTIONS "${OPTIONS}")
        endif()

        message(STATUS "using iwyu analyzer on build for project ${ARGUMENTS_TARGET}")
        set_target_properties(${ARGUMENTS_TARGET} PROPERTIES CXX_INCLUDE_WHAT_YOU_USE
                                                   "${INCLUDE_WHAT_YOU_USE};${TARGET_IWYU_OPTIONS}")
    else()
        message(WARNING "include-what-you-use requested but executable not found")
    endif()
endfunction()

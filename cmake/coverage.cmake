# ---- Add coverage flags

include(CMakeParseArguments)

function(target_add_coverage_flags target)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        target_compile_options(${target} PRIVATE --coverage -fno-inline)
        target_link_options(${target} PUBLIC --coverage)

        if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
            target_compile_options(${target} PRIVATE -fprofile-instr-generate -fcoverage-mapping)
        endif()
    else()
        message(WARNING "failed to add coverage information generation compiler is not support coverage")
    endif()
endfunction()

# add coverage check target for `target` library and its `test_target` test executable
function(coverage_target coverage_target_prefix)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        cmake_parse_arguments(ARGUMENTS "" "TEST_TARGET;WORKING_DIRECTORY" "" "${ARGV}")

        if (NOT ARGUMENTS_TEST_TARGET)
            message(FATAL_ERROR "TEST_TARGET variable must be set")
        endif()

        find_program(LCOV lcov)
        find_program(GENHTML genhtml)

        if (NOT LCOV OR NOT GENHTML)
            return()
        endif()

        if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
            set(LCOV_TOOL ${LCOV} --gcov-tool ${CMAKE_SOURCE_DIR}/cmake/gcov-llvm-wrapper.sh)
            set_target_properties(${ARGUMENTS_TEST_TARGET} PROPERTIES ENVIRONMENT "LLVM_PROFILE_FILE=${coverage_target_prefix}.profraw")
        else() 
            set(LCOV_TOOL ${LCOV})
        endif()

        if(ARGUMENTS_WORKING_DIRECTORY)
            set(_working_directory ${ARGUMENTS_WORKING_DIRECTORY})
        else()
            set(_working_directory $<TARGET_FILE_DIR:${ARGUMENTS_TEST_TARGET}>)
        endif()

        add_custom_target(
            ${coverage_target_prefix}-lcov
            COMMAND ${CMAKE_COMMAND} -E remove_directory coverage
            COMMAND ${LCOV_TOOL} -d . --zerocounters
            COMMAND $<TARGET_FILE:${ARGUMENTS_TEST_TARGET}>
            COMMAND ${LCOV_TOOL} -d . --capture -o coverage-${coverage_target_prefix}.info
            COMMAND ${LCOV_TOOL} -r coverage-${coverage_target_prefix}.info '/usr/include/*' '*.conan2*' '*_deps*' -o filtered-${coverage_target_prefix}.info
            DEPENDS ${ARGUMENTS_TEST_TARGET}
            WORKING_DIRECTORY ${_working_directory}
            COMMENT "prepararing lcov analysis info for ${coverage_target_prefix}, working directory ${_working_directory}")

        add_custom_target(
            ${coverage_target_prefix}-genhtml
            COMMAND ${GENHTML} -o coverage filtered-${coverage_target_prefix}.info --legend
            DEPENDS ${coverage_target_prefix}-lcov
            WORKING_DIRECTORY ${_working_directory}
            COMMENT "prepararing html report for ${coverage_target_prefix}")

        add_custom_target(
            ${coverage_target_prefix}-coverage
            WORKING_DIRECTORY ${_working_directory}
            DEPENDS ${coverage_target_prefix}-genhtml
            COMMENT "running coverage for ${coverage_target_prefix}")

        add_custom_command(
            TARGET ${coverage_target_prefix}-coverage
            PRE_BUILD
            COMMAND find ${_working_directory} -type f -name '*.gcda' -exec rm {} +
            COMMENT "removing old .gcda files for ${coverage_target_prefix}")
    endif()
endfunction(coverage_target)

include(CMakeParseArguments)

function(target_add_coverage_flags target)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        target_compile_options(${target} PRIVATE --coverage -fno-inline)
        target_link_options(${target} PUBLIC --coverage)

        if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
            target_compile_options(${target} PUBLIC -fprofile-instr-generate -fcoverage-mapping)
            target_link_options(${target} PUBLIC -fprofile-instr-generate -fcoverage-mapping)
        endif()
    else()
        message(WARNING "failed to add coverage information generation compiler is not support coverage")
    endif()
endfunction()

function(add_coverage_lcov_target target)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        find_program(LCOV lcov)
        find_program(GENHTML genhtml)

        if(NOT LCOV OR NOT GENHTML)
            return()
        endif()

        if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
            set(LCOV_TOOL ${LCOV} --gcov-tool ${CMAKE_SOURCE_DIR}/cmake/gcov-llvm-wrapper.sh)
        else()
            set(LCOV_TOOL ${LCOV})
        endif()

        add_custom_target(
            ${target}-coverage-lcov
            COMMAND ${CMAKE_COMMAND} -E remove_directory coverage
            COMMAND ${LCOV_TOOL} -d . --zerocounters
            COMMAND $<TARGET_FILE:${target}>
            COMMAND ${LCOV_TOOL} -d . --capture -o coverage-${target}.info
            COMMAND ${LCOV_TOOL} -r coverage-${target}.info '/usr/include/*' 'boost/*' '*.conan2*' -o
                    filtered-${target}.info
            COMMAND ${GENHTML} -o coverage-lcov filtered-${target}.info --legend
            WORKING_DIRECTORY $<TARGET_FILE_DIR:${target}>/../)

        add_custom_command(
            TARGET ${target}
            PRE_BUILD
            COMMAND sh -c "find $<TARGET_FILE_DIR:${target}>/../ -name '*.gcda' -exec rm -f {} +"
            COMMENT "Removing all .gcda files before build"
            WORKING_DIRECTORY $<TARGET_FILE_DIR:${target}>/../)
    else()
        message(WARNING "[Rcs] lcov_coverage_target requested, but compiler do not match GNU or Clang")
    endif()
endfunction()

function(add_coverage_llvm_target target)
    if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        find_program(LLVM_COV_PATH llvm-cov)
        find_program(LLVM_PROFDATA_PATH llvm-profdata)

        if(NOT LLVM_COV_PATH OR NOT LLVM_PROFDATA_PATH)
            message(WARNING "[Rcs] llvm_coverage_target requested, but llvm-cov or llvm-profdata not found")
            return()
        endif()

        add_custom_target(
            ${target}-coverage-llvm
            COMMAND $<TARGET_FILE:${target}>
            COMMAND ${LLVM_PROFDATA_PATH} merge --sparse default.profraw -o default.profdata
            COMMAND
                ${LLVM_COV_PATH} show $<TARGET_FILE:${target}> -instr-profile=default.profdata
                -ignore-filename-regex='.*/tests/.*' -show-line-counts-or-regions -use-color -show-instantiation-summary
                -show-branches=count -format=html -output-dir=./../coverage-llvm
            COMMAND ${LLVM_COV_PATH} report $<TARGET_FILE:${target}> -instr-profile=default.profdata
                    -ignore-filename-regex='.*/tests/.*' -show-region-summary=false -show-branch-summary=false
            WORKING_DIRECTORY $<TARGET_FILE_DIR:${target}>)

        set_target_properties(${target} PROPERTIES ENVIRONMENT "LLVM_PROFILE_FILE=default.profraw")
    else()
        message(WARNING "[Rcs] llvm_coverage_target requested, but compiler do not match Clang")
    endif()
endfunction()

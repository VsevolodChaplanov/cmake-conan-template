# ---- Variables ----

# # We use variables separate from what CTest uses, because those have customization issues
# set(COVERAGE_TRACE_COMMAND
#     lcov -c -q -o "${PROJECT_BINARY_DIR}/coverage.info" -d "${PROJECT_BINARY_DIR}" --include "${PROJECT_SOURCE_DIR}/*"
#     CACHE STRING "; separated command to generate a trace for the 'coverage' target")

# set(COVERAGE_HTML_COMMAND
#     genhtml --legend -f -q "${PROJECT_BINARY_DIR}/coverage.info" -p "${PROJECT_SOURCE_DIR}" -o
#     "${PROJECT_BINARY_DIR}/coverage_html"
#     CACHE STRING "; separated command to generate an HTML report for the 'coverage' target")

# # ---- Coverage target ----

# add_custom_target(
#     coverage
#     COMMAND ${COVERAGE_TRACE_COMMAND}
#     COMMAND ${COVERAGE_HTML_COMMAND}
#     COMMENT "Generating coverage report"
#     VERBATIM)

# ---- Add coverage flags

include(CMakeParseArguments)

macro(target_add_coverage_flags target)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        cmake_parse_arguments(ARGUMENTS "PUBLIC;PRIVATE;INTERFACE" "" "" "${ARGV}")

        if(ARGUMENTS_PUBLIC)
            set(VISIBILITY PUBLIC)
        elseif(ARGUMENTS_PRIVATE)
            set(VISIBILITY PRIVATE)
        elseif(ARGUMENTS_INTERFACE)
            set(VISIBILITY INTERFACE)
        else()
            set(VISIBILITY PRIVATE)
        endif()

        target_compile_options(${target} ${VISIBILITY} --coverage)
        target_link_options(${target} ${VISIBILITY} --coverage)
        target_link_libraries(${target} ${VISIBILITY} gcov)
    else()
        message(WARNING "failed to add coverage information generation compiler is not support coverage")
    endif()
endmacro()

macro(coverage_target target_name)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        add_custom_target(
            ${target_name}-lcov
            COMMAND lcov --capture --directory . --output-file coverage.info
            # COMMAND lcov -c -q -o "${PROJECT_BINARY_DIR}/coverage.info" -d "${PROJECT_BINARY_DIR}" --include
            # "${PROJECT_SOURCE_DIR}/*"
            WORKING_DIRECTORY $<TARGET_FILE_DIR:${target_name}>)

        add_custom_target(${target_name}-genhtml
            COMMAND genhtml coverage.info --output-directory out
            # COMMAND genhtml --legend -f -q "${PROJECT_BINARY_DIR}/coverage.info" -p "${PROJECT_SOURCE_DIR}" -o
            # "${PROJECT_BINARY_DIR}/coverage_html"
            DEPENDS ${target_name}-lcov
            WORKING_DIRECTORY $<TARGET_FILE_DIR:${target_name}>)

        add_custom_target(
            ${target_name}-coverage
            DEPENDS ${target_name}-genhtml
            COMMENT "generate coverage info for target `${target_name}`")
    endif()
endmacro(coverage_target)

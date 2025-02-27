# support for old-style way to add valgring for targets better way is to use memcheck option for ctest ctest -T memcheck

function(valgrind_target target)
    find_program(VALGRIND valgrind)

    if(VALGRIND)
        add_custom_target(
            ${target}-valgrind
            COMMAND ${VALGRIND} --leak-check=yes $<TARGET_FILE:${target}>
            WORKING_DIRECTORY $<TARGET_FILE_DIR:${target}>)
    endif()
endfunction()

function(memcheck_target target)
    find_program(VALGRIND valgrind)
    find_program(GAWK gawk)

    if(NOT GAWK)
        message(STATUS "gawk not found - valgrind html report generator can't be executed")
        return()
    endif()

    if(VALGRIND)
        include(FetchContent)
        FetchContent_Declare(
            memcheck-cover
            GIT_REPOSITORY https://github.com/Farigh/memcheck-cover.git
            GIT_TAG release-1.2)

        FetchContent_MakeAvailable(memcheck-cover)

        set(MEMCHECK ${memcheck-cover_SOURCE_DIR}/bin)

        add_custom_command(
            OUTPUT memcheck-cover.config
            COMMAND ${MEMCHECK}/generate_html_report.sh --generate-config
            WORKING_DIRECTORY $<TARGET_FILE_DIR:${target}>)

        add_custom_target(
            ${target}-memcheck-cover
            COMMAND ${MEMCHECK}/memcheck_runner.sh -o $<TARGET_FILE_DIR:${target}>/valgrind/report --
                    $<TARGET_FILE:${target}>
            COMMAND
                ${MEMCHECK}/generate_html_report.sh -i $<TARGET_FILE_DIR:${target}>/valgrind -o
                $<TARGET_FILE_DIR:${target}>/valgrind/report/ --config
                $<TARGET_FILE_DIR:${target}>/memcheck-cover.config
            WORKING_DIRECTORY $<TARGET_FILE_DIR:${target}>
            DEPENDS memcheck-cover.config)
    endif()
endfunction()

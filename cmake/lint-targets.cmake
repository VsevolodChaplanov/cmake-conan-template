# cmake-format: off
# Create source formatting target
#
# target_clang_format(TARGET <target>
#                     FILES <files-array>
#                     [CONFIG_FILE] <config>)
#
# TARGET: required only for formatting target naming
# FILES: list of files
# CONFIG_FILE: pass a path to config if using custom .clang-format config
# cmake-format: on
function(target_clang_format)
    find_program(CLANG_FORMAT NAMES clang-format clang-format.exe)

    if(CLANG_FORMAT)
        cmake_parse_arguments(ARGUMENTS "" "TARGET;CONFIG_FILE" "FILES" "${ARGN}")

        if(NOT ARGUMENTS_TARGET)
            message(FATAL_ERROR "TARGET is required for `target_clang_format` function")
        endif()

        if(ARGUMENTS_CONFIG_FILE)
            set(_config ${ARGUMENTS_CONFIG_FILE})
        else()
            set(_config ${CMAKE_SOURCE_DIR}/.clang-format)
        endif()

        add_custom_target(
            ${ARGUMENTS_TARGET}-clang-format
            COMMAND ${CLANG_FORMAT} --style="file:${_config}" -i "${ARGUMENTS_FILES}"
            COMMAND_EXPAND_LISTS
            COMMENT "run clang-format for ${ARGUMENTS_TARGET}")
    else()
        message("clang-format target requested but clang-format executable not found")
    endif()
endfunction()

function(target_clang_format target files)
    find_program(CLANG_FORMAT NAMES clang-format clang-format.exe)

    if(CLANG_FORMAT)
        cmake_parse_arguments(ARGUMENTS "" "CONFIG_FILE" "" "${ARGN}")

        if(ARGUMENTS_CONFIG_FILE)
            set(_config ${ARGUMENTS_CONFIG_FILE})
        else()
            set(_config ${CMAKE_SOURCE_DIR}/.clang-format)
        endif()

        add_custom_target(
            ${target}-clang-format
            COMMAND ${CLANG_FORMAT} --style="file:${_config}" -i "${files}"
            COMMAND_EXPAND_LISTS
            COMMENT "[Rcs] run clang-format for ${target}")
    else()
        message("[Rcs] clang-format target requested but clang-format executable not found")
    endif()
endfunction(target_clang_format target)

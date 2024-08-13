# Enable cache if available
function(project_enable_cache)
    set(CACHE_OPTION
        "ccache"
        CACHE STRING "Compiler cache to be used")
    set(cache_option_values "ccache" "sccache")
    set_property(CACHE CACHE_OPTION PROPERTY STRINGS ${cache_option_values})

    list(FIND cache_option_values ${CACHE_OPTION} CACHE_OPTION_INDEX)

    if(${CACHE_OPTION_INDEX} EQUAL -1)
        message(STATUS "Using custom compiler cache system:
                        '${CACHE_OPTION}', explicitly supported
                        entries are ${cache_option_values}")
    endif()

    find_program(CACHE_BINARY NAMES ${cache_option_values})

    if(CACHE_BINARY)
        message(STATUS "${CACHE_BINARY} found and enabled")
        set(CMAKE_CXX_COMPILER_LAUNCHER
            ${CACHE_BINARY}
            CACHE FILEPATH "CXX compiler cache used")
        set(CMAKE_C_COMPILER_LAUNCHER
            ${CACHE_BINARY}
            CACHE FILEPATH "C compiler cache used")
    else()
        message(WARNING "${CACHE_OPTION} is enabled but was not found. Not using it")
    endif()
endfunction()

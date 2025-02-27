include(CMakeParseArguments)

function(_target_patch_rpath target paths)
    set(_paths $ORIGIN) 
    foreach(path ${paths})
        list(APPEND _paths "$ORIGIN/${path}")
    endforeach()

    set_target_properties(${PROJECT_NAME} PROPERTIES INSTALL_RPATH "${_paths}")
endfunction()

# Modify install rpath based on CMAKE_INSTALL_BINDIR and CMAKE_INSTALL_LIBDIR If you are using GNUInstallDirs layout
#
# bin/exe lib/libexe.so
#
# You will not be forced to set LD_LIBRARY_PATH or modify any other linker vars
function(target_patch_rpath target)
    cmake_parse_arguments(ARGUMENTS "" "IF" "ORIGIN_RELATIVE_PATHS" "${ARGV}")

    # if `IF` passed do patch according its value
    if(ARGUMENTS_IF)
        if(NOT ${ARGUMENTS_IF})
            return()
        endif()
    endif()

    # use user's passed paths
    if(ARGUMENTS_ORIGIN_RELATIVE_PATHS)
        set(origin_relative ${ARGUMENTS_ORIGIN_RELATIVE_PATHS})
    else()
        file(RELATIVE_PATH origin_relative ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_INSTALL_BINDIR}
             ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
    endif()

    _target_patch_rpath(${target} "${origin_relative}")
endfunction()

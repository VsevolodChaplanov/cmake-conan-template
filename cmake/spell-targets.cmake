find_program(CODESPELL NAMES codespell codespell.exe)

if(CODESPELL)
    message(STATUS "codespcell found, spell check targets added")

    add_custom_target(
        spell-check
        COMMAND "${CMAKE_COMMAND}" -D "SPELL_COMMAND=${CODESPELL}" -P "${PROJECT_SOURCE_DIR}/cmake/spell.cmake"
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        COMMENT "Checking spelling"
        VERBATIM)

    add_custom_target(
        spell-fix
        COMMAND "${CMAKE_COMMAND}" -D "SPELL_COMMAND=${CODESPELL}" -D FIX=YES -P
                "${PROJECT_SOURCE_DIR}/cmake/spell.cmake"
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        COMMENT "Fixing spelling errors"
        VERBATIM)
else()
    message(STATUS "codespell is not found, spell check targets not added")
endif()

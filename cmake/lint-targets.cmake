set(FORMAT_PATTERNS
    source/*.cpp
    source/*.hpp
    include/*.hpp
    test/*.cpp
    test/*.hpp
    example/*.cpp
    example/*.hpp
    CACHE STRING "; separated patterns relative to the project source dir to format")

find_program(CLANG_FORMAT NAMES clang-format clang-format.exe)

if(CLANG_FORMAT)
    message(STATUS "clang-format found, formatting targets added")

    add_custom_target(
        format-check
        COMMAND "${CMAKE_COMMAND}" -D "FORMAT_COMMAND=${CLANG_FORMAT}" -D "PATTERNS=${FORMAT_PATTERNS}" -P
                "${PROJECT_SOURCE_DIR}/cmake/lint.cmake"
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        COMMENT "Linting the code"
        VERBATIM)

    add_custom_target(
        format-fix
        COMMAND "${CMAKE_COMMAND}" -D "FORMAT_COMMAND=${CLANG_FORMAT}" -D "PATTERNS=${FORMAT_PATTERNS}" -D FIX=YES -P
                "${PROJECT_SOURCE_DIR}/cmake/lint.cmake"
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        COMMENT "Fixing the code"
        VERBATIM)
else()
    message(STATUS "clang-format is not found, formatting targets not added")
endif()

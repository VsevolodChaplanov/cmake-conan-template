# ---- Dependencies ----

function(wrap_doxygen_add_docs target)
    find_package(Doxygen)

    if(NOT Doxygen_FOUND)
        return()
    endif()

    include(CMakeParseArguments)
    cmake_parse_arguments(ARGUMENTS "" "" "SOURCE_DIRS;OUTPUT" "${ARGV}")

    set(DOXYGEN_GENERATE_HTML YES)

    if(ARGUMENTS_OUTPUT)
        set(DOXYGEN_HTML_OUTPUT ${PROJECT_BINARY_DIR}/${ARGUMENTS_OUTPUT})
    else()
        set(DOXYGEN_HTML_OUTPUT ${PROJECT_BINARY_DIR}/documentation)
    endif()

    if(ARGUMENTS_SOURCE_DIRS)
        set(FILES_FOR_DOC_SOURCE_DIR ${ARGUMENTS_SOURCE_DIRS})
    else()
        set(FILES_FOR_DOC_SOURCE_DIR ${PROJECT_SOURCE_DIR})
    endif()

    set(EXCLUDE_PATTERNS
        */.git/*
        */.svn/*
        */.idea/*
        */.mypy_cache/*
        */.vs/*
        */cmake/*
        */conan/*
        */conan_test/*
        */fetch_content_test/*
        */.hg/*
        */CMakeFiles/*
        */build/*
        */install/*
        */_CPack_Packages/*
        conanfile.py
        DartConfiguration.tcl
        CMakeLists.txt
        CMakeCache.txt)

    set(DOXYGEN_EXCLUDE_PATTERNS "${EXCLUDE_PATTERNS}")

    if (NOT (CMAKE_SYSTEM_NAME STREQUAL "Windows" AND CMAKE_GENERATOR STREQUAL "Ninja"))
        doxygen_styling()
    endif()

    doxygen_add_docs("${target}-doxygen" "${FILES_FOR_DOC_SOURCE_DIR}"
                     COMMENT "Generate HTML documentation for ${target}")
endfunction()

macro(doxygen_styling)
    include(FetchContent)

    FetchContent_Declare(
        doxygen-awesome-css
        GIT_REPOSITORY https://github.com/jothepro/doxygen-awesome-css.git
        GIT_TAG v2.3.3)
    FetchContent_MakeAvailable(doxygen-awesome-css)

    set(DOXYGEN_GENERATE_TREEVIEW YES)
    set(DOXYGEN_HAVE_DOT YES)
    set(DOXYGEN_DOT_IMAGE_FORMAT svg)
    set(DOXYGEN_DOT_TRANSPARENT YES)
    set(DOXYGEN_HTML_EXTRA_STYLESHEET ${doxygen-awesome-css_SOURCE_DIR}/doxygen-awesome.css)

    set(DOXYGEN_HTML_EXTRA_FILES
        ${doxygen-awesome-css_SOURCE_DIR}/doxygen-awesome-darkmode-toggle.js
        ${doxygen-awesome-css_SOURCE_DIR}/doxygen-awesome-fragment-copy-button.js
        ${doxygen-awesome-css_SOURCE_DIR}/doxygen-awesome-paragraph-link.js
        ${doxygen-awesome-css_SOURCE_DIR}/doxygen-awesome-interactive-toc.js)

    execute_process(COMMAND doxygen -w html header.html footer.html style.css WORKING_DIRECTORY ${PROJECT_BINARY_DIR})
    execute_process(COMMAND sed -i "/<\\/head>/r ${PROJECT_SOURCE_DIR}/cmake/doxygen_extra_headers" header.html
                    WORKING_DIRECTORY ${PROJECT_BINARY_DIR})

    set(DOXYGEN_HTML_HEADER ${PROJECT_BINARY_DIR}/header.html)
endmacro()

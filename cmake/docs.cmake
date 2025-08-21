# ---- Documentation Generation ----

# Function to add documentation generation for the entire project
function(project_documentation)
    find_package(Doxygen)

    if(NOT Doxygen_FOUND)
        message(STATUS "Doxygen not found, skipping documentation generation")
        return()
    endif()

    # Configure Doxygen settings
    set(DOXYGEN_GENERATE_HTML YES)
    set(DOXYGEN_GENERATE_TREEVIEW YES)
    set(DOXYGEN_HAVE_DOT YES)
    set(DOXYGEN_DOT_IMAGE_FORMAT svg)
    set(DOXYGEN_DOT_TRANSPARENT YES)

    # Set exclusion patterns for common build and development directories
    set(DOXYGEN_EXCLUDE_PATTERNS
        */.git/*
        */.svn/*
        */.idea/*
        */.mypy_cache/*
        */.vs/*
        */.cache/*
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

    # Apply doxygen styling if available
    if(NOT (CMAKE_SYSTEM_NAME STREQUAL "Windows" AND CMAKE_GENERATOR STREQUAL "Ninja"))
        doxygen_styling()
    endif()

    doxygen_add_docs(${PROJECT_NAME}-docs ${PROJECT_SOURCE_DIR} COMMENT "Generate HTML documentation for ${PROJECT_NAME}")
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

    if(EXISTS "${PROJECT_SOURCE_DIR}/cmake/doxygen_extra_headers")
        execute_process(COMMAND sed -i "/<\\/head>/r ${PROJECT_SOURCE_DIR}/cmake/doxygen_extra_headers" header.html
                        WORKING_DIRECTORY ${PROJECT_BINARY_DIR})
    endif()

    set(DOXYGEN_HTML_HEADER ${PROJECT_BINARY_DIR}/header.html)
endmacro()

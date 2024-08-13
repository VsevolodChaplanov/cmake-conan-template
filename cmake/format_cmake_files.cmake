foreach(file IN LISTS CMAKE_FILES)
    message(STATUS "Formatting ${file}")
    execute_process(
        COMMAND cmake-format -i ${file}
        WORKING_DIRECTORY D:/coding/cmake-conan-template
        RESULT_VARIABLE result)
    if(result)
        message(FATAL_ERROR "Failed to format ${file}")
    endif()
endforeach()

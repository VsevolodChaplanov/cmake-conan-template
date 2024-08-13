set(files_directory ${CMAKE_ARGV3})
file(
    GLOB
    cmake_files
    ${files_directory}/cmake/*.cmake
    ${files_directory}/CMakeLists.txt
    ${files_directory}/*.cmake
    ${files_directory}/test/CMakeLists.txt
    ${files_directory}/test_package/CMakeLists.txt)

# Format each CMake file
foreach(file ${cmake_files})
    # add_custom_target(${file} COMMAND cmake-format.exe -i ${file} COMMENT ) add_dependencies(format_all ${file})
    execute_process(
        COMMAND cmake-format -i ${file}
        WORKING_DIRECTORY ${files_directory}
        RESULT_VARIABLE result)
    if(result EQUAL 0)
        message(STATUS "Formatted: ${file}")
    else()
        message(WARNING "Failed to format: ${file}, message ${result}")
    endif()
endforeach()

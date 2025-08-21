include_guard(GLOBAL)

include(CMakePackageConfigHelpers)

write_basic_package_version_file(${PROJECT_NAME}ConfigVersion.cmake COMPATIBILITY SameMajorVersion ARCH_INDEPENDENT)

# Allow PROJECT_NAME maintainers to freely override the path for the configs
set(${PROJECT_NAME}_INSTALL_CMAKEDIR
    ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
    CACHE STRING "CMake PROJECT_NAME config location relative to the install prefix")
set_property(CACHE ${PROJECT_NAME}_INSTALL_CMAKEDIR PROPERTY TYPE PATH)
mark_as_advanced(${PROJECT_NAME}_INSTALL_CMAKEDIR)

configure_package_config_file(cmake/install-config.cmake.in ${PROJECT_NAME}Config.cmake
                              INSTALL_DESTINATION ${${PROJECT_NAME}_INSTALL_CMAKEDIR})

install(
    FILES ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake ${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    DESTINATION ${${PROJECT_NAME}_INSTALL_CMAKEDIR}
    COMPONENT Development)

install(
    EXPORT ${PROJECT_NAME}Targets
    NAMESPACE ${PROJECT_NAME}::
    DESTINATION ${${PROJECT_NAME}_INSTALL_CMAKEDIR}
    COMPONENT Development)

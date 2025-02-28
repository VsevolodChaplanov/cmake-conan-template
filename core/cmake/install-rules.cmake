include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

# find_package(<package>) call for consumers to find this project
set(package ${PROJECT_NAME})

# cmake-format: off
install(
    TARGETS ${package}
    EXPORT ${package}Targets
    RUNTIME COMPONENT Runtime
    LIBRARY COMPONENT Runtime NAMELINK_COMPONENT Development
    ARCHIVE COMPONENT Development
    FILE_SET ${package}_Headers COMPONENT Development
    FILE_SET ${package}_GeneratedHeaders COMPONENT Development)
# cmake-format: on

write_basic_package_version_file(${package}ConfigVersion.cmake COMPATIBILITY SameMajorVersion ARCH_INDEPENDENT)

# Allow package maintainers to freely override the path for the configs
set(${package}_INSTALL_CMAKEDIR
    ${CMAKE_INSTALL_DATADIR}/${package}
    CACHE STRING "CMake package config location relative to the install prefix")
set_property(CACHE ${package}_INSTALL_CMAKEDIR PROPERTY TYPE PATH)
mark_as_advanced(${package}_INSTALL_CMAKEDIR)

configure_package_config_file(cmake/install-config.cmake.in ${package}Config.cmake
                              INSTALL_DESTINATION ${${package}_INSTALL_CMAKEDIR})

install(
    FILES ${PROJECT_BINARY_DIR}/${package}Config.cmake ${PROJECT_BINARY_DIR}/${package}ConfigVersion.cmake
    DESTINATION ${${package}_INSTALL_CMAKEDIR}
    COMPONENT Development)

install(
    EXPORT ${package}Targets
    NAMESPACE ${PARENT_PROJECT_NAME}::
    DESTINATION ${${package}_INSTALL_CMAKEDIR}
    COMPONENT Development)

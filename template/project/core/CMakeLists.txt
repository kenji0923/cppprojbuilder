# ----- Custom function definition start -----

# Add the standard include directory.
function(VAR_PROJECT_NAME_add_include_directory_std target_name scope)
    target_include_directories(${target_name} ${scope}
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
	$<INSTALL_INTERFACE:$<INSTALL_PREFIX>/include/${PROJECT_NAME}>
    )
endfunction()


# Add library with a standard filenames
# The third argument can be used for specifying library type (STATIC|SHARED|INTERFACE)
function(VAR_PROJECT_NAME_add_library_std target_name library_file_name)
    set(library_type "")

    if(${ARGC} GREATER 2)
	set(library_type ${ARGV2})
    endif()


    set(include_scope "PUBLIC")

    if("${library_type}" STREQUAL "INTERFACE")
	add_library(${target_name} ${library_type} include/${PROJECT_NAME}/${library_file_name}.h)
	set(include_scope "INTERFACE")
    else()
	add_library(${target_name} ${library_type} ${library_file_name}.cc include/${PROJECT_NAME}/${library_file_name}.h)
	target_compile_options(${target_name} PRIVATE -Wall -Wextra -Wpedantic)
    endif()

    VAR_PROJECT_NAME_add_include_directory_std(${target_name} ${include_scope})

    add_library(${PROJECT_NAME}::${target_name} ALIAS ${target_name})

    install(TARGETS ${target_name}
	EXPORT ${PROJECT_NAME}Targets
	LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR}
	INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )
    install(DIRECTORY include/${PROJECT_NAME}
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )
endfunction()


# Install the package configuration files so that other projects can locate this
# project with find_package(${PROJECT_NAME}) and link ${PROJECT_NAME}::<target>.
# Call this once, after all libraries have been declared with the helper above.
function(VAR_PROJECT_NAME_install_package)
    include(CMakePackageConfigHelpers)

    set(config_dir ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

    install(EXPORT ${PROJECT_NAME}Targets
	NAMESPACE ${PROJECT_NAME}::
	DESTINATION ${config_dir}
    )

    configure_package_config_file(
	${CMAKE_CURRENT_SOURCE_DIR}/cmake/Config.cmake.in
	${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
	INSTALL_DESTINATION ${config_dir}
    )

    write_basic_package_version_file(
	${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
	VERSION ${PROJECT_VERSION}
	COMPATIBILITY SameMajorVersion
    )

    install(FILES
	${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
	${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
	DESTINATION ${config_dir}
    )
endfunction()

# ----- Function definiion end -----

# VAR_PROJECT_NAME_add_library_std(ExampleLibrary example_file_basename)
# target_link_libraries(ExampleLibrary PUBLIC
#     cereal::cereal
# )
#
# # Call once, after all libraries above are declared:
# VAR_PROJECT_NAME_install_package()

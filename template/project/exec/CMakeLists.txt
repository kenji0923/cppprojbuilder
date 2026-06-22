# ----- Custom function definition start -----

# Add an executable with standard install (goes to the bin directory).
# Pass the target name followed by its source files.
function(VAR_PROJECT_NAME_add_executable_std target_name)
    add_executable(${target_name} ${ARGN})
    target_compile_options(${target_name} PRIVATE -Wall -Wextra -Wpedantic)

    install(TARGETS ${target_name}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
endfunction()

# ----- Function definiion end -----

# VAR_PROJECT_NAME_add_executable_std(ExampleExecutable example_executable.cc)
# target_link_libraries(ExampleExecutable PRIVATE
#     argparse
#     nlohmann_json::nlohmann_json
#     VAR_PROJECT_NAME::ExampleLibrary
# )

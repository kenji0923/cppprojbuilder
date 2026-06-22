cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

project(VAR_PROJECT_NAME VERSION 0.1.0)

include(GNUInstallDirs)

set(CMAKE_CXX_STANDARD 17)

option(BUILD_SHARED_LIBS "Build using shared libraries" OFF)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()
# Note: -Ofast enables -ffast-math, which breaks strict IEEE float semantics.
# Use -Ofast instead only if you understand and accept that trade-off.
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

# -----
# External packages
# -----

# set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# include(FetchContent)
#
# FetchContent_Declare(
#     argparse
#     GIT_REPOSITORY https://github.com/p-ranav/argparse
#     GIT_TAG        af442b4da0cd7a07b56fa709bd16571889dc7fda # v3.0
#     FIND_PACKAGE_ARGS
# )
#
# set(BUILD_SANDBOX OFF)
# FetchContent_Declare(
#     cereal
#     GIT_REPOSITORY https://github.com/USCiLab/cereal
#     GIT_TAG        ebef1e929807629befafbb2918ea1a08c7194554 # v1.3.2
# )
#
# FetchContent_Declare(
#     nlohmann_json 
#     GIT_REPOSITORY https://github.com/nlohmann/json
#     GIT_TAG 9cca280a4d0ccf0c08f47a99aa71d1b0e52f8d03 # v3.11.3
# )

# find_package(Boost REQUIRED)
# find_package(GSL REQUIRED)
# find_package(ROOT COMPONENTS Core ROOTDataFrame)
# find_package(HDF5 REQUIRED COMPONENTS C)
# FetchContent_MakeAvailable(argparse cereal nlohmann_json)

add_subdirectory(${PROJECT_SOURCE_DIR}/doc)
add_subdirectory(${PROJECT_SOURCE_DIR}/core)
add_subdirectory(${PROJECT_SOURCE_DIR}/exec)

# SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
# SPDX-License-Identifier: BSD-3-Clause
cmake_minimum_required(VERSION 3.10)

project(xdga_directories VERSION 0.0.1)

find_package(PkgConfig REQUIRED)

pkg_check_modules(Qt5Core REQUIRED IMPORTED_TARGET Qt5Core)

add_library(xdga_directories SHARED
    "xdga_directories.cpp"
)

target_link_libraries(xdga_directories PRIVATE PkgConfig::Qt5Core)

set_target_properties(xdga_directories PROPERTIES
    PUBLIC_HEADER "xdga_directories.h"
    OUTPUT_NAME "xdga_directories"
)

target_compile_definitions(xdga_directories PUBLIC DART_SHARED_LIB)


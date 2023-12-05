# SPDX-FileCopyrightText: 2023 Open Mobile Platform LLC <community@omp.ru>
# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.10)

set(PROJECT_NAME sensors_plus_aurora)
set(PLUGIN_NAME  sensors_plus_aurora_platform_plugin)

project(${PROJECT_NAME} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wno-psabi")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

find_package(PkgConfig REQUIRED)
find_package(Qt5 COMPONENTS Core Network DBus Sensors REQUIRED)

pkg_check_modules(FlutterEmbedder REQUIRED IMPORTED_TARGET flutter-embedder)

add_library(${PLUGIN_NAME} SHARED sensors_plus_aurora_plugin.cpp)
set_target_properties(${PLUGIN_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden AUTOMOC ON)

target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::FlutterEmbedder)
target_link_libraries(${PLUGIN_NAME} PUBLIC  Qt5::Core Qt5::Network Qt5::DBus Qt5::Sensors)

target_include_directories(${PLUGIN_NAME} PRIVATE ${FLUTTER_DIR})
target_include_directories(${PLUGIN_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_include_directories(${PLUGIN_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include/${PROJECT_NAME})

target_compile_definitions(${PLUGIN_NAME} PRIVATE PLUGIN_IMPL)

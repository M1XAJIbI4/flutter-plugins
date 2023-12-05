# SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.10)

set(PROJECT_NAME camera_aurora)
set(PLUGIN_NAME  camera_aurora_platform_plugin)

project(${PROJECT_NAME} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wno-psabi")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

find_package(PkgConfig REQUIRED)
find_package(Qt5 COMPONENTS Core Multimedia REQUIRED)

pkg_check_modules(FlutterEmbedder REQUIRED IMPORTED_TARGET flutter-embedder)
pkg_check_modules(GLES REQUIRED IMPORTED_TARGET glesv2)
pkg_check_modules(SC REQUIRED IMPORTED_TARGET streamcamera)

add_library(${PLUGIN_NAME} SHARED
    texture_camera.cpp
    camera_aurora_plugin.cpp
)

set_target_properties(${PLUGIN_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden AUTOMOC ON)

target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::FlutterEmbedder PkgConfig::GLES PkgConfig::SC)
target_link_libraries(${PLUGIN_NAME} PUBLIC Qt5::Core Qt5::Multimedia)

target_include_directories(${PLUGIN_NAME} PRIVATE ${FLUTTER_DIR})
target_include_directories(${PLUGIN_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_include_directories(${PLUGIN_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include/${PROJECT_NAME})

target_compile_definitions(${PLUGIN_NAME} PRIVATE PLUGIN_IMPL)

## zxing
target_include_directories(${PLUGIN_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include/libzxing)

add_custom_command(TARGET ${PLUGIN_NAME} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_SOURCE_DIR}/3rdpatry/zxing/${CMAKE_SYSTEM_PROCESSOR}/libzxing.so
                ${ROOT_PROJECT_BINARY_DIR}/bundle/lib/libzxing.so)

add_library(zxing SHARED IMPORTED)
set_property(TARGET zxing PROPERTY IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/3rdpatry/zxing/${CMAKE_SYSTEM_PROCESSOR}/libzxing.so)
target_link_libraries(${PLUGIN_NAME} PUBLIC zxing)

## yuv
target_include_directories(${PLUGIN_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include/libyuv)

add_custom_command(TARGET ${PLUGIN_NAME} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_SOURCE_DIR}/3rdpatry/libyuv/${CMAKE_SYSTEM_PROCESSOR}/libyuv.so
                ${ROOT_PROJECT_BINARY_DIR}/bundle/lib/libyuv.so)

add_library(yuv SHARED IMPORTED)
set_property(TARGET yuv PROPERTY IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/3rdpatry/libyuv/${CMAKE_SYSTEM_PROCESSOR}/libyuv.so)
target_link_libraries(${PLUGIN_NAME} PUBLIC yuv)

/**
 * SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef FLUTTER_PLUGIN_PACKAGE_INFO_PLUS_AURORA_PLUGIN_H
#define FLUTTER_PLUGIN_PACKAGE_INFO_PLUS_AURORA_PLUGIN_H

#include <package_info_plus_aurora/globals.h>

#include <flutter/plugin_registrar.h>
#include <flutter/method_channel.h>
#include <flutter/encodable_value.h>
#include <flutter/standard_method_codec.h>

typedef flutter::Plugin Plugin;
typedef flutter::PluginRegistrar PluginRegistrar;
typedef flutter::EncodableValue EncodableValue;
typedef flutter::MethodChannel<EncodableValue> MethodChannel;
typedef flutter::MethodCall<EncodableValue> MethodCall;
typedef flutter::MethodResult<EncodableValue> MethodResult;

class PLUGIN_EXPORT PackageInfoPlusAuroraPlugin final : public flutter::Plugin
{
public:
    static void RegisterWithRegistrar(PluginRegistrar* registrar);

private:
    // Creates a plugin that communicates on the given channel.
    PackageInfoPlusAuroraPlugin(std::unique_ptr<MethodChannel> methodChannel);

    // Methods register handlers channels
    void RegisterMethodHandler();

    std::unique_ptr<MethodChannel> m_methodChannel;
};

#endif /* FLUTTER_PLUGIN_PACKAGE_INFO_PLUS_AURORA_PLUGIN_H */

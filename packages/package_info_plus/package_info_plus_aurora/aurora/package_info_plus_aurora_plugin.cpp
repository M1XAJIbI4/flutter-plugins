/**
 * SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <package_info_plus_aurora/package_info_plus_aurora_plugin.h>
#include <flutter/platform-methods.h>

namespace Channels {
    constexpr auto Methods = "package_info_plus_aurora";
} // namespace Channels

namespace Methods {
    constexpr auto AppOrg = "getApplicationOrg";
    constexpr auto AppName = "getApplicationName";
} // namespace Methods

void PackageInfoPlusAuroraPlugin::RegisterWithRegistrar(PluginRegistrar* registrar)
{
    // Create MethodChannel with StandardMethodCodec
    auto methodChannel = std::make_unique<MethodChannel>(
        registrar->messenger(), Channels::Methods,
        &flutter::StandardMethodCodec::GetInstance());

    // Create plugin
    std::unique_ptr<PackageInfoPlusAuroraPlugin> plugin(new PackageInfoPlusAuroraPlugin(
        std::move(methodChannel)
    ));

    // Register plugin
    registrar->AddPlugin(std::move(plugin));
}

PackageInfoPlusAuroraPlugin::PackageInfoPlusAuroraPlugin(
    std::unique_ptr<MethodChannel> methodChannel
) : m_methodChannel(std::move(methodChannel))
{
    // Create MethodHandler
    RegisterMethodHandler();
}

void PackageInfoPlusAuroraPlugin::RegisterMethodHandler()
{
    m_methodChannel->SetMethodCallHandler(
        [&](const MethodCall& call, std::unique_ptr<MethodResult> result) {
            if (call.method_name().compare(Methods::AppOrg) == 0) {
                result->Success(PlatformMethods::GetOrgname());
            }
            else if (call.method_name().compare(Methods::AppName) == 0) {
                result->Success(PlatformMethods::GetAppname());
            }
            else {
                result->Success();
            }
        });
}

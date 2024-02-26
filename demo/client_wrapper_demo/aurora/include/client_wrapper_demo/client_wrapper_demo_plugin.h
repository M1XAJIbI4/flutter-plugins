/*
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_H
#define FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_H

#include <flutter/plugin-interface.h>
#include <client_wrapper_demo/globals.h>

class PLUGIN_EXPORT ClientWrapperDemoPlugin final : public PluginInterface
{
public:
    void RegisterWithRegistrar(PluginRegistrar &registrar) override;

private:
    void onMethodCall(const MethodCall &call);
    void unimplemented(const MethodCall &call);
};

#endif /* FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_H */

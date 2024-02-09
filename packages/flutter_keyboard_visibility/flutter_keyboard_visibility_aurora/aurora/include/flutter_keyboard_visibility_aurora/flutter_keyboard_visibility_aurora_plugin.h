/*
 * SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef FLUTTER_PLUGIN_FLUTTER_KEYBOARD_VISIBILITY_AURORA_PLUGIN_H
#define FLUTTER_PLUGIN_FLUTTER_KEYBOARD_VISIBILITY_AURORA_PLUGIN_H

#include <flutter/plugin-interface.h>
#include <flutter_keyboard_visibility_aurora/globals.h>

class PLUGIN_EXPORT FlutterKeyboardVisibilityAuroraPlugin final : public PluginInterface
{
public:
    FlutterKeyboardVisibilityAuroraPlugin();
    void RegisterWithRegistrar(PluginRegistrar &registrar) override;

private:
    bool m_sendEventVisibility = false;
    bool m_sendEventHeight = false;

    void onMethodCall(const MethodCall &call);
    void onGetKeyboardHeight(const MethodCall &call);
    void unimplemented(const MethodCall &call);
};

#endif /* FLUTTER_PLUGIN_FLUTTER_KEYBOARD_VISIBILITY_AURORA_PLUGIN_H */

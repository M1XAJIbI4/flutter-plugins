/*
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_H
#define FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_H

#include <flutter/plugin-interface.h>
#include <client_wrapper_demo/globals.h>
#include <client_wrapper_demo/helper.h>

#include <QImage>

class PLUGIN_EXPORT ClientWrapperDemoPlugin final : public PluginInterface
{
public:
    void RegisterWithRegistrar(PluginRegistrar &registrar) override;

private:
    QImage m_textureImage = Helper::GetImage();
    flutter::TextureRegistrar* m_textureRegistrar;
    std::vector<std::shared_ptr<flutter::TextureVariant>> m_textures;

    void MethodRegister(PluginRegistrar &registrar);
    void MethodUnimplemented(const MethodCall &call);

    void onCreateTexture(const MethodCall &call);
};

#endif /* FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_H */

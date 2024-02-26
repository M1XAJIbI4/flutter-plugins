/*
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <client_wrapper_demo/client_wrapper_demo_plugin.h>
#include <flutter/method-channel.h>
#include <flutter/platform-events.h>
#include <flutter/platform-methods.h>
#include <thread>

void ClientWrapperDemoPlugin::RegisterWithRegistrar(PluginRegistrar &registrar)
{

}

void ClientWrapperDemoPlugin::onMethodCall(const MethodCall &call)
{
  unimplemented(call);
}

void ClientWrapperDemoPlugin::unimplemented(const MethodCall &call)
{
  call.SendSuccessResponse(nullptr);
}

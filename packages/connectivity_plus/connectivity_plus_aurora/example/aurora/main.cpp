/**
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <flutter/flutter_aurora.h>
#include <flutter/flutter_compatibility_qt.h> // <- Add for Qt
#include "generated_plugin_registrant.h"

int main(int argc, char *argv[]) {
    aurora::Initialize(argc, argv);
    aurora::EnableQtCompatibility(); // <- Enable Qt
    aurora::RegisterPlugins();
    aurora::Launch();
    return 0;
}

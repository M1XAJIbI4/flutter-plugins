/*
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_HELPER_H
#define FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_HELPER_H

#include <QByteArray>
#include <QImage>

#include "data.h"

namespace Helper {
QImage GetImage() {
  QByteArray data = QByteArray::fromBase64(Base64::image_150x150);
  QImage image = QImage::fromData(data, "PNG");
  return image.convertToFormat(QImage::Format_RGBA8888);
}
} // namespace Helper

#endif /* FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_HELPER_H */

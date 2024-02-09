/**
 * SPDX-FileCopyrightText: 2023 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef FLUTTER_PLUGIN_SENSORS_PLUS_AURORA_PLUGIN_H
#define FLUTTER_PLUGIN_SENSORS_PLUS_AURORA_PLUGIN_H

#include <flutter/plugin-interface.h>
#include <sensors_plus_aurora/globals.h>

#include <QAccelerometer>
#include <QAmbientLightSensor>
#include <QCompass>
#include <QGyroscope>
#include <QMagnetometer>
#include <QOrientationSensor>
#include <QProximitySensor>
#include <QRotationSensor>
#include <QTapSensor>
#include <QtCore>

class PLUGIN_EXPORT SensorsPlusAuroraPlugin final : public QObject, public PluginInterface
{
    Q_OBJECT

public:
    void RegisterWithRegistrar(PluginRegistrar &registrar) override;

public slots:
    void EventSensorOrientation();
    void EventSensorAccelerometer();
    void EventSensorCompass();
    void EventSensorTap();
    void EventSensorALS();
    void EventSensorProximity();
    void EventSensorRotation();
    void EventSensorMagnetometer();
    void EventSensorGyroscope();

private:
    void EventChannelNull(const std::string &channel);
    void EventChannelData(const std::string &channel, const Encodable::List &result);

    void EnableSensorOrientation();
    void DisableSensorOrientation();

    void EnableSensorAccelerometer();
    void DisableSensorAccelerometer();

    void EnableSensorCompass();
    void DisableSensorCompass();

    void EnableSensorTap();
    void DisableSensorTap();

    void EnableSensorALS();
    void DisableSensorALS();

    void EnableSensorProximity();
    void DisableSensorProximity();

    void EnableSensorRotation();
    void DisableSensorRotation();

    void EnableSensorMagnetometer();
    void DisableSensorMagnetometer();

    void EnableSensorGyroscope();
    void DisableSensorGyroscope();

private:
    QScopedPointer<QOrientationSensor> m_orientation;
    QScopedPointer<QAccelerometer> m_accelerometer;
    QScopedPointer<QCompass> m_compass;
    QScopedPointer<QTapSensor> m_tap;
    QScopedPointer<QAmbientLightSensor> m_ambientLight;
    QScopedPointer<QProximitySensor> m_proximity;
    QScopedPointer<QRotationSensor> m_rotation;
    QScopedPointer<QMagnetometer> m_magnetometer;
    QScopedPointer<QGyroscope> m_gyroscope;
};

#endif /* FLUTTER_PLUGIN_SENSORS_PLUS_AURORA_PLUGIN_H */

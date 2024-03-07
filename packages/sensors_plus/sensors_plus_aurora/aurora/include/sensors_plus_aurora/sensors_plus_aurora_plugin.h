/**
 * SPDX-FileCopyrightText: 2023 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef FLUTTER_PLUGIN_SENSORS_PLUS_AURORA_PLUGIN_H
#define FLUTTER_PLUGIN_SENSORS_PLUS_AURORA_PLUGIN_H

#include <sensors_plus_aurora/globals.h>

#include <flutter/plugin_registrar.h>
#include <flutter/event_channel.h>
#include <flutter/encodable_value.h>
#include <flutter/standard_method_codec.h>
#include <flutter/event_stream_handler_functions.h>

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

typedef flutter::Plugin Plugin;
typedef flutter::PluginRegistrar PluginRegistrar;
typedef flutter::EncodableValue EncodableValue;
typedef flutter::EncodableList EncodableList;
typedef flutter::EventChannel<EncodableValue> EventChannel;
typedef flutter::EventSink<EncodableValue> EventSink;

class PLUGIN_EXPORT SensorsPlusAuroraPlugin final
    : public QObject
    , public flutter::Plugin
{
    Q_OBJECT

public:
    static void RegisterWithRegistrar(PluginRegistrar* registrar);

    enum SensorType
    {
        ORIENTATION,
        ACCELEROMETER,
        COMPASS,
        TAP,
        ALS,
        PROXIMITY,
        ROTATION,
        MAGNETOMETER,
        GYROSCOPE,
    };

private:
    // Creates a plugin that communicates on the given channel.
    SensorsPlusAuroraPlugin(
        std::unique_ptr<EventChannel> eventChannelOrientation,
        std::unique_ptr<EventChannel> eventChannelAccelerometer,
        std::unique_ptr<EventChannel> eventChannelCompass,
        std::unique_ptr<EventChannel> eventChannelTap,
        std::unique_ptr<EventChannel> eventChannelAmbientLight,
        std::unique_ptr<EventChannel> eventChannelProximity,
        std::unique_ptr<EventChannel> eventChannelRotation,
        std::unique_ptr<EventChannel> eventChannelMagnetometer,
        std::unique_ptr<EventChannel> eventChannelGyroscope
    );

    // Methods register handlers channels
    void RegisterStreamHandler(
        QSensor* sensor,
        SensorType sensorType,
        std::unique_ptr<EventChannel> eventChannel
    );

    // Other methods
    void onEventChannelSend(SensorType sensorType);
    void onEventChannelSaveSink(SensorType sensorType, std::unique_ptr<EventSink> events);

    std::unique_ptr<QOrientationSensor> m_sensorOrientation;
    std::unique_ptr<QAccelerometer> m_sensorAccelerometer;
    std::unique_ptr<QCompass> m_sensorCompass;
    std::unique_ptr<QTapSensor> m_sensorTap;
    std::unique_ptr<QAmbientLightSensor> m_sensorAmbientLight;
    std::unique_ptr<QProximitySensor> m_sensorProximity;
    std::unique_ptr<QRotationSensor> m_sensorRotation;
    std::unique_ptr<QMagnetometer> m_sensorMagnetometer;
    std::unique_ptr<QGyroscope> m_sensorGyroscope;

    std::unique_ptr<EventSink> m_sinkOrientation;
    std::unique_ptr<EventSink> m_sinkAccelerometer;
    std::unique_ptr<EventSink> m_sinkCompass;
    std::unique_ptr<EventSink> m_sinkTap;
    std::unique_ptr<EventSink> m_sinkAmbientLight;
    std::unique_ptr<EventSink> m_sinkProximity;
    std::unique_ptr<EventSink> m_sinkRotation;
    std::unique_ptr<EventSink> m_sinkMagnetometer;
    std::unique_ptr<EventSink> m_sinkGyroscope;
};

#endif /* FLUTTER_PLUGIN_SENSORS_PLUS_AURORA_PLUGIN_H */

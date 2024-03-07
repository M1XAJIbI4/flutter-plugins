/**
 * SPDX-FileCopyrightText: 2023 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <sensors_plus_aurora/sensors_plus_aurora_plugin.h>

namespace Channels {
    constexpr auto Orientation = "sensors_plus_aurora_orientationsensor";
    constexpr auto Accelerometer = "sensors_plus_aurora_accelerometersensor";
    constexpr auto Compass = "sensors_plus_aurora_compasssensor";
    constexpr auto Tap = "sensors_plus_aurora_tapsensor";
    constexpr auto ALS = "sensors_plus_aurora_alssensor";
    constexpr auto Proximity = "sensors_plus_aurora_proximitysensor";
    constexpr auto Rotation = "sensors_plus_aurora_rotationsensor";
    constexpr auto Magnetometer = "sensors_plus_aurora_magnetometersensor";
    constexpr auto Gyroscope = "sensors_plus_aurora_gyroscope";
} // namespace Channels

void SensorsPlusAuroraPlugin::RegisterWithRegistrar(PluginRegistrar* registrar)
{
    // Create plugin
    std::unique_ptr<SensorsPlusAuroraPlugin> plugin(new SensorsPlusAuroraPlugin(
        std::move(std::make_unique<EventChannel>(
        registrar->messenger(), Channels::Orientation,
        &flutter::StandardMethodCodec::GetInstance())),
        std::move(std::make_unique<EventChannel>(
        registrar->messenger(), Channels::Accelerometer,
        &flutter::StandardMethodCodec::GetInstance())),
        std::move(std::make_unique<EventChannel>(
        registrar->messenger(), Channels::Compass,
        &flutter::StandardMethodCodec::GetInstance())),
        std::move(std::make_unique<EventChannel>(
        registrar->messenger(), Channels::Tap,
        &flutter::StandardMethodCodec::GetInstance())),
        std::move(std::make_unique<EventChannel>(
        registrar->messenger(), Channels::ALS,
        &flutter::StandardMethodCodec::GetInstance())),
        std::move(std::make_unique<EventChannel>(
        registrar->messenger(), Channels::Proximity,
        &flutter::StandardMethodCodec::GetInstance())),
        std::move(std::make_unique<EventChannel>(
        registrar->messenger(), Channels::Rotation,
        &flutter::StandardMethodCodec::GetInstance())),
        std::move(std::make_unique<EventChannel>(
        registrar->messenger(), Channels::Magnetometer,
        &flutter::StandardMethodCodec::GetInstance())),
        std::move(std::make_unique<EventChannel>(
        registrar->messenger(), Channels::Gyroscope,
        &flutter::StandardMethodCodec::GetInstance()))
    ));

    // Register plugin
    registrar->AddPlugin(std::move(plugin));
}

SensorsPlusAuroraPlugin::SensorsPlusAuroraPlugin(
    std::unique_ptr<EventChannel> eventChannelOrientation,
    std::unique_ptr<EventChannel> eventChannelAccelerometer,
    std::unique_ptr<EventChannel> eventChannelCompass,
    std::unique_ptr<EventChannel> eventChannelTap,
    std::unique_ptr<EventChannel> eventChannelAmbientLight,
    std::unique_ptr<EventChannel> eventChannelProximity,
    std::unique_ptr<EventChannel> eventChannelRotation,
    std::unique_ptr<EventChannel> eventChannelMagnetometer,
    std::unique_ptr<EventChannel> eventChannelGyroscope
): m_sensorOrientation(std::make_unique<QOrientationSensor>()),
   m_sensorAccelerometer(std::make_unique<QAccelerometer>()),
   m_sensorCompass(std::make_unique<QCompass>()),
   m_sensorTap(std::make_unique<QTapSensor>()),
   m_sensorAmbientLight(std::make_unique<QAmbientLightSensor>()),
   m_sensorProximity(std::make_unique<QProximitySensor>()),
   m_sensorRotation(std::make_unique<QRotationSensor>()),
   m_sensorMagnetometer(std::make_unique<QMagnetometer>()),
   m_sensorGyroscope(std::make_unique<QGyroscope>())
{
    // Create StreamHandler QOrientationSensor
    connect(
        m_sensorOrientation.get(),
        &QOrientationSensor::readingChanged,
        [=]() { onEventChannelSend(SensorType::ORIENTATION); }
    );
    connect(
        m_sensorAccelerometer.get(),
        &QAccelerometer::readingChanged,
        [=]() { onEventChannelSend(SensorType::ACCELEROMETER); }
    );
    connect(
        m_sensorCompass.get(),
        &QCompass::readingChanged,
        [=]() { onEventChannelSend(SensorType::COMPASS); }
    );
    connect(
        m_sensorTap.get(),
        &QTapSensor::readingChanged,
        [=]() { onEventChannelSend(SensorType::TAP); }
    );
    connect(
        m_sensorAmbientLight.get(),
        &QAmbientLightSensor::readingChanged,
        [=]() { onEventChannelSend(SensorType::ALS); }
    );
    connect(
        m_sensorProximity.get(),
        &QProximitySensor::readingChanged,
        [=]() { onEventChannelSend(SensorType::PROXIMITY); }
    );
    connect(
        m_sensorRotation.get(),
        &QRotationSensor::readingChanged,
        [=]() { onEventChannelSend(SensorType::ROTATION); }
    );
    connect(
        m_sensorMagnetometer.get(),
        &QMagnetometer::readingChanged,
        [=]() { onEventChannelSend(SensorType::MAGNETOMETER); }
    );
    connect(
        m_sensorGyroscope.get(),
        &QGyroscope::readingChanged,
        [=]() { onEventChannelSend(SensorType::GYROSCOPE); }
    );

    RegisterStreamHandler(
        m_sensorOrientation.get(),
        SensorType::ORIENTATION,
        std::move(eventChannelOrientation)
    );
    RegisterStreamHandler(
        m_sensorAccelerometer.get(),
        SensorType::ACCELEROMETER,
        std::move(eventChannelAccelerometer)
    );
    RegisterStreamHandler(
        m_sensorCompass.get(),
        SensorType::COMPASS,
        std::move(eventChannelCompass)
    );
    RegisterStreamHandler(
        m_sensorTap.get(),
        SensorType::TAP,
        std::move(eventChannelTap)
    );
    RegisterStreamHandler(
        m_sensorAmbientLight.get(),
        SensorType::ALS,
        std::move(eventChannelAmbientLight)
    );
    RegisterStreamHandler(
        m_sensorProximity.get(),
        SensorType::PROXIMITY,
        std::move(eventChannelProximity)
    );
    RegisterStreamHandler(
        m_sensorRotation.get(),
        SensorType::ROTATION,
        std::move(eventChannelRotation)
    );
    RegisterStreamHandler(
        m_sensorMagnetometer.get(),
        SensorType::MAGNETOMETER,
        std::move(eventChannelMagnetometer)
    );
    RegisterStreamHandler(
        m_sensorGyroscope.get(),
        SensorType::GYROSCOPE,
        std::move(eventChannelGyroscope)
    );
}

void SensorsPlusAuroraPlugin::RegisterStreamHandler(
    QSensor* sensor,
    SensorType sensorType,
    std::unique_ptr<EventChannel> eventChannel
) {
    auto handler = std::make_unique<flutter::StreamHandlerFunctions<EncodableValue>>(
        [&, sensor, sensorType](const EncodableValue*,
            std::unique_ptr<flutter::EventSink<EncodableValue>>&& events
        ) -> std::unique_ptr<flutter::StreamHandlerError<EncodableValue>> {
            onEventChannelSaveSink(sensorType, std::move(events));
            sensor->start();
            return nullptr;
        },
        [&, sensor](const EncodableValue*) -> std::unique_ptr<flutter::StreamHandlerError<EncodableValue>> {
            sensor->start();
            return nullptr;
        }
    );

    eventChannel->SetStreamHandler(std::move(handler));
}

void SensorsPlusAuroraPlugin::onEventChannelSaveSink(
    SensorType sensorType,
    std::unique_ptr<EventSink> events
) {
    switch (sensorType)
    {
    case SensorType::ORIENTATION:
        m_sinkOrientation = std::move(events);
        break;
    case SensorType::ACCELEROMETER:
        m_sinkAccelerometer = std::move(events);
        break;
    case SensorType::COMPASS:
        m_sinkCompass = std::move(events);
        break;
    case SensorType::TAP:
        m_sinkTap = std::move(events);
        break;
    case SensorType::ALS:
        m_sinkAmbientLight = std::move(events);
        break;
    case SensorType::PROXIMITY:
        m_sinkProximity = std::move(events);
        break;
    case SensorType::ROTATION:
        m_sinkRotation = std::move(events);
        break;
    case SensorType::MAGNETOMETER:
        m_sinkMagnetometer = std::move(events);
        break;
    case SensorType::GYROSCOPE:
        m_sinkGyroscope = std::move(events);
        break;
    default:
        break;
    }
}

void SensorsPlusAuroraPlugin::onEventChannelSend(SensorType sensorType)
{
    switch (sensorType)
    {
    case SensorType::ORIENTATION:
        m_sinkOrientation->Success(EncodableList({
            (int) m_sensorOrientation->reading()->orientation()
        }));
        break;
    case SensorType::ACCELEROMETER:
        m_sinkAccelerometer->Success(EncodableList({
            (double) m_sensorAccelerometer->reading()->x(),
            (double) m_sensorAccelerometer->reading()->y(),
            (double) m_sensorAccelerometer->reading()->z()
        }));
        break;
    case SensorType::COMPASS:
        m_sinkCompass->Success(EncodableList({
            (double) m_sensorCompass->reading()->azimuth(),
            (double) m_sensorCompass->reading()->calibrationLevel()
        }));
        break;
    case SensorType::TAP:
        m_sinkTap->Success(EncodableList({
            (int) m_sensorTap->reading()->tapDirection(),
            m_sensorTap->reading()->isDoubleTap()
        }));
        break;
    case SensorType::ALS:
        m_sinkAmbientLight->Success(EncodableList({
            (int) m_sensorAmbientLight->reading()->lightLevel()
        }));
        break;
    case SensorType::PROXIMITY:
        m_sinkProximity->Success(EncodableList({
            m_sensorProximity->reading()->close()
        }));
        break;
    case SensorType::ROTATION:
        m_sinkRotation->Success(EncodableList({
            (double) m_sensorRotation->reading()->x(),
            (double) m_sensorRotation->reading()->y(),
            (double) m_sensorRotation->reading()->z()
        }));
        break;
    case SensorType::MAGNETOMETER:
        m_sinkMagnetometer->Success(EncodableList({
            (double) m_sensorMagnetometer->reading()->x(),
            (double) m_sensorMagnetometer->reading()->y(),
            (double) m_sensorMagnetometer->reading()->z()
        }));
        break;
    case SensorType::GYROSCOPE:
        m_sinkGyroscope->Success(EncodableList({
            (double) m_sensorGyroscope->reading()->x(),
            (double) m_sensorGyroscope->reading()->y(),
            (double) m_sensorGyroscope->reading()->z()
        }));
        break;
    default:
        break;
    }
}

#include "moc_sensors_plus_aurora_plugin.cpp"

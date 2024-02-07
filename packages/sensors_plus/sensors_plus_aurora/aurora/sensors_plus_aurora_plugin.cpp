/**
 * SPDX-FileCopyrightText: 2023 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <flutter/method-channel.h>
#include <sensors_plus_aurora/sensors_plus_aurora_plugin.h>

namespace KeyChannel {
constexpr auto Orientation = "sensors_plus_aurora_orientationsensor";
constexpr auto Accelerometer = "sensors_plus_aurora_accelerometersensor";
constexpr auto Compass = "sensors_plus_aurora_compasssensor";
constexpr auto Tap = "sensors_plus_aurora_tapsensor";
constexpr auto ALS = "sensors_plus_aurora_alssensor";
constexpr auto Proximity = "sensors_plus_aurora_proximitysensor";
constexpr auto Rotation = "sensors_plus_aurora_rotationsensor";
constexpr auto Magnetometer = "sensors_plus_aurora_magnetometersensor";
constexpr auto Gyroscope = "sensors_plus_aurora_gyroscope";
} // namespace KeyChannel

namespace KeySensor {
constexpr auto Orientation = "orientationsensor";
constexpr auto Accelerometer = "accelerometersensor";
constexpr auto Compass = "compasssensor";
constexpr auto Tap = "tapsensor";
constexpr auto ALS = "alssensor";
constexpr auto Proximity = "proximitysensor";
constexpr auto Rotation = "rotationsensor";
constexpr auto Magnetometer = "magnetometersensor";
constexpr auto Gyroscope = "gyroscopesensor";
} // namespace KeySensor

void SensorsPlusAuroraPlugin::RegisterWithRegistrar(PluginRegistrar &registrar)
{
    registrar.RegisterEventChannel(
        KeyChannel::Orientation,
        MethodCodecType::Standard,
        [this](const Encodable &) {
            EnableSensorOrientation();
            return EventResponse();
        },
        [this](const Encodable &) {
            DisableSensorOrientation();
            return EventResponse();
        });

    registrar.RegisterEventChannel(
        KeyChannel::Accelerometer,
        MethodCodecType::Standard,
        [this](const Encodable &) {
            EnableSensorAccelerometer();
            return EventResponse();
        },
        [this](const Encodable &) {
            DisableSensorAccelerometer();
            return EventResponse();
        });

    registrar.RegisterEventChannel(
        KeyChannel::Compass,
        MethodCodecType::Standard,
        [this](const Encodable &) {
            EnableSensorCompass();
            return EventResponse();
        },
        [this](const Encodable &) {
            DisableSensorCompass();
            return EventResponse();
        });

    registrar.RegisterEventChannel(
        KeyChannel::Tap,
        MethodCodecType::Standard,
        [this](const Encodable &) {
            EnableSensorTap();
            return EventResponse();
        },
        [this](const Encodable &) {
            DisableSensorTap();
            return EventResponse();
        });

    registrar.RegisterEventChannel(
        KeyChannel::ALS,
        MethodCodecType::Standard,
        [this](const Encodable &) {
            EnableSensorALS();
            return EventResponse();
        },
        [this](const Encodable &) {
            DisableSensorALS();
            return EventResponse();
        });

    registrar.RegisterEventChannel(
        KeyChannel::Proximity,
        MethodCodecType::Standard,
        [this](const Encodable &) {
            EnableSensorProximity();
            return EventResponse();
        },
        [this](const Encodable &) {
            DisableSensorProximity();
            return EventResponse();
        });

    registrar.RegisterEventChannel(
        KeyChannel::Rotation,
        MethodCodecType::Standard,
        [this](const Encodable &) {
            EnableSensorRotation();
            return EventResponse();
        },
        [this](const Encodable &) {
            DisableSensorRotation();
            return EventResponse();
        });

    registrar.RegisterEventChannel(
        KeyChannel::Magnetometer,
        MethodCodecType::Standard,
        [this](const Encodable &) {
            EnableSensorMagnetometer();
            return EventResponse();
        },
        [this](const Encodable &) {
            DisableSensorMagnetometer();
            return EventResponse();
        });

    registrar.RegisterEventChannel(
        KeyChannel::Gyroscope,
        MethodCodecType::Standard,
        [this](const Encodable &) {
            EnableSensorGyroscope();
            return EventResponse();
        },
        [this](const Encodable &) {
            DisableSensorGyroscope();
            return EventResponse();
        });
}

void SensorsPlusAuroraPlugin::EventChannelNull(const std::string &channel)
{
    EventChannel(channel, MethodCodecType::Standard).SendEvent(nullptr);
}

void SensorsPlusAuroraPlugin::EventChannelData(const std::string &channel,
                                               const Encodable::List &result)
{
    EventChannel(channel, MethodCodecType::Standard).SendEvent(result);
}

/**
 * Orientation
 */
void SensorsPlusAuroraPlugin::EnableSensorOrientation()
{
    if (!m_orientation) {
        m_orientation.reset(new QOrientationSensor());

        connect(m_orientation.data(), &QOrientationSensor::readingChanged,
                this, &SensorsPlusAuroraPlugin::EventSensorOrientation);
    }

    if (m_orientation->start()) {
        EventSensorOrientation();
    } else {
        EventChannelNull(KeyChannel::Orientation);
    }
}

void SensorsPlusAuroraPlugin::DisableSensorOrientation()
{
    if (m_orientation) {
        m_orientation->stop();
    }
}

void SensorsPlusAuroraPlugin::EventSensorOrientation()
{
    if (m_orientation) {
        EventChannelData(KeyChannel::Orientation,
                         Encodable::List{(int) m_orientation->reading()->orientation()});
    }
}

/**
 * Accelerometer
 */
void SensorsPlusAuroraPlugin::EnableSensorAccelerometer()
{
    if (!m_accelerometer) {
        m_accelerometer.reset(new QAccelerometer());

        connect(m_accelerometer.data(), &QAccelerometer::readingChanged,
                this, &SensorsPlusAuroraPlugin::EventSensorAccelerometer);
    }

    if (m_accelerometer->start()) {
        EventSensorAccelerometer();
    } else {
        EventChannelNull(KeyChannel::Accelerometer);
    }
}

void SensorsPlusAuroraPlugin::DisableSensorAccelerometer()
{
    if (m_accelerometer) {
        m_accelerometer->stop();
    }
}

void SensorsPlusAuroraPlugin::EventSensorAccelerometer()
{
    if (m_accelerometer) {
        EventChannelData(KeyChannel::Accelerometer,
                         Encodable::List{(double) m_accelerometer->reading()->x(),
                                         (double) m_accelerometer->reading()->y(),
                                         (double) m_accelerometer->reading()->z()});
    }
}

/**
 * Compass
 */
void SensorsPlusAuroraPlugin::EnableSensorCompass()
{
    if (!m_compass) {
        m_compass.reset(new QCompass());

        connect(m_compass.data(), &QCompass::readingChanged,
                this, &SensorsPlusAuroraPlugin::EventSensorCompass);
    }

    if (m_compass->start()) {
        EventSensorCompass();
    } else {
        EventChannelNull(KeyChannel::Compass);
    }
}

void SensorsPlusAuroraPlugin::DisableSensorCompass()
{
    if (m_compass) {
        m_compass->stop();
    }
}

void SensorsPlusAuroraPlugin::EventSensorCompass()
{
    if (m_compass) {
        EventChannelData(KeyChannel::Compass,
                         Encodable::List{(double) m_compass->reading()->azimuth(),
                                         (double) m_compass->reading()->calibrationLevel()});
    }
}

/**
 * Tap
 */
void SensorsPlusAuroraPlugin::EnableSensorTap()
{
    if (!m_tap) {
        m_tap.reset(new QTapSensor());

        connect(m_tap.data(), &QTapSensor::readingChanged,
                this, &SensorsPlusAuroraPlugin::EventSensorTap);
    }

    if (m_tap->start()) {
        EventSensorTap();
    } else {
        EventChannelNull(KeyChannel::Tap);
    }
}

void SensorsPlusAuroraPlugin::DisableSensorTap()
{
    if (m_tap) {
        m_tap->stop();
    }
}

void SensorsPlusAuroraPlugin::EventSensorTap()
{
    if (m_tap) {
        EventChannelData(KeyChannel::Tap,
                         Encodable::List{(int) m_tap->reading()->tapDirection(),
                                         m_tap->reading()->isDoubleTap()});
    }
}

/**
 * ALS
 */
void SensorsPlusAuroraPlugin::EnableSensorALS()
{
    if (!m_ambientLight) {
        m_ambientLight.reset(new QAmbientLightSensor());

        connect(m_ambientLight.data(), &QAmbientLightSensor::readingChanged,
                this, &SensorsPlusAuroraPlugin::EventSensorALS);
    }

    if (m_ambientLight->start()) {
        EventSensorALS();
    } else {
        EventChannelNull(KeyChannel::ALS);
    }
}

void SensorsPlusAuroraPlugin::DisableSensorALS()
{
    if (m_ambientLight) {
        m_ambientLight->stop();
    }
}

void SensorsPlusAuroraPlugin::EventSensorALS()
{
    if (m_ambientLight) {
        EventChannelData(KeyChannel::ALS,
                         Encodable::List{(int) m_ambientLight->reading()->lightLevel()});
    }
}

/**
 * Proximity
 */
void SensorsPlusAuroraPlugin::EnableSensorProximity()
{
    if (!m_proximity) {
        m_proximity.reset(new QProximitySensor());

        connect(m_proximity.data(), &QProximitySensor::readingChanged,
                this, &SensorsPlusAuroraPlugin::EventSensorProximity);
    }

    if (m_proximity->start()) {
        EventSensorProximity();
    } else {
        EventChannelNull(KeyChannel::Proximity);
    }
}

void SensorsPlusAuroraPlugin::DisableSensorProximity()
{
    if (m_proximity) {
        m_proximity->stop();
    }
}

void SensorsPlusAuroraPlugin::EventSensorProximity()
{
    if (m_proximity) {
        EventChannelData(KeyChannel::Proximity, Encodable::List{m_proximity->reading()->close()});
    }
}

/**
 * Rotation
 */
void SensorsPlusAuroraPlugin::EnableSensorRotation()
{
    if (!m_rotation) {
        m_rotation.reset(new QRotationSensor());

        connect(m_rotation.data(), &QRotationSensor::readingChanged,
                this, &SensorsPlusAuroraPlugin::EventSensorRotation);
    }

    if (m_rotation->start()) {
        EventSensorRotation();
    } else {
        EventChannelNull(KeyChannel::Rotation);
    }
}

void SensorsPlusAuroraPlugin::DisableSensorRotation()
{
    if (m_rotation) {
        m_rotation->stop();
    }
}

void SensorsPlusAuroraPlugin::EventSensorRotation()
{
    if (m_rotation) {
        EventChannelData(KeyChannel::Rotation,
                         Encodable::List{(double) m_accelerometer->reading()->x(),
                                         (double) m_accelerometer->reading()->y(),
                                         (double) m_accelerometer->reading()->z()});
    }
}

/**
 * Magnetometer
 */
void SensorsPlusAuroraPlugin::EnableSensorMagnetometer()
{
    if (!m_magnetometer) {
        m_magnetometer.reset(new QMagnetometer());

        connect(m_magnetometer.data(), &QMagnetometer::readingChanged,
                this, &SensorsPlusAuroraPlugin::EventSensorMagnetometer);
    }

    if (m_magnetometer->start()) {
        EventSensorMagnetometer();
    } else {
        EventChannelNull(KeyChannel::Magnetometer);
    }
}

void SensorsPlusAuroraPlugin::DisableSensorMagnetometer()
{
    if (m_magnetometer) {
        m_magnetometer->stop();
    }
}

void SensorsPlusAuroraPlugin::EventSensorMagnetometer()
{
    if (m_magnetometer) {
        EventChannelData(KeyChannel::Magnetometer,
                         Encodable::List{(double) m_accelerometer->reading()->x(),
                                         (double) m_accelerometer->reading()->y(),
                                         (double) m_accelerometer->reading()->z()});
    }
}

/**
 * Gyroscope
 */
void SensorsPlusAuroraPlugin::EnableSensorGyroscope()
{
    if (!m_gyroscope) {
        m_gyroscope.reset(new QGyroscope());

        connect(m_gyroscope.data(), &QGyroscope::readingChanged,
                this, &SensorsPlusAuroraPlugin::EventSensorGyroscope);
    }

    if (m_gyroscope->start()) {
        EventSensorGyroscope();
    } else {
        EventChannelNull(KeyChannel::Gyroscope);
    }
}

void SensorsPlusAuroraPlugin::DisableSensorGyroscope()
{
    if (m_gyroscope) {
        m_gyroscope->stop();
    }
}

void SensorsPlusAuroraPlugin::EventSensorGyroscope()
{
    if (m_gyroscope) {
        EventChannelData(KeyChannel::Gyroscope,
                         Encodable::List{(double) m_accelerometer->reading()->x(),
                                         (double) m_accelerometer->reading()->y(),
                                         (double) m_accelerometer->reading()->z()});
    }
}

#include "moc_sensors_plus_aurora_plugin.cpp"

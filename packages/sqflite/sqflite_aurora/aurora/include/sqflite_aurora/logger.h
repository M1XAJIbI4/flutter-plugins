/**
 * SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef FLUTTER_PLUGIN_SQFLITE_LOGGER_H
#define FLUTTER_PLUGIN_SQFLITE_LOGGER_H

#include <flutter/flutter_logger.h>
#include <sqflite_aurora/globals.h>
#include <string>

class PLUGIN_EXPORT Logger final
{
public:
    enum Level {
        None = 0,
        Sql,
        Verbose,
    };

public:
    Logger(Level level, const std::string &tag);

    Level logLevel() const;
    void setLogLevel(Level level);

    std::string tag() const;
    void setTag(const std::string &tag);

    std::ostream &verb();
    std::ostream &sql();

private:
    Level m_level;
    std::string m_tag;
    std::ostream m_devnull;
};

#endif /* FLUTTER_PLUGIN_SQFLITE_LOGGER_H */

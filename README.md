# Плагины для ОС Аврора

![preview.png](documentation/data/preview.png)

Этот репозиторий содержит плагины Flutter для платформы ОС Аврора. Мы находимся в процессе создания необходимых плагинов для разработки всевозможных приложений пользователей. Если плагин который вы ищете еще не реализован для ОС Аврора оставьте сообщение в [issue](https://gitlab.com/omprussia/flutter/flutter-plugins/-/issues) либо рассмотрите возможность создать пакет самостоятельно. Мы будем рады вашим мерж-реквестам!

## Разработка плагина для ОС Аврора

Что бы создать платформо-зависимый плагин воспользуйтесь [Flutter SDK](https://gitlab.com/omprussia/flutter/flutter) с поддержкой ОС Аврора.  Для платформы Аврора доступно четыре варианта создания плагина, все они перечислены ниже с примерами:

- [Dart package](documentation/dart_package.md);
- [Plugin package](documentation/plugin_package.md);
- [Qt plugin package](documentation/qt_plugin_package.md);
- [FFI Plugin package](documentation/ffi_plugin_package.md).

Подробно процесс создания платформо-зависимых плагинов можно найти в статье "[Flutter на ОС Аврора](https://habr.com/ru/articles/761176/)". Если остаются вопросы присоединяйтесь к сообществу ОС Аврора "[Aurora Developers](https://t.me/aurora_devs)" в Telegram, там вы сможете задать вопрос по Flutter и следить за новостями.

## Демонстрационное приложение

![preview.png](documentation/data/preview_app.png)

Все плагины имеют общее демонстрационное приложение **Flutter example packages**. Оно предназначено для демонстрации работы как платформо-зависимых так и нет плагинов/пакетов. Выполняет роль единого приложения-примера для платформо-зависимых плагинов и позволяет проверить работоспособность не платформо зависимых плагинов на платформе ОС Аврора. [Подробее](example/README.md).

## Платформо-зависимые плагины Flutter

Список платформо-зависимых плагинов созданных для ОС Аврора либо зависящих от платформо-зависимых плагинов ОС Аврора.

| Плагин ОС Аврора                                                                                                                                                                 | Версия   | Внешний плагин                                                                      | Версия      | Версия ОС Аврора |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|-------------------------------------------------------------------------------------|-------------|------------------|
| [camera_aurora](https://gitlab.com/omprussia/flutter/flutter-plugins/-/tree/master/packages/camera/camera_aurora)                                                                | `0.0.1`  | [camera](https://pub.dev/packages/camera)                                           | `0.10.5+5`  | `4.0.2.269`      |
| [battery_plus_aurora](https://gitlab.com/omprussia/flutter/flutter-plugins/-/tree/master/packages/battery_plus/battery_plus_aurora)                                              | `0.0.1`  | [battery_plus](https://pub.dev/packages/battery_plus)                               | `4.0.2`     | `4.0.2.269`      |
| [device_info_plus_aurora](https://gitlab.com/omprussia/flutter/flutter-plugins/-/tree/master/packages/device_info_plus/device_info_plus_aurora)                                  | `0.0.1`  | [device_info_plus](https://pub.dev/packages/device_info_plus)                       | `9.0.3`     | `4.0.2.269`      |
| [flutter_keyboard_visibility_aurora](https://gitlab.com/omprussia/flutter/flutter-plugins/-/tree/master/packages/flutter_keyboard_visibility/flutter_keyboard_visibility_aurora) | `0.0.1`  | [flutter_keyboard_visibility](https://pub.dev/packages/flutter_keyboard_visibility) | `5.4.1`     | `4.0.2.269`      | 
| [flutter_local_notifications_aurora](https://gitlab.com/omprussia/flutter/flutter-plugins/-/tree/master/packages/flutter_local_notifications/flutter_local_notifications_aurora) | `0.0.1`  | [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) | `15.1.1`    | `4.0.2.269`      |
| [flutter_secure_storage_aurora](https://gitlab.com/omprussia/flutter/flutter-plugins/-/tree/master/packages/flutter_secure_storage/flutter_secure_storage_aurora)                | `0.0.1`  | [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)           | `9.0.0`     | `4.0.2.269`      |
| [package_info_plus_aurora](https://gitlab.com/omprussia/flutter/flutter-plugins/-/tree/master/packages/package_info_plus/package_info_plus_aurora)                               | `0.0.1`  | [package_info_plus](https://pub.dev/packages/package_info_plus)                     | `4.1.0`     | `4.0.2.269`      |
| [path_provider_aurora](https://gitlab.com/omprussia/flutter/flutter-plugins/-/tree/master/packages/path_provider/path_provider_aurora)                                           | `0.0.1`  | [path_provider](https://pub.dev/packages/path_provider)                             | `2.1.1`     | `4.0.2.269`      |
| [sensors_plus_aurora](https://gitlab.com/omprussia/flutter/flutter-plugins/-/tree/master/packages/sensors_plus/sensors_plus_aurora)                                              | `0.0.1`  | [sensors_plus](https://pub.dev/packages/sensors_plus)                               | `3.1.0`     | `4.0.2.269`      |
| [shared_preferences_aurora](https://gitlab.com/omprussia/flutter/flutter-plugins/-/tree/master/packages/shared_preferences/shared_preferences_aurora)                            | `0.0.1`  | [shared_preferences](https://pub.dev/packages/shared_preferences)                   | `2.1.2`     | `4.0.2.269`      |
| [sqflite_aurora](https://gitlab.com/omprussia/flutter/flutter-plugins/-/tree/master/packages/sqflite/sqflite_aurora)                                                             | `0.0.1`  | [sqflite](https://pub.dev/packages/sqflite)                                         | `2.3.0`     | `4.0.2.269`      |
| [wakelock_plus_aurora](https://gitlab.com/omprussia/flutter/flutter-plugins/-/tree/master/packages/wakelock_plus/wakelock_plus_aurora)                                           | `0.0.1`  | [wakelock_plus](https://pub.dev/packages/wakelock_plus)                             | `1.1.1`     | `4.0.2.269`      |
| [xdga_directories](https://gitlab.com/omprussia/flutter/flutter-plugins/-/tree/master/packages/xdga_directories)                                                                 | `0.0.1`  | -                                                                                   | -           | `4.0.2.269`      |
| -                                                                                                                                                                                | -        | [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager)             | `3.3.1`     | `4.0.2.269`      |
| -                                                                                                                                                                                | -        | [cached_network_image](https://pub.dev/packages/cached_network_image)               | `3.3.0`     | `4.0.2.269`      |
| -                                                                                                                                                                                | -        | [google_fonts](https://pub.dev/packages/google_fonts)                               | `6.1.0`     | `4.0.2.269`      |

## Пакеты Flutter

Список проверенных на совместимость и работоспособность в ОС Аврора пакетов Flutter не являющиеся платформо-зависимыми.

| Внешний плагин                                                                      | Версия     | Версия ОС Аврора   |
|-------------------------------------------------------------------------------------|------------|--------------------|
| [crypto](https://pub.dev/packages/crypto)                                           | `3.0.3`    | `4.0.2.269`        |
| [cupertino_icons](https://pub.dev/packages/cupertino_icons)                         | `1.0.6`    | `4.0.2.269`        |
| [get_it](https://pub.dev/packages/get_it)                                           | `7.6.4`    | `4.0.2.269`        |
| [intl](https://pub.dev/packages/intl)                                               | `0.18.1`   | `4.0.2.269`        |
| [photo_view](https://pub.dev/packages/photo_view)                                   | `0.14.0`   | `4.0.2.269`        |
| [scoped_model](https://pub.dev/packages/scoped_model)                               | `2.0.0`    | `4.0.2.269`        |
| [dartz](https://pub.dev/packages/dartz)                                             | `0.10.1`   | `4.0.2.269`        |
| [freezed](https://pub.dev/packages/freezed)                                         | `2.4.3`    | `4.0.2.269`        |
| [equatable](https://pub.dev/packages/equatable)                                     | `2.0.5`    | `4.0.2.269`        |
| [flutter_markdown](https://pub.dev/packages/flutter_markdown)                       | `0.6.17+4` | `4.0.2.269`        |
| [build_runner](https://pub.dev/packages/build_runner)                               | `2.4.6`    | `4.0.2.269`        |
| [freezed_annotation](https://pub.dev/packages/freezed_annotation)                   | `2.4.1`    | `4.0.2.269`        |
| [json_annotation](https://pub.dev/packages/json_annotation)                         | `4.8.1`    | `4.0.2.269`        |
| [json_serializable](https://pub.dev/packages/json_serializable)                     | `6.7.1`    | `4.0.2.269`        |
| [provider](https://pub.dev/packages/provider)                                       | `6.0.5`    | `4.0.2.269`        |
| [qr_flutter](https://pub.dev/packages/qr_flutter)                                   | `4.1.0`    | `4.0.2.269`        |
| [rxdart](https://pub.dev/packages/rxdart)                                           | `0.27.7`   | `4.0.2.269`        |

## Вклад

Этот проект поддерживается сообществом, и мы будем рады вашему вкладу и активности, оставляйте ваши вопросы, отзывы в [issue](https://gitlab.com/omprussia/flutter/flutter-plugins/-/issues) либо вашу работу в [мерж-реквесты](https://gitlab.com/omprussia/flutter/flutter-plugins/-/merge_requests). Помните что **Flutter example packages** содержит не только сложные платформо-зависимые плагины, мы будем рады вкладу в проверку на работоспособность платформо не зависимых плагинов.

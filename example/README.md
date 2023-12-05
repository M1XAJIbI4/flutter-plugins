# Flutter example packages

Приложение демонстрирует работу как платформо-зависимых так и нет плагинов/пакетов. Выполняет роль единого приложения-примера для платформо-зависимых плагинов и позволяет проверить работоспособность не платформо зависимых плагинов на платформе ОС Аврора.

## Сборка

```shell
# Добавьте псевдоним, если он еще не существует.
alias flutter-aurora=$HOME/.local/opt/flutter/bin/flutter

# Получить зависимости
flutter-aurora pub get

# Создание интернационализации
flutter-aurora pub run build_runner build

# Запустить сборку
flutter-aurora build aurora --release # [--release|--debug|--profile]
```

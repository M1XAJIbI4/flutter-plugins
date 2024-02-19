# flutter_local_notifications_aurora

The Aurora implementation of [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications).

## Usage

This package is not an _endorsed_ implementation of `flutter_local_notifications`.
Therefore, you have to include `flutter_local_notifications_aurora` alongside `flutter_local_notifications` as dependencies in your `pubspec.yaml` file.

**pubspec.yaml**

```yaml
dependencies:
  flutter_local_notifications: ^14.1.1
  flutter_local_notifications_aurora:
    git:
      url: https://gitlab.com/omprussia/flutter/flutter-plugins.git
      ref: flutter_local_notifications_aurora-0.0.1
      path: packages/flutter_local_notifications/flutter_local_notifications_aurora
```

***.dart**

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notificationID = 1;

final FlutterLocalNotificationsPlugin notification = FlutterLocalNotificationsPlugin();

await flutterLocalNotificationsPlugin.show(
  notificationID,
  "Title notification",
  "My long body text notification",
  null,
);

await flutterLocalNotificationsPlugin.cancel(notificationID);
```

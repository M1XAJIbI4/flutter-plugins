# flutter_secure_storage_aurora

The Aurora implementation of [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage).

## Usage

This package is not an _endorsed_ implementation of `flutter_secure_storage`. 
Therefore, you have to include `flutter_secure_storage_aurora` alongside `flutter_secure_storage` as dependencies in your `pubspec.yaml` file.

**pubspec.yaml**

```yaml
dependencies:
  flutter_secure_storage: ^8.0.0
  flutter_secure_storage_aurora:
    git:
      url: https://gitlab.com/omprussia/flutter/flutter-plugins.git
      ref: flutter-aurora-3.3.10
      path: packages/flutter_secure_storage/flutter_secure_storage_aurora
```

***.dart**

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage_aurora/flutter_secure_storage_aurora.dart';

// https://pub.dev/packages/encrypt
// Encrypter(AES(key))
// secure-random --length 16 --base 16
// You can generate a secret key based on user data, as an example of a hash pincode
FlutterSecureStorageAurora.setSecret('5872747ed1ceda363808efb8b2b18b20');

final storage = const FlutterSecureStorage();

const key = 'my_key';
const data = 'Something secret';

// Write value
await storage.write(key: key, value: data);

// Read value
String? value = await storage.read(key: key);

// Read all values
Map<String, String> allValues = await storage.readAll();

// Delete all
await storage.deleteAll();
```

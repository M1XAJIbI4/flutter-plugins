# connectivity_plus_aurora

The Aurora implementation of [`connectivity_plus`](https://pub.dev/packages/connectivity_plus).

## Usage

This package is not an _endorsed_ implementation of `connectivity_plus`.
Therefore, you have to include `connectivity_plus_aurora` alongside `connectivity_plus` as dependencies in your `pubspec.yaml` file.

**pubspec.yaml**

```yaml
dependencies:
  connectivity_plus: ^5.0.2
  connectivity_plus_aurora:
    git:
      url: https://gitlab.com/omprussia/flutter/flutter-plugins.git
      ref: @todo add tag plugin
      path: packages/connectivity_plus/connectivity_plus_aurora
```

***main.cpp**

```desktop
#include <flutter/application.h>
#include <flutter/flutter_compatibility_qt.h> // <- Add for Qt
#include "generated_plugin_registrant.h"

int main(int argc, char *argv[]) {
    aurora::Initialize(argc, argv);
    aurora::EnableQtCompatibility(); // <- Enable Qt
    aurora::RegisterPlugins();
    aurora::Launch();
    return 0;
}
```

***.desktop**

```desktop
Permissions=Internet
```
***.spec**

```spec
BuildRequires: pkgconfig(Qt5Network)
```

***.dart**

```dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus_aurora/connectivity_plus_aurora.dart';

final connectivityResult = await (Connectivity().checkConnectivity());

if (connectivityResult == ConnectivityResult.mobile) {
  // I am connected to a mobile network.
} else if (connectivityResult == ConnectivityResult.wifi) {
  // I am connected to a wifi network.
} else if (connectivityResult == ConnectivityResult.ethernet) {
  // I am connected to a ethernet network.
} else if (connectivityResult == ConnectivityResult.vpn) {
  // Note: This result is not supported on Aurora OS yet
} else if (connectivityResult == ConnectivityResult.bluetooth) {
  // I am connected to a bluetooth.
} else if (connectivityResult == ConnectivityResult.other) {
  // I am connected to a network which is not in the above mentioned networks.
} else if (connectivityResult == ConnectivityResult.none) {
  // I am not connected to any network.
}
```

```dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus_aurora/connectivity_plus_aurora.dart';

@override
initState() {
  super.initState();

  subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    // Got a new connectivity status!
  });
}

// Be sure to cancel subscription after you are done
@override
dispose() {
  subscription.cancel();
  super.dispose();
}
```

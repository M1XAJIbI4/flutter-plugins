# google_fonts

Plugin support [google_fonts](https://pub.dev/packages/google_fonts).

The use of the `google_fonts` plugin in the Aurora OS ecosystem is supported.
The plugin depends on a platform-dependent plugin, that is, it itself is platform-dependent.
But implementation is not required.

## Usage

You have to include `path_provider` & `path_provider_aurora`
alongside `google_fonts` as dependencies in your `pubspec.yaml` file.

**pubspec.yaml**

```yaml
dependencies:
  google_fonts: ^6.1.0
  path_provider: ^2.0.15
  path_provider_aurora:
    git:
      url: https://gitlab.com/omprussia/flutter/flutter-plugins.git
      ref: path_provider_aurora-0.0.1
      path: packages/path_provider/path_provider_aurora
```

***.desktop**

```desktop
Permissions=UserDirs;Internet
```

***.dart**

```dart
/// Import GoogleFonts
import 'package:google_fonts/google_fonts.dart';

/// To use GoogleFonts with the default TextStyle
Text(
    'This is Google Fonts',
    style: GoogleFonts.lato(),
);
```


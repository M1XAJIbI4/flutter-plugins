// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:path/path.dart' as p;

extension ExtUint8List on Uint8List {
  Future<File> writeToFile(Directory directory, XFile file) {
    if (file.name.isEmpty) {
      return File(p.join(
              directory.path, '${DateTime.now().millisecondsSinceEpoch}.jpg'))
          .writeAsBytes(this);
    } else {
      return File(p.join(directory.path, file.name)).writeAsBytes(this);
    }
  }
}

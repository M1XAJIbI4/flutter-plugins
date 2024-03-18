// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FlutterCacheManagerImpl {
  String url = 'https://static.tildacdn.com/tild3531-3361-4438-b333-323661366430/_.PNG';
  StreamController<Stream<FileResponse>?> fileStreamController = StreamController();

  void setNewUrl(String? newUrl) {
    if (newUrl != null) {
      if (newUrl.isNotEmpty) url = newUrl;
    }
  }

  /// Method that
  void downloadFile() {
    Stream<FileResponse> data = DefaultCacheManager().getFileStream(url, withProgress: true);
    fileStreamController.add(data);
  }

  void clearCache() {
    DefaultCacheManager().emptyCache();
    fileStreamController.add(null);
  }

  void removeFile() {
    DefaultCacheManager().removeFile(url).then((value) {
      if (kDebugMode) {
        print('File removed');
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
    fileStreamController.add(null);
  }
}

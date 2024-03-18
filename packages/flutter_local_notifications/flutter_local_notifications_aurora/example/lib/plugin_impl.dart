// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Main features of the plugin flutter_local_notifications
class PluginImpl {
  /// Default notification ID
  final notificationID = 1;

  /// Get instance secure flutter_local_notification
  final _notification = FlutterLocalNotificationsPlugin();

  /// Show local notification
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    // Cansel if already run
    await _notification.cancel(notificationID);
    // Show notification
    await _notification.show(
      notificationID,
      title,
      body,
      null,
    );
  }
}

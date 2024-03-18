// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Main features of the plugin Local Notifications
class PluginImpl {
  final FlutterLocalNotificationsPlugin notification = FlutterLocalNotificationsPlugin();

  final notificationID = 1;

  /// Error
  String? _error;

  /// Public error
  String? get error => _error;

  /// Public is error
  bool get isError => _error != null;

  /// Show local notification
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    try {
      // Cansel if already run
      await notification.cancel(notificationID);
      // Show notification
      await notification.show(
        notificationID,
        title,
        body,
        null,
      );
    } catch (e) {
      _error = e.toString();
    }
  }
}

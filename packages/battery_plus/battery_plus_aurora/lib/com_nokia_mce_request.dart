// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:dbus/dbus.dart';

class ComNokiaMceRequest extends DBusRemoteObject {
  ComNokiaMceRequest(DBusClient client, String destination,
      {DBusObjectPath path =
          const DBusObjectPath.unchecked('/com/nokia/mce/request')})
      : super(client, name: destination, path: path);

  /// Invokes com.nokia.mce.request.get_psm_state()
  Future<bool> callget_psm_state(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod('com.nokia.mce.request', 'get_psm_state', [],
        replySignature: DBusSignature('b'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asBoolean();
  }

  /// Invokes com.nokia.mce.request.get_battery_level()
  Future<int> callget_battery_level(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod(
        'com.nokia.mce.request', 'get_battery_level', [],
        replySignature: DBusSignature('i'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    final level = result.returnValues[0].asInt32();
    return level < 0 ? 100 : level;
  }

  /// Invokes com.nokia.mce.request.get_charger_state()
  Future<String> callget_charger_state(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod(
        'com.nokia.mce.request', 'get_charger_state', [],
        replySignature: DBusSignature('s'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asString();
  }
}

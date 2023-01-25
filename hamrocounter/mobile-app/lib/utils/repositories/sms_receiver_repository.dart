import 'dart:async';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsStreamRepository {
  Permission permission = Permission.sms;
  static const EventChannel _channel = EventChannel('com.truenary.hamrocounter.dev.app/smsStream');

  // TODO(Atom): If possible replace Stream<dynamic> with Stream<String>
  Stream<dynamic> smsStream() async* {
    yield* _channel.receiveBroadcastStream();
  }

  Future<bool> getPermission() async {
    if (await permission.status == PermissionStatus.granted) {
      return true;
    } else {
      if (await permission.request() == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}

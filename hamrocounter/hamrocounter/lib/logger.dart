
import 'package:flutter/material.dart';

class Logger {

  void logError(Object error, StackTrace stackTrace, String current) {
    // ignore: todo
    // TODO: use crashlytics
    print('>>>>>> Error Start <<<<<<');
    print(current);
    print(error.toString());
    debugPrintStack(stackTrace: stackTrace);
    print('>>>>>> Error End <<<<<<');
  }

  void logFlutterError(FlutterErrorDetails details, String current) {
    // ignore: todo
    // TODO: use crashlytics
    print('>>>>>> Error Start <<<<<<');
    print(details.toString());
    print('>>>>>> Error End <<<<<<');
  }
}
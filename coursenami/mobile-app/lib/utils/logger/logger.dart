import 'dart:developer';
import 'package:flutter/widgets.dart';

class Logger{
  void logError(Object error, StackTrace stackTrace, String current){
    log('>>>>>> Error Start <<<<<<');
    log(current);
    log(error.toString());
    debugPrintStack(stackTrace: stackTrace);
    log('>>>>>> Error End <<<<<<');
  }

  void logFlutterError(FlutterErrorDetails details, String current){
    log('>>>>>> Error Start <<<<<<');
    log(details.toString());
    log('>>>>>> Error End <<<<<<');
  }
}

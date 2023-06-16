import 'dart:async';

import 'package:flutter/services.dart';

class YourPluginName {
  static const MethodChannel _channel = MethodChannel('getKeyBoardData');

  static final StreamController<String> _stickerStreamController =
      StreamController<String>.broadcast();

  static Stream<String> get stickerStream => _stickerStreamController.stream;

  static Future<void> initialize() async {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'helloFromNativeCode':
        _channel.invokeMethod('helloFromNativeCode');
        // String stickerData = call.arguments['stickerData'];
        // _stickerStreamController.add(stickerData);
        break;
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: 'Method ${call.method} is not implemented.');
    }
  }
}

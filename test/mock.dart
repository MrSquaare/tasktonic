import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void mockPathProviderChannel(String path) {
  const channel = MethodChannel('plugins.flutter.io/path_provider');

  handler(MethodCall methodCall) async {
    return path;
  }

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, handler);
}

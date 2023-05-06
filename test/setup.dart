import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktonic/models/adapters.dart';
import 'package:tasktonic/repositories/boxes.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

void mockPathProvider() {
  const channel = MethodChannel('plugins.flutter.io/path_provider');

  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    return './.dart_tool/flutter_test/${uuid.v4()}';
  });
}

Future<void> setUpAllTestEnv() async {
  final directory = Directory('./.dart_tool/flutter_test');

  if (await directory.exists()) {
    await directory.delete(recursive: true);
  }

  await directory.create(recursive: true);
}

Future<void> setupTestEnv() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  mockPathProvider();
  SharedPreferences.setMockInitialValues({});

  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter('hive');

  registerAdapters();
  await openBoxes();
}

Future<void> tearDownTestEnv() async {
  await Hive.deleteFromDisk();
}

Future<void> tearDownAllTestEnv() async {
  final directory = Directory('./.dart_tool/flutter_test');

  if (await directory.exists()) {
    await directory.delete(recursive: true);
  }
}

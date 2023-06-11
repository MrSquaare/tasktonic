import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

Directory getTestDirectory() {
  final randomUuid = uuid.v4();
  final directory = Directory('./.dart_tool/flutter_test/$randomUuid');

  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  return directory;
}

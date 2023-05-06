import 'package:hive/hive.dart';

import '../models/task.dart';

void registerAdapters() {
  Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(TaskAdapter());
}

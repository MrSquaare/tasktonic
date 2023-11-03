import 'package:hive/hive.dart';

import '../models/task.dart';
import 'rrule.dart';

void registerAdapters() {
  Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(RecurrenceRuleAdapter());
}

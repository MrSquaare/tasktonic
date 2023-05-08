import 'package:hive/hive.dart';

import '../models/task.dart';

Future<void> openBoxes() async {
  await Hive.openBox<Task>('tasks');
}

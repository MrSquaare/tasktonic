import 'package:hive/hive.dart';

import '../models/task.dart';

class TaskRepository {
  final Box<Task> _box = Hive.box<Task>('tasks');

  Iterable<Task> list() {
    return _box.values;
  }

  Future<int> create(Task task) async {
    return _box.add(task);
  }

  Task? read(int index) {
    return _box.getAt(index);
  }

  Future<void> update(int index, Task task) async {
    return _box.putAt(index, task);
  }

  Future<void> delete(int index) async {
    return _box.deleteAt(index);
  }
}

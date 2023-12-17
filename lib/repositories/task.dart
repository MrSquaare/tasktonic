import 'package:hive/hive.dart';

import '../models/task.dart';

class TaskRepository {
  final Box<Task> _box = Hive.box<Task>('tasks');

  Map<dynamic, Task> map() {
    return _box.toMap();
  }

  Future<void> create(Task task) async {
    return _box.put(task.id, task);
  }

  Task? read(String id) {
    return _box.get(id);
  }

  Future<void> update(String id, Task task) async {
    if (!_box.containsKey(id)) throw ArgumentError('Task not found');

    task.id = id;

    return _box.put(id, task);
  }

  Future<void> delete(String id) async {
    if (!_box.containsKey(id)) throw ArgumentError('Task not found');

    return _box.delete(id);
  }
}

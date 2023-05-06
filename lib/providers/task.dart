import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../repositories/task.dart';

class TaskNotifier extends AsyncNotifier<Iterable<Task>> {
  TaskNotifier(this.repository) : super();

  final TaskRepository repository;

  @override
  FutureOr<Iterable<Task>> build() {
    return repository.list();
  }

  Future<void> createTask(Task task) async {
    state = await AsyncValue.guard(() async {
      await repository.create(task);

      return repository.list();
    });
  }

  Future<void> toggleTask(int index, Task task) async {
    state = await AsyncValue.guard(() async {
      task.toggle();

      await repository.update(index, task);

      return repository.list();
    });
  }

  Future<void> updateTask(int index, Task task) async {
    state = await AsyncValue.guard(() async {
      await repository.update(index, task);

      return repository.list();
    });
  }

  Future<void> deleteTask(int index) async {
    state = await AsyncValue.guard(() async {
      await repository.delete(index);

      return repository.list();
    });
  }
}

final taskProvider = AsyncNotifierProvider<TaskNotifier, Iterable<Task>>(
  () {
    return TaskNotifier(TaskRepository());
  },
);

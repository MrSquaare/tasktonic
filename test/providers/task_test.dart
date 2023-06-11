import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/providers/task.dart';

import '../__helpers__/utility.dart';

void main() {
  Directory? testDirectory;

  setUpAll(() async {
    testDirectory = getTestDirectory();

    Hive.registerAdapter(TaskStatusAdapter());
    Hive.registerAdapter(TaskAdapter());
    Hive.init(testDirectory!.path);
  });

  setUp(() async {
    await Hive.openBox<Task>('tasks');
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk('tasks');
  });

  tearDownAll(() async {
    testDirectory!.deleteSync(recursive: true);
  });

  test(
    'Should have no task',
    () async {
      final container = ProviderContainer();
      final tasks = container.read(taskProvider);

      expect(tasks.requireValue.length, 0);
    },
  );

  test(
    'Should have one task',
    () async {
      final box = Hive.box<Task>('tasks');

      await box.add(
        Task(
          name: 'Task 1',
          description: 'Description 1',
        ),
      );

      final container = ProviderContainer();
      final tasks = container.read(taskProvider);

      expect(tasks.requireValue.length, 1);
    },
  );

  test(
    'Should create a task',
    () async {
      final box = Hive.box<Task>('tasks');

      final container = ProviderContainer();
      final taskNotifier = container.read(taskProvider.notifier);

      await taskNotifier.createTask(
        Task(
          name: 'Task 1',
          description: 'Description 1',
        ),
      );

      expect(box.length, 1);
      expect(box.values.first.name, 'Task 1');
      expect(box.values.first.description, 'Description 1');
      expect(box.values.first.status, TaskStatus.todo);
    },
  );

  test(
    'Should toggle a task',
    () async {
      final box = Hive.box<Task>('tasks');

      await box.add(
        Task(
          name: 'Task 1',
          description: 'Description 1',
        ),
      );

      expect(box.values.first.status, TaskStatus.todo);

      final container = ProviderContainer();
      final taskNotifier = container.read(taskProvider.notifier);

      await taskNotifier.toggleTask(0, box.values.elementAt(0));

      expect(box.length, 1);
      expect(box.values.first.name, 'Task 1');
      expect(box.values.first.description, 'Description 1');
      expect(box.values.first.status, TaskStatus.done);
    },
  );

  test(
    'Should update a task',
    () async {
      final box = Hive.box<Task>('tasks');

      await box.add(
        Task(
          name: 'Task 1',
          description: 'Description 1',
        ),
      );

      expect(box.values.first.status, TaskStatus.todo);

      final container = ProviderContainer();
      final taskNotifier = container.read(taskProvider.notifier);

      await taskNotifier.updateTask(
        0,
        Task(
          name: 'Task A',
          description: 'Description A',
          status: TaskStatus.done,
        ),
      );

      expect(box.length, 1);
      expect(box.values.first.name, 'Task A');
      expect(box.values.first.description, 'Description A');
      expect(box.values.first.status, TaskStatus.done);
    },
  );

  test(
    'Should delete a task',
    () async {
      final box = Hive.box<Task>('tasks');

      await box.add(
        Task(
          name: 'Task 1',
          description: 'Description 1',
        ),
      );

      final container = ProviderContainer();
      final taskNotifier = container.read(taskProvider.notifier);

      await taskNotifier.deleteTask(0);

      expect(box.length, 0);
    },
  );
}

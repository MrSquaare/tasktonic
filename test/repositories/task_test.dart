import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/repositories/task.dart';

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
      final repository = TaskRepository();

      expect(repository.list().isEmpty, true);
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

      final repository = TaskRepository();

      expect(repository.list().length, 1);
    },
  );

  test(
    'Should create a task',
    () async {
      final box = Hive.box<Task>('tasks');

      final repository = TaskRepository();

      await repository.create(
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
    'Should read a task',
    () async {
      final box = Hive.box<Task>('tasks');

      await box.add(
        Task(
          name: 'Task 1',
          description: 'Description 1',
        ),
      );

      final repository = TaskRepository();

      final task = repository.read(0);

      expect(task!, isNotNull);
      expect(task.name, 'Task 1');
      expect(task.description, 'Description 1');
      expect(task.status, TaskStatus.todo);
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

      final repository = TaskRepository();

      await repository.update(
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

      expect(box.values.first.status, TaskStatus.todo);

      final repository = TaskRepository();

      await repository.delete(0);

      expect(box.length, 0);
    },
  );
}

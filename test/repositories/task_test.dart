import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tasktonic/models/adapters.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/repositories/task.dart';

import '../__helpers__/utility.dart';

void main() {
  Directory? testDirectory;

  setUpAll(() async {
    testDirectory = getTestDirectory();

    registerAdapters();
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

      expect(repository.map().isEmpty, true);
    },
  );

  test(
    'Should have one task',
    () async {
      final box = Hive.box<Task>('tasks');
      final task = Task(
        name: 'Task 1',
        description: 'Description 1',
        dateStr: '2021-01-01',
      );

      await box.put(task.id, task);

      final repository = TaskRepository();

      expect(repository.map().length, 1);
    },
  );

  test(
    'Should create a task',
    () async {
      final box = Hive.box<Task>('tasks');
      final task = Task(
        name: 'Task 1',
        description: 'Description 1',
        dateStr: '2021-01-01',
      );

      final repository = TaskRepository();

      await repository.create(task);

      expect(box.length, 1);
      expect(box.values.first.name, 'Task 1');
      expect(box.values.first.description, 'Description 1');
      expect(box.values.first.status, TaskStatus.todo);
      expect(box.values.first.dateStr, '2021-01-01');
      expect(box.values.first.date, DateTime(2021, 1, 1));
    },
  );

  test(
    'Should read a task',
    () async {
      final box = Hive.box<Task>('tasks');
      final boxTask = Task(
        name: 'Task 1',
        description: 'Description 1',
        dateStr: '2021-01-01',
      );

      await box.put(boxTask.id, boxTask);

      final repository = TaskRepository();

      final task = repository.read(boxTask.id);

      expect(task!, isNotNull);
      expect(task.name, 'Task 1');
      expect(task.description, 'Description 1');
      expect(task.status, TaskStatus.todo);
      expect(task.dateStr, '2021-01-01');
      expect(task.date, DateTime(2021, 1, 1));
    },
  );

  test(
    'Should update a task',
    () async {
      final box = Hive.box<Task>('tasks');
      final boxTask = Task(
        name: 'Task 1',
        description: 'Description 1',
        dateStr: '2021-01-01',
      );

      await box.put(boxTask.id, boxTask);

      expect(box.values.first.status, TaskStatus.todo);

      final repository = TaskRepository();

      await repository.update(
        boxTask.id,
        Task(
          name: 'Task A',
          description: 'Description A',
          status: TaskStatus.done,
          dateStr: '2022-01-01',
        ),
      );

      expect(box.length, 1);
      expect(box.values.first.id, boxTask.id);
      expect(box.values.first.name, 'Task A');
      expect(box.values.first.description, 'Description A');
      expect(box.values.first.status, TaskStatus.done);
      expect(box.values.first.dateStr, '2022-01-01');
      expect(box.values.first.date, DateTime(2022, 1, 1));
    },
  );

  test(
    'Should delete a task',
    () async {
      final box = Hive.box<Task>('tasks');
      final boxTask = Task(
        name: 'Task 1',
        description: 'Description 1',
        dateStr: '2021-01-01',
      );

      await box.put(boxTask.id, boxTask);

      expect(box.values.first.status, TaskStatus.todo);

      final repository = TaskRepository();

      await repository.delete(boxTask.id);

      expect(box.length, 0);
    },
  );

  test(
    'Should throw an error when updating a task that does not exist',
    () async {
      final repository = TaskRepository();

      expect(
        () async => await repository.update(
          'invalid-id',
          Task(
            name: 'Task A',
            description: 'Description A',
            status: TaskStatus.done,
            dateStr: '2022-01-01',
          ),
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'Should throw an error when deleting a task that does not exist',
    () async {
      final repository = TaskRepository();

      expect(
        () async => await repository.delete('invalid-id'),
        throwsArgumentError,
      );
    },
  );
}

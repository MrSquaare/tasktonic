import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tasktonic/models/adapters.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/providers/task.dart';

import '../__helpers__/utility.dart';

class MockAwesomeNotificationsPlatform extends Mock
    implements AwesomeNotificationsPlatform, MockPlatformInterfaceMixin {
  @override
  Future<bool> createNotification({
    required NotificationContent? content,
    NotificationSchedule? schedule,
    List<NotificationActionButton>? actionButtons,
    Map<String, NotificationLocalization>? localizations,
  }) {
    return super.noSuchMethod(
      Invocation.method(#createNotification, [], {
        #content: content,
        #schedule: schedule,
        #actionButtons: actionButtons,
        #localizations: localizations,
      }),
      returnValueForMissingStub: Future<bool>.value(true),
      returnValue: Future<bool>.value(true),
    );
  }

  @override
  Future<void> cancel(int? id) {
    return super.noSuchMethod(
      Invocation.method(#cancel, [id]),
      returnValueForMissingStub: Future<void>.value(),
      returnValue: Future<void>.value(),
    );
  }
}

void main() {
  Directory? testDirectory;
  final mock = MockAwesomeNotificationsPlatform();

  setUpAll(() async {
    testDirectory = getTestDirectory();

    registerAdapters();
    Hive.init(testDirectory!.path);
  });

  setUp(() async {
    AwesomeNotificationsPlatform.instance = mock;
    await Hive.openBox<Task>('tasks');
  });

  tearDown(() async {
    AwesomeNotificationsPlatform.resetInstance();
    reset(mock);
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
      final task = Task(
        name: 'Task 1',
        description: 'Description 1',
        dateStr: '2021-01-01',
      );

      await box.put(task.id, task);

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
          dateStr: '2021-01-01',
        ),
      );

      expect(box.length, 1);
      expect(box.values.first.name, 'Task 1');
      expect(box.values.first.description, 'Description 1');
      expect(box.values.first.status, TaskStatus.todo);
      expect(box.values.first.dateStr, '2021-01-01');
      expect(box.values.first.date, DateTime(2021, 1, 1));
    },
  );

  test(
    'Should toggle a task',
    () async {
      final box = Hive.box<Task>('tasks');
      final task = Task(
        name: 'Task 1',
        description: 'Description 1',
        dateStr: '2021-01-01',
      );

      await box.put(task.id, task);

      expect(box.values.first.status, TaskStatus.todo);

      final container = ProviderContainer();
      final taskNotifier = container.read(taskProvider.notifier);

      await taskNotifier.toggleTask(task.id, task);

      expect(box.length, 1);
      expect(box.values.first.name, 'Task 1');
      expect(box.values.first.description, 'Description 1');
      expect(box.values.first.status, TaskStatus.done);
      expect(box.values.first.dateStr, '2021-01-01');
      expect(box.values.first.date, DateTime(2021, 1, 1));
    },
  );

  test(
    'Should update a task',
    () async {
      final box = Hive.box<Task>('tasks');
      final task = Task(
        name: 'Task 1',
        description: 'Description 1',
        dateStr: '2021-01-01',
      );

      await box.put(task.id, task);

      expect(box.values.first.status, TaskStatus.todo);

      final container = ProviderContainer();
      final taskNotifier = container.read(taskProvider.notifier);

      await taskNotifier.updateTask(
        task.id,
        Task(
          name: 'Task A',
          description: 'Description A',
          status: TaskStatus.done,
          dateStr: '2022-01-01',
        ),
      );

      expect(box.length, 1);
      expect(box.values.first.id, task.id);
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
      final task = Task(
        name: 'Task 1',
        description: 'Description 1',
        dateStr: '2021-01-01',
      );

      await box.put(task.id, task);

      final container = ProviderContainer();
      final taskNotifier = container.read(taskProvider.notifier);

      await taskNotifier.deleteTask(task.id);

      expect(box.length, 0);
    },
  );

  test('Should call AwesomeNotification().createNotification', () async {
    final container = ProviderContainer();
    final taskNotifier = container.read(taskProvider.notifier);

    final task = Task(
      name: 'Test Task',
      description: 'This is a test task',
      dateStr: '2021-01-01',
      reminderStr: '10:00',
    );

    taskNotifier.createTaskNotification(task);

    final localTimezone = DateTime.now().timeZoneName;

    verify(
      mock.createNotification(
        content: argThat(
          isA<NotificationContent>()
              .having((c) => c.id, 'id', task.id.hashCode)
              .having((c) => c.channelKey, 'channelKey', 'reminder_channel')
              .having((c) => c.title, 'title', task.name)
              .having((c) => c.body, 'body', task.description)
              .having(
                (c) => c.category,
                'category',
                NotificationCategory.Reminder,
              )
              .having((c) => c.wakeUpScreen, 'wakeUpScreen', true),
          named: 'content',
        ),
        schedule: argThat(
          isA<NotificationCalendar>()
              .having((c) => c.year, 'year', 2021)
              .having((c) => c.month, 'month', 1)
              .having((c) => c.day, 'day', 1)
              .having((c) => c.hour, 'hour', 10)
              .having((c) => c.minute, 'minute', 0)
              .having(
                (c) => c.timeZone,
                'timeZone',
                localTimezone,
              ),
          named: 'schedule',
        ),
      ),
    ).called(1);
  });

  test('Should call AwesomeNotification().cancel', () async {
    final container = ProviderContainer();
    final taskNotifier = container.read(taskProvider.notifier);

    taskNotifier.cancelTaskNotification('0');

    verify(
      mock.cancel(
        argThat(
          equals('0'.hashCode),
        ),
      ),
    ).called(1);
  });
}

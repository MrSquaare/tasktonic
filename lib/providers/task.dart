import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../repositories/task.dart';

class TaskNotifier extends AsyncNotifier<Map<dynamic, Task>> {
  TaskNotifier(this.repository) : super();

  final TaskRepository repository;

  @override
  FutureOr<Map<dynamic, Task>> build() {
    return repository.map();
  }

  Future<void> createTask(Task task) async {
    state = await AsyncValue.guard(() async {
      await repository.create(task);

      return repository.map();
    });
  }

  Future<void> toggleTask(String id, Task task) async {
    state = await AsyncValue.guard(() async {
      task.toggle();

      await repository.update(id, task);

      return repository.map();
    });
  }

  Future<void> updateTask(String id, Task task) async {
    state = await AsyncValue.guard(() async {
      await repository.update(id, task);

      return repository.map();
    });
  }

  Future<void> deleteTask(String id) async {
    state = await AsyncValue.guard(() async {
      await repository.delete(id);

      return repository.map();
    });
  }

  Future<void> createTaskNotification(Task task) async {
    final date = task.date;
    final reminder = task.reminder;

    if (reminder == null) return;

    final localTimezone = DateTime.now().timeZoneName;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: task.id.hashCode,
        channelKey: 'reminder_channel',
        title: task.name,
        body: task.description,
        category: NotificationCategory.Reminder,
        wakeUpScreen: true,
        payload: {
          'id': task.id,
          'reminder': task.reminderStr,
          'rrule': task.rrule?.toString(),
        },
      ),
      schedule: NotificationCalendar(
        year: date.year,
        month: date.month,
        day: date.day,
        hour: reminder.hour,
        minute: reminder.minute,
        timeZone: localTimezone,
      ),
    );
  }

  Future<void> cancelTaskNotification(String id) async {
    await AwesomeNotifications().cancel(id.hashCode);
  }
}

final taskProvider = AsyncNotifierProvider<TaskNotifier, Map<dynamic, Task>>(
  () {
    return TaskNotifier(TaskRepository());
  },
);

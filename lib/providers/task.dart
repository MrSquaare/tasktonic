import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../repositories/task.dart';
import '../utilities/date.dart';

class TaskNotifier extends AsyncNotifier<Iterable<Task>> {
  TaskNotifier(this.repository) : super();

  final TaskRepository repository;

  @override
  FutureOr<Iterable<Task>> build() {
    return repository.list();
  }

  Future<int> createTask(Task task) async {
    late int index;

    state = await AsyncValue.guard(() async {
      index = await repository.create(task);

      return repository.list();
    });

    return index;
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

  Future<void> createTaskNotification(int index, Task task) async {
    final date = dateStringToDateTime(task.date);
    final reminder = timeStringToDateTime(task.reminder);

    if (date == null || reminder == null) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: index,
        channelKey: 'reminder_channel',
        title: task.name,
        body: task.description,
        category: NotificationCategory.Reminder,
        wakeUpScreen: true,
      ),
      schedule: NotificationCalendar(
        year: date.year,
        month: date.month,
        day: date.day,
        hour: reminder.hour,
        minute: reminder.minute,
        timeZone: reminder.timeZoneName,
      ),
    );
  }

  Future<void> cancelTaskNotification(int index) async {
    await AwesomeNotifications().cancel(index);
  }
}

final taskProvider = AsyncNotifierProvider<TaskNotifier, Iterable<Task>>(
  () {
    return TaskNotifier(TaskRepository());
  },
);

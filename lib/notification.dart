import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';

import 'router.dart';
import 'utilities/date.dart';

final notificationEventBus = EventBus();

class NotificationDisplayedEvent {
  const NotificationDisplayedEvent({
    required this.receivedNotification,
  });

  final ReceivedNotification receivedNotification;
}

class NotificationActionReceivedEvent {
  const NotificationActionReceivedEvent({
    required this.receivedAction,
  });

  final ReceivedAction receivedAction;
}

class NotificationController {
  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    notificationEventBus.fire(
      NotificationDisplayedEvent(
        receivedNotification: receivedNotification,
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    notificationEventBus.fire(
      NotificationActionReceivedEvent(
        receivedAction: receivedAction,
      ),
    );
  }
}

class NotificationListenerWidget extends StatefulWidget {
  const NotificationListenerWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<NotificationListenerWidget> createState() =>
      _NotificationListenerWidgetState();
}

class _NotificationListenerWidgetState
    extends State<NotificationListenerWidget> {
  final notificationDisplayedStream =
      notificationEventBus.on<NotificationDisplayedEvent>();
  final actionReceivedStream =
      notificationEventBus.on<NotificationActionReceivedEvent>();

  @override
  void initState() {
    super.initState();
    notificationDisplayedStream.listen((event) {
      onNotificationDisplayedMethod(event.receivedNotification);
    });
    actionReceivedStream.listen((event) {
      onActionReceivedMethod(event.receivedAction);
    });
    AwesomeNotifications().setListeners(
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    if (receivedNotification.channelKey != 'reminder_channel') return;

    final taskId = receivedNotification.payload?['id'];
    final taskReminderStr = receivedNotification.payload?['reminder'];
    final taskRruleStr = receivedNotification.payload?['rrule'];

    if (taskId == null || taskReminderStr == null || taskRruleStr == null) {
      return;
    }

    final taskReminder = DateUtilities.parseTime(taskReminderStr);
    final taskRRule = RecurrenceRule.fromString(taskRruleStr);

    final currentDate = DateTime.now().copyWith(isUtc: true);
    final localTimezone = DateTime.now().timeZoneName;

    final nextDates = taskRRule.getInstances(
      start: currentDate,
      after: currentDate,
    );
    final nextDate = nextDates.firstOrNull;

    if (nextDate == null) return;

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: taskId.hashCode,
        channelKey: 'reminder_channel',
        title: receivedNotification.title,
        body: receivedNotification.body,
        category: NotificationCategory.Reminder,
        wakeUpScreen: true,
        payload: {
          'id': taskId,
          'reminder': taskReminderStr,
          'rrule': taskRruleStr,
        },
      ),
      schedule: NotificationCalendar(
        year: nextDate.year,
        month: nextDate.month,
        day: nextDate.day,
        hour: taskReminder.hour,
        minute: taskReminder.minute,
        timeZone: localTimezone,
      ),
    );
  }

  Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    if (receivedAction.channelKey != 'reminder_channel') return;

    final taskId = receivedAction.payload?['id'];

    if (taskId == null) return;

    MyAppRouter.instance.go('/task/$taskId/details');
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

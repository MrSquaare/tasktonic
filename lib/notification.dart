import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import 'router.dart';

final notificationEventBus = EventBus();

class NotificationActionReceivedEvent {
  const NotificationActionReceivedEvent({
    required this.receivedAction,
  });

  final ReceivedAction receivedAction;
}

class NotificationController {
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
  final actionReceivedStream =
      notificationEventBus.on<NotificationActionReceivedEvent>();

  @override
  void initState() {
    super.initState();
    actionReceivedStream.listen((event) {
      onActionReceivedMethod(event.receivedAction);
    });
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    if (receivedAction.channelKey == 'reminder_channel') {
      MyAppRouter.instance.go('/task/${receivedAction.id}/details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

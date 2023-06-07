import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

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
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

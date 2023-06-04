import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../models/task.dart';
import '../../utilities/task.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final reminderValue = task.reminder;
    final reminder =
        reminderValue != null ? convertUTCTimeToDateTime(reminderValue) : null;
    final reminderFormat = DateFormat.Hm();

    return <Widget>[
      Text(task.name).fontSize(24).bold(),
      Text(task.description ?? 'task_details.no_description'.tr())
          .padding(top: 8),
      if (reminder != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Chip(
            avatar: const Icon(Icons.notifications),
            label: Text(
              'task_details.reminder'.tr(
                namedArgs: {'time': reminderFormat.format(reminder)},
              ),
            ),
            backgroundColor: Colors.lightBlue,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.all(0),
          ),
        )
    ].toColumn(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

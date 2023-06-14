import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../models/task.dart';
import '../../utilities/date.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final date = dateStringToDateTime(task.date);
    final dateFormat = date != null && date.year == DateTime.now().year
        ? DateFormat.MMMMd(context.locale.toString())
        : DateFormat.yMMMMd(context.locale.toString());
    final reminder = timeStringToDateTime(task.reminder);
    final reminderFormat = DateFormat.Hm();

    return <Widget>[
      Text(task.name).fontSize(24).bold(),
      Text(task.description ?? 'task_details.no_description'.tr())
          .padding(top: 8),
      if (date != null || reminder != null)
        <Widget>[
          if (date != null)
            Chip(
              avatar: const Icon(Icons.calendar_month),
              label: Text(
                'task_details.date'.tr(
                  namedArgs: {'date': dateFormat.format(date)},
                ),
              ),
              backgroundColor: Colors.lightBlue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.all(0),
            ),
          if (reminder != null)
            Chip(
              avatar: const Icon(Icons.notifications),
              label: Text(
                'task_details.reminder'.tr(
                  namedArgs: {'time': reminderFormat.format(reminder)},
                ),
              ),
              backgroundColor: Colors.lightBlue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.all(0),
            )
        ]
            .toRow(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              separator: const SizedBox(width: 4),
            )
            .padding(top: 8),
    ].toColumn(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

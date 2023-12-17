import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../models/task.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final date = task.date;
    final dateFormat = date.year == DateTime.now().year
        ? DateFormat.MMMMd(context.locale.toString())
        : DateFormat.yMMMMd(context.locale.toString());
    final reminder = task.reminder;
    final reminderFormat = DateFormat.Hm();

    return <Widget>[
      Text(task.name).fontSize(24).bold(),
      Text(task.description ?? 'task_details.no_description'.tr())
          .padding(top: 8),
      <Widget?>[
        Chip(
          avatar: const Icon(
            Icons.calendar_month,
            color: Colors.white,
          ),
          label: Text(
            'task_details.date'.tr(
              namedArgs: {'date': dateFormat.format(date)},
            ),
          ),
          labelStyle: const TextStyle(color: Colors.white),
          backgroundColor: Colors.blue,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.all(0),
        ),
        (reminder != null)
            ? Chip(
                avatar: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                label: Text(
                  'task_details.reminder'.tr(
                    namedArgs: {'time': reminderFormat.format(reminder)},
                  ),
                ),
                labelStyle: const TextStyle(color: Colors.white),
                backgroundColor: Colors.blue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.all(0),
              )
            : null,
      ]
          .whereNotNull()
          .toList()
          .toRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            separator: const SizedBox(width: 4),
          )
          .padding(top: 8)
          .scrollable(scrollDirection: Axis.horizontal),
    ].toColumn(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

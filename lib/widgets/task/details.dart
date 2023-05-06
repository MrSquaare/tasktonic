import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../models/task.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Text(task.name).fontSize(24).bold().padding(bottom: 8),
      Text(task.description ?? "task_details.no_description".tr()),
    ].toColumn(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

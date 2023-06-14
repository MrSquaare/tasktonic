import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../models/task.dart';
import '../../utilities/date.dart';

typedef TaskListItemToggle = void Function(int index, Task task);
typedef TaskListItemNavigate = void Function(int index, Task task);

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.tasks,
    this.onToggle,
    this.onNavigate,
  });

  final Iterable<Task> tasks;
  final TaskListItemToggle? onToggle;
  final TaskListItemNavigate? onNavigate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: tasks.mapIndexed((index, task) {
        final date = dateStringToDateTime(task.date);
        final dateFormat = date != null && date.year == DateTime.now().year
            ? DateFormat.MMMd(context.locale.toString())
            : DateFormat.yMMMd(context.locale.toString());
        final reminder = timeStringToDateTime(task.reminder);
        final reminderFormat = DateFormat.Hm(context.locale.toString());

        return ListTile(
          leading: Icon(
            task.status == TaskStatus.done
                ? Icons.check_box
                : Icons.check_box_outline_blank,
          ),
          title: <Widget>[
            Text(task.name),
            if (date != null || reminder != null)
              <Widget>[
                if (date != null)
                  Chip(
                    avatar: const Icon(Icons.calendar_month),
                    label: Text(dateFormat.format(date)),
                    backgroundColor: Colors.lightBlue,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(0),
                  ),
                if (reminder != null)
                  Chip(
                    avatar: const Icon(Icons.notifications),
                    label: Text(reminderFormat.format(reminder)),
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
                  .padding(top: 4),
          ].toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          tileColor: index % 2 == 1 ? Colors.grey[200] : null,
          onTap: () {
            if (onToggle != null) onToggle!(index, task);
          },
          onLongPress: () {
            if (onNavigate != null) onNavigate!(index, task);
          },
        );
      }).toList(),
    );
  }
}

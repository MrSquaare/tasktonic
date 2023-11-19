import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../models/task.dart';

typedef TaskListItemToggle = void Function(Task task);
typedef TaskListItemNavigate = void Function(Task task);

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.tasks,
    this.onToggle,
    this.onNavigate,
    this.noTaskMessage = 'No task found',
  });

  final Iterable<Task> tasks;
  final TaskListItemToggle? onToggle;
  final TaskListItemNavigate? onNavigate;
  final String noTaskMessage;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(noTaskMessage),
      );
    }

    return ListView(
      children: tasks.mapIndexed((index, task) {
        final date = task.date;
        final dateFormat = date.year == DateTime.now().year
            ? DateFormat.MMMd(context.locale.toString())
            : DateFormat.yMMMd(context.locale.toString());
        final reminder = task.reminder;
        final reminderFormat = DateFormat.Hm(context.locale.toString());

        return ListTile(
          leading: Icon(
            task.status == TaskStatus.done
                ? Icons.check_box
                : Icons.check_box_outline_blank,
          ),
          title: <Widget>[
            Text(task.name),
            <Widget?>[
              Chip(
                avatar: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ),
                label: Text(dateFormat.format(date)),
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
                      label: Text(reminderFormat.format(reminder)),
                      labelStyle: const TextStyle(color: Colors.white),
                      backgroundColor: Colors.blue,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.all(0),
                    )
                  : null,
            ]
                .whereNotNull()
                .toList()
                .toWrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.start,
                  spacing: 4.0,
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
            if (onToggle != null) onToggle!(task);
          },
          onLongPress: () {
            if (onNavigate != null) onNavigate!(task);
          },
        );
      }).toList(),
    );
  }
}

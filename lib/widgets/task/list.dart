import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../models/task.dart';
import '../../providers/task.dart';
import '../../utilities/task.dart';

class TaskList extends ConsumerWidget {
  const TaskList({super.key, required this.tasks});

  final Iterable<Task> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: tasks.map((task) {
        final index = tasks.toList().indexOf(task);
        final reminderValue = task.reminder;
        final reminder = reminderValue != null
            ? convertUTCTimeToDateTime(reminderValue)
            : null;
        final reminderFormat = DateFormat.Hm();

        return ListTile(
          leading: Icon(
            task.status == TaskStatus.done
                ? Icons.check_box
                : Icons.check_box_outline_blank,
          ),
          title: <Widget>[
            Text(task.name),
            if (reminder != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Chip(
                  avatar: const Icon(Icons.notifications),
                  label: Text(reminderFormat.format(reminder)),
                  backgroundColor: Colors.lightBlue,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.all(0),
                ),
              )
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
            ref.read(taskProvider.notifier).toggleTask(index, task);
          },
          onLongPress: () {
            context.push('/task/$index');
          },
        );
      }).toList(),
    );
  }
}

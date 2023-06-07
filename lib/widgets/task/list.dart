import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../models/task.dart';
import '../../providers/task.dart';

class TaskList extends ConsumerWidget {
  const TaskList({super.key, required this.tasks});

  final Iterable<Task> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: tasks.map((task) {
        final index = tasks.toList().indexOf(task);
        final date = task.date?.toLocal();
        final dateFormat = date != null && date.year == DateTime.now().year
            ? DateFormat.MMMd(context.locale.toString())
            : DateFormat.yMMMMd(context.locale.toString());
        final reminder = task.reminder?.toLocal();
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

        return ListTile(
          leading: Icon(
            task.status == TaskStatus.done
                ? Icons.check_box
                : Icons.check_box_outline_blank,
          ),
          title: Text(task.name),
          onTap: () {
            ref.read(taskProvider.notifier).toggleTask(index, task);
          },
          onLongPress: () {
            context.push("/task/$index");
          },
        );
      }).toList(),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

import '../providers/task.dart';
import '../widgets/task/details.dart';

class TaskDetailsScreen extends ConsumerWidget {
  const TaskDetailsScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      final task = ref.watch(taskProvider).requireValue[taskId]!;

      return <Widget>[
        TaskDetails(task: task).padding(all: 16),
        <Widget>[
          TextButton(
            onPressed: () => context.push('/task/$taskId/edit'),
            child: Text('task_details.edit'.tr()),
          ).expanded(),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () => context.push('/task/$taskId/delete'),
            child: Text('task_details.delete'.tr()),
          ).expanded(),
        ].toRow(),
      ].toColumn(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    } catch (e) {
      Future.microtask(
        () => {if (context.canPop()) context.pop() else context.go('/')},
      );

      return Container();
    }
  }
}

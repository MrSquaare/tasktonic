import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

import '../providers/task.dart';

class DeleteTaskDialog extends ConsumerWidget {
  const DeleteTaskDialog({super.key, required this.taskId});

  final String taskId;

  _onDelete(BuildContext context, WidgetRef ref) {
    final provider = ref.read(taskProvider.notifier);

    provider.deleteTask(taskId).then((value) async {
      provider.cancelTaskNotification(taskId);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTaskId = taskId;
    final tasks = ref.watch(taskProvider);

    return tasks.when(
      data: (data) {
        final task = data[currentTaskId];

        if (task != null) {
          return AlertDialog(
            title: Text('delete_task.title'.tr()),
            content: RichText(
              text: TextSpan(
                text: 'delete_task.content.1'.tr(),
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(text: task.name).bold(),
                  TextSpan(
                    text: 'delete_task.content.2'.tr(),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => context.pop(),
                child: Text('delete_task.cancel'.tr()),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                onPressed: () => _onDelete(context, ref),
                child: Text('delete_task.delete'.tr()),
              ),
            ],
          );
        } else {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          });

          return Container();
        }
      },
      loading: () => const CircularProgressIndicator().center(),
      error: (error, _) => Text('delete_task.error'.tr()).center(),
    );
  }
}

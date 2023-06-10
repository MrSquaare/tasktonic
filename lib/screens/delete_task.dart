import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

import '../providers/task.dart';

class DeleteTaskDialog extends ConsumerWidget {
  const DeleteTaskDialog({super.key, required this.taskIndex});

  final int taskIndex;

  _onDelete(BuildContext context, WidgetRef ref) {
    ref.read(taskProvider.notifier).deleteTask(taskIndex).then((value) async {
      context.go('/');

      ref.read(taskProvider.notifier).cancelTaskNotification(taskIndex);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      final task = ref.read(taskProvider).requireValue.elementAt(taskIndex);

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
    } catch (e) {
      return Container();
    }
  }
}

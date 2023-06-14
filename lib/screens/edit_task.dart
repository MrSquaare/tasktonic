import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

import '../models/task.dart';
import '../providers/task.dart';
import '../utilities/date.dart';
import '../widgets/task/form.dart';

class EditTaskScreen extends ConsumerWidget {
  EditTaskScreen({super.key, required this.taskIndex});

  final int taskIndex;

  final _formKey = GlobalKey<FormBuilderState>();

  _onEdit(BuildContext context, WidgetRef ref) {
    if (!_formKey.currentState!.saveAndValidate()) return;

    final DateTime? dateValue = _formKey.currentState!.value['date'];
    final DateTime? reminderValue = _formKey.currentState!.value['reminder'];

    final task = Task(
      name: _formKey.currentState!.value['name'],
      description: _formKey.currentState!.value['description'],
      date: dateTimeToDateString(dateValue),
      reminder: dateTimeToTimeString(reminderValue),
    );

    ref
        .read(taskProvider.notifier)
        .updateTask(taskIndex, task)
        .then((value) async {
      context.pop();

      if (dateValue != null && reminderValue != null) {
        ref.read(taskProvider.notifier).createTaskNotification(taskIndex, task);
      } else {
        ref.read(taskProvider.notifier).cancelTaskNotification(taskIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      final task = ref.read(taskProvider).requireValue.elementAt(taskIndex);

      return Scaffold(
        appBar: AppBar(
          title: Text('edit_task.title'.tr()),
        ),
        body: <Widget>[
          TaskForm(formKey: _formKey, task: task).padding(all: 16),
          <Widget>[
            TextButton(
              onPressed: () => context.pop(),
              child: Text('edit_task.cancel'.tr()),
            ).expanded(),
            TextButton(
              onPressed: () => _onEdit(context, ref),
              child: Text('edit_task.edit'.tr()),
            ).expanded(),
          ].toRow().positioned(left: 0, right: 0, bottom: 0)
        ].toStack(),
      );
    } catch (e) {
      return Container();
    }
  }
}

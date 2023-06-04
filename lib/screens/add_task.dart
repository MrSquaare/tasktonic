import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

import '../models/task.dart';
import '../providers/task.dart';
import '../utilities/task.dart';
import '../widgets/task/form.dart';

class AddTaskScreen extends ConsumerWidget {
  AddTaskScreen({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  _onAdd(BuildContext context, WidgetRef ref) {
    if (!_formKey.currentState!.saveAndValidate()) return;

    final reminderValue = _formKey.currentState!.value['reminder'];

    final task = Task(
      name: _formKey.currentState!.value['name'],
      description: _formKey.currentState!.value['description'],
      reminder: reminderValue != null
          ? convertDateTimeToUTCTime(reminderValue)
          : null,
    );

    ref.read(taskProvider.notifier).createTask(task).then((_) => context.pop());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_task.title'.tr()),
      ),
      body: <Widget>[
        TaskForm(formKey: _formKey).padding(all: 16),
        <Widget>[
          TextButton(
            onPressed: () => context.pop(),
            child: Text('add_task.cancel'.tr()),
          ).expanded(),
          TextButton(
            onPressed: () => _onAdd(context, ref),
            child: Text('add_task.add'.tr()),
          ).expanded(),
        ].toRow().positioned(left: 0, right: 0, bottom: 0)
      ].toStack(),
    );
  }
}

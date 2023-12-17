import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rrule/rrule.dart';
import 'package:styled_widget/styled_widget.dart';

import '../models/task.dart';
import '../providers/task.dart';
import '../widgets/task/form.dart';

class AddEditTaskScreen extends ConsumerWidget {
  AddEditTaskScreen({super.key, this.taskId});

  final String? taskId;

  final _formKey = GlobalKey<FormBuilderState>();

  _onSave(BuildContext context, WidgetRef ref) {
    if (!_formKey.currentState!.saveAndValidate()) return;

    final String name = _formKey.currentState!.value['name'];
    final String? description = _formKey.currentState!.value['description'];
    final DateTime date = _formKey.currentState!.value['date'];
    final DateTime? reminder = _formKey.currentState!.value['reminder'];
    final bool? repeat = _formKey.currentState!.value['repeat'];
    final Frequency? repeatFrequency =
        repeat == true ? _formKey.currentState!.value['repeatFrequency'] : null;
    final rrule = repeat == true && repeatFrequency != null
        ? RecurrenceRule(
            frequency: repeatFrequency,
            interval: 1,
          )
        : null;

    final task = Task.fromDates(
      name: name,
      description: description,
      date: date,
      reminder: reminder,
      rrule: rrule,
    );

    final currentTaskId = taskId;
    final provider = ref.read(taskProvider.notifier);

    if (currentTaskId != null) {
      provider.updateTask(currentTaskId, task).then((value) async {
        context.pop();

        if (task.reminder != null) {
          provider.createTaskNotification(task);
        } else {
          provider.cancelTaskNotification(task.id);
        }
      });
    } else {
      provider.createTask(task).then((taskIndex) async {
        context.pop();

        if (task.reminder != null) {
          provider.createTaskNotification(task);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTaskId = taskId;
    final tasks = ref.watch(taskProvider);

    return tasks.when(
      data: (data) {
        final task = currentTaskId != null ? data[currentTaskId] : null;

        if (currentTaskId == null || task != null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                (task != null ? 'edit_task.title' : 'add_task.title').tr(),
              ),
            ),
            body: <Widget>[
              TaskForm(formKey: _formKey, task: task)
                  .padding(all: 16)
                  .scrollable()
                  .expanded(),
              Container(
                child: <Widget>[
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      (task != null ? 'edit_task.cancel' : 'add_task.cancel')
                          .tr(),
                    ),
                  ).expanded(),
                  TextButton(
                    onPressed: () => _onSave(context, ref),
                    child: Text(
                      (task != null ? 'edit_task.edit' : 'add_task.add').tr(),
                    ),
                  ).expanded(),
                ].toRow(),
              ),
            ].toColumn(),
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
      error: (error, _) => Text('add_task.error'.tr()).center(),
    );
  }
}

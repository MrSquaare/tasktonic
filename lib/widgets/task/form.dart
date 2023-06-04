import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../models/task.dart';
import '../../utilities/task.dart';

class TaskForm extends StatelessWidget {
  const TaskForm({super.key, required this.formKey, this.task});

  final GlobalKey<FormBuilderState> formKey;
  final Task? task;

  @override
  Widget build(BuildContext context) {
    final reminderValue = task?.reminder;
    final reminder =
        reminderValue != null ? convertUTCTimeToDateTime(reminderValue) : null;

    return FormBuilder(
      key: formKey,
      initialValue: {
        'name': task?.name,
        'description': task?.description,
        'reminder': reminder,
      },
      child: <Widget>[
        FormBuilderTextField(
          name: 'name',
          decoration: InputDecoration(
            labelText: 'task_form.name.label'.tr(),
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
              errorText: 'task_form.name.error.required'.tr(),
            ),
          ]),
        ),
        FormBuilderTextField(
          name: 'description',
          decoration: InputDecoration(
            labelText: 'task_form.description.label'.tr(),
          ),
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 5,
        ),
        FormBuilderDateTimePicker(
          name: 'reminder',
          inputType: InputType.time,
          decoration: InputDecoration(
            labelText: 'task_form.reminder.label'.tr(),
          ),
        ),
      ].toColumn(),
    );
  }
}

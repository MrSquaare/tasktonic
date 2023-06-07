import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../models/task.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key, required this.formKey, this.task});

  final GlobalKey<FormBuilderState> formKey;
  final Task? task;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  bool _hasDate = false;

  @override
  void initState() {
    super.initState();

    _hasDate = widget.task?.reminder != null;
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      initialValue: {
        'name': widget.task?.name,
        'description': widget.task?.description,
        'date': widget.task?.date?.toLocal(),
        'reminder': widget.task?.reminder?.toLocal(),
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
          name: 'date',
          inputType: InputType.date,
          firstDate: DateTime.now(),
          decoration: InputDecoration(
            labelText: 'task_form.date.label'.tr(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                widget.formKey.currentState?.fields['date']?.didChange(null);
                widget.formKey.currentState?.fields['reminder']
                    ?.didChange(null);
              },
            ),
          ),
          onChanged: (value) {
            setState(() {
              _hasDate = value != null;
            });
          },
        ),
        if (_hasDate)
          FormBuilderDateTimePicker(
            name: 'reminder',
            inputType: InputType.time,
            decoration: InputDecoration(
              labelText: 'task_form.reminder.label'.tr(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  widget.formKey.currentState?.fields['reminder']
                      ?.didChange(null);
                },
              ),
            ),
          ),
      ].toColumn(),
    );
  }
}

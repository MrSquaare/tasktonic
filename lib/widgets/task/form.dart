import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:rrule/rrule.dart';
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
  bool _hasRRule = false;

  @override
  void initState() {
    super.initState();

    _hasRRule = widget.task?.rrule != null;
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      initialValue: {
        'name': widget.task?.name,
        'description': widget.task?.description,
        'date': widget.task?.date ?? DateTime.now(),
        'reminder': widget.task?.reminder,
        'repeat': widget.task?.rrule != null,
        'repeatFrequency': widget.task?.rrule?.frequency,
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
          currentDate: DateTime.now(),
          decoration: InputDecoration(
            labelText: 'task_form.date.label'.tr(),
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
              errorText: 'task_form.name.error.required'.tr(),
            ),
          ]),
        ),
        FormBuilderDateTimePicker(
          name: 'reminder',
          inputType: InputType.time,
          currentDate: DateTime.now(),
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
        FormBuilderCheckbox(
          name: 'repeat',
          title: Text('task_form.repeat.label'.tr()),
          onChanged: (value) {
            setState(() {
              _hasRRule = value ?? false;
            });
          },
        ),
        if (_hasRRule)
          FormBuilderRadioGroup(
            name: 'repeatFrequency',
            options: [
              FormBuilderFieldOption(
                value: Frequency.daily,
                child: Text('task_form.repeat_frequency.daily'.tr()),
              ),
              FormBuilderFieldOption(
                value: Frequency.weekly,
                child: Text('task_form.repeat_frequency.weekly'.tr()),
              ),
              FormBuilderFieldOption(
                value: Frequency.monthly,
                child: Text('task_form.repeat_frequency.monthly'.tr()),
              ),
              FormBuilderFieldOption(
                value: Frequency.yearly,
                child: Text('task_form.repeat_frequency.yearly'.tr()),
              ),
            ],
            orientation: OptionsOrientation.vertical,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: 'task_form.repeat_frequency.error.required'.tr(),
              ),
            ]),
          ),
      ].toColumn(),
    );
  }
}

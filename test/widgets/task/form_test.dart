import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rrule/rrule.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/widgets/task/form.dart';
import 'package:tasktonic/wrapper.dart';

import '../../__helpers__/widget.dart';

void main() {
  group('TaskForm', () {
    final currentDate = DateTime.now();

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      SharedPreferences.setMockInitialValues({});

      await EasyLocalization.ensureInitialized();
    });

    testWidgets('should display empty form fields with current date',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        final formKey = GlobalKey<FormBuilderState>();

        await tester.pumpWidget(
          MyAppWrapper(
            child: MaterialAppTest(
              home: Scaffold(
                body: TaskForm(
                  formKey: formKey,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Test Task'), findsNothing);
        expect(find.text('This is a test task'), findsNothing);
        expect(
          find.text(
            '${currentDate.day}/${currentDate.month}/${currentDate.year}',
          ),
          findsNothing,
        );
        expect(find.text('12:00'), findsNothing);
      });
    });

    testWidgets('should display filled form fields',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        final formKey = GlobalKey<FormBuilderState>();
        final task = Task(
          name: 'Test Task',
          description: 'This is a test task',
          dateStr: '2022-01-01',
          reminderStr: '12:00',
          rrule: RecurrenceRule(
            frequency: Frequency.daily,
            interval: 1,
          ),
        );

        await tester.pumpWidget(
          MyAppWrapper(
            child: MaterialAppTest(
              home: Scaffold(
                body: TaskForm(
                  formKey: formKey,
                  task: task,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Test Task'), findsOneWidget);
        expect(find.text('This is a test task'), findsOneWidget);
        expect(find.text('1/1/2022'), findsOneWidget);
        expect(find.text('12:00'), findsOneWidget);

        final checkbox = find.byType(Checkbox).first;

        expect(checkbox, findsOneWidget);
        expect(tester.widget<Checkbox>(checkbox).value, isTrue);

        final dailyRadio = find
            .byWidgetPredicate(
              (widget) => widget is Radio,
            )
            .first;

        expect(dailyRadio, findsOneWidget);
        expect(tester.widget<Radio>(dailyRadio).value, Frequency.daily);
        expect(find.text('Daily'), findsOneWidget);
        expect(find.text('Weekly'), findsOneWidget);
        expect(find.text('Monthly'), findsOneWidget);
        expect(find.text('Yearly'), findsOneWidget);
      });
    });

    testWidgets('should clear reminder field', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final formKey = GlobalKey<FormBuilderState>();
        final task = Task(
          name: 'Test Task',
          description: 'This is a test task',
          dateStr: '2022-01-01',
          reminderStr: '12:00',
        );

        await tester.pumpWidget(
          MyAppWrapper(
            child: MaterialAppTest(
              home: Scaffold(
                body: TaskForm(
                  formKey: formKey,
                  task: task,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(find.byType(IconButton).last);

        await tester.pumpAndSettle();

        expect(formKey.currentState?.fields['reminder']?.value, isNull);
      });
    });

    testWidgets('should validate required all form fields',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        final formKey = GlobalKey<FormBuilderState>();

        await tester.pumpWidget(
          MyAppWrapper(
            child: MaterialAppTest(
              home: Scaffold(
                body: TaskForm(
                  formKey: formKey,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Tap on the checkbox
        final checkbox = find.byType(Checkbox).first;

        await tester.tap(checkbox);
        await tester.pumpAndSettle();

        formKey.currentState!.saveAndValidate();

        await tester.pumpAndSettle();

        expect(find.text('Name is required'), findsOneWidget);
        expect(find.text('Repeat frequency is required'), findsOneWidget);
      });
    });
  });
}

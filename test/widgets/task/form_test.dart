import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/widgets/task/form.dart';
import 'package:tasktonic/wrapper.dart';

import '../../__helpers__/widget.dart';

void main() {
  group('TaskForm', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      SharedPreferences.setMockInitialValues({});

      await EasyLocalization.ensureInitialized();
    });

    testWidgets('should display empty form fields',
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
        expect(find.text('2022-02-01'), findsNothing);
        expect(find.text('12:00'), findsNothing);
      });
    });

    testWidgets('should display minimal filled form fields',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        final formKey = GlobalKey<FormBuilderState>();
        final task = Task(
          name: 'Test Task',
          description: 'This is a test task',
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
        expect(find.text('Date'), findsOneWidget);
        expect(find.text('Reminder'), findsNothing);
      });
    });

    testWidgets('should display all filled form fields',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        final formKey = GlobalKey<FormBuilderState>();
        final task = Task(
          name: 'Test Task',
          description: 'This is a test task',
          date: '2022-02-01',
          reminder: '12:00',
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
        expect(find.text('2/1/2022'), findsOneWidget);
        expect(find.text('12:00'), findsOneWidget);
      });
    });

    testWidgets('should validate required fields', (WidgetTester tester) async {
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

        formKey.currentState!.saveAndValidate();

        await tester.pumpAndSettle();

        expect(find.text('Name is required'), findsOneWidget);
      });
    });

    testWidgets('should clear date and reminder fields',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        final formKey = GlobalKey<FormBuilderState>();
        final task = Task(
          name: 'Test Task',
          description: 'This is a test task',
          date: '2022-02-01',
          reminder: '12:00',
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

        await tester.tap(find.byType(IconButton).first);

        await tester.pumpAndSettle();

        expect(formKey.currentState?.fields['date']?.value, isNull);
        expect(formKey.currentState?.fields['reminder']?.value, isNull);
      });
    });

    testWidgets('should clear reminder field', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final formKey = GlobalKey<FormBuilderState>();
        final task = Task(
          name: 'Test Task',
          description: 'This is a test task',
          date: '2022-02-01',
          reminder: '12:00',
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

        expect(formKey.currentState?.fields['date']?.value, isNotNull);
        expect(formKey.currentState?.fields['reminder']?.value, isNull);
      });
    });
  });
}

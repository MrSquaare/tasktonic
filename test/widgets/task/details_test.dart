import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/widgets/task/details.dart';
import 'package:tasktonic/wrapper.dart';

import '../../__helpers__/widget.dart';

void main() {
  final currentYear = DateTime.now().year;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    SharedPreferences.setMockInitialValues({});

    await EasyLocalization.ensureInitialized();
  });

  testWidgets('should display task name and description', (tester) async {
    await tester.runAsync(() async {
      final task = Task(
        name: 'Test Task',
        description: 'Test Description',
      );

      await tester.pumpWidget(
        MyAppWrapper(
          child: MaterialAppTest(
            home: Scaffold(
              body: TaskDetails(task: task),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });
  });

  testWidgets('should display task date and reminder', (tester) async {
    await tester.runAsync(() async {
      final task = Task(
        name: 'Test Task',
        date: '$currentYear-01-01',
        reminder: '12:00',
      );

      await tester.pumpWidget(
        MyAppWrapper(
          child: MaterialAppTest(
            home: Scaffold(
              body: TaskDetails(task: task),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('For the January 1'), findsOneWidget);
      expect(find.text('Reminder at 12:00'), findsOneWidget);
    });
  });

  testWidgets('should display only task date', (tester) async {
    await tester.runAsync(() async {
      final task = Task(
        name: 'Test Task',
        date: '$currentYear-01-01',
      );

      await tester.pumpWidget(
        MyAppWrapper(
          child: MaterialAppTest(
            home: Scaffold(
              body: TaskDetails(task: task),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('For the January 1'), findsOneWidget);
      expect(find.text('Reminder at 12:00'), findsNothing);
    });
  });

  // This shouldn't happen, but it's here just in case
  testWidgets('should display only task reminder', (tester) async {
    await tester.runAsync(() async {
      final task = Task(
        name: 'Test Task',
        reminder: '12:00',
      );

      await tester.pumpWidget(
        MyAppWrapper(
          child: MaterialAppTest(
            home: Scaffold(
              body: TaskDetails(task: task),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('For the January 1'), findsNothing);
      expect(find.text('Reminder at 12:00'), findsOneWidget);
    });
  });

  testWidgets('should display no date or reminder', (tester) async {
    await tester.runAsync(() async {
      final task = Task(
        name: 'Test Task',
      );

      await tester.pumpWidget(
        MyAppWrapper(
          child: MaterialAppTest(
            home: Scaffold(
              body: TaskDetails(task: task),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('For the January 1'), findsNothing);
      expect(find.text('Reminder at 12:00'), findsNothing);
    });
  });
}

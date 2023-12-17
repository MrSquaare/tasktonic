import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/widgets/task/details.dart';
import 'package:tasktonic/wrapper.dart';

import '../../__helpers__/widget.dart';

void main() {
  group('TaskDetails', () {
    final currentDate = DateTime.now();
    final currentYear = currentDate.year;

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
          dateStr: '2021-01-01',
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

    testWidgets('should display only task date', (tester) async {
      await tester.runAsync(() async {
        final task = Task(
          name: 'Test Task',
          dateStr: '$currentYear-01-01',
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

    testWidgets('should display only task date with year', (tester) async {
      await tester.runAsync(() async {
        final task = Task(
          name: 'Test Task',
          dateStr: '${currentYear + 1}-01-01',
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

        expect(
          find.text('For the January 1, ${currentYear + 1}'),
          findsOneWidget,
        );
        expect(find.text('Reminder at 12:00'), findsNothing);
      });
    });

    testWidgets('should display task date and reminder', (tester) async {
      await tester.runAsync(() async {
        final task = Task(
          name: 'Test Task',
          dateStr: '$currentYear-01-01',
          reminderStr: '12:00',
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
  });
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/widgets/task/list.dart';
import 'package:tasktonic/wrapper.dart';

import '../../__helpers__/controller.dart';
import '../../__helpers__/widget.dart';

class MockFunctions extends Mock {
  void onToggle(Task task);
  void onNavigate(Task task);
}

void main() {
  group('TaskList', () {
    final currentDate = DateTime.now();
    final currentYear = currentDate.year;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      SharedPreferences.setMockInitialValues({});

      await EasyLocalization.ensureInitialized();
    });

    testWidgets('should display tasks', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final tasks = [
          Task(
            name: 'Task 1',
            status: TaskStatus.todo,
            dateStr: '2022-01-01',
            reminderStr: '10:00',
          ),
          Task(
            name: 'Task 2',
            status: TaskStatus.done,
            dateStr: '2022-01-02',
            reminderStr: '11:00',
          ),
        ];

        await tester.pumpWidget(
          MyAppWrapper(
            child: MaterialAppTest(
              home: Scaffold(
                body: TaskList(tasks: tasks),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Task 1'), findsOneWidget);
        expect(find.text('Task 2'), findsOneWidget);
      });
    });

    testWidgets('should call onToggle', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final mock = MockFunctions();
        final tasks = [
          Task(
            name: 'Task 1',
            status: TaskStatus.todo,
            dateStr: '2022-01-01',
            reminderStr: '10:00',
          ),
          Task(
            name: 'Task 2',
            status: TaskStatus.done,
            dateStr: '2022-01-02',
            reminderStr: '11:00',
          ),
        ];

        await tester.pumpWidget(
          MyAppWrapper(
            child: MaterialAppTest(
              home: Scaffold(
                body: TaskList(tasks: tasks, onToggle: mock.onToggle),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(find.text('Task 1'));

        verify(mock.onToggle(tasks[0])).called(1);

        await tester.tap(find.text('Task 2'));

        verify(mock.onToggle(tasks[1])).called(1);
      });
    });

    testWidgets('should call onNavigate', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final mock = MockFunctions();
        final tasks = [
          Task(
            name: 'Task 1',
            status: TaskStatus.todo,
            dateStr: '2022-01-01',
            reminderStr: '10:00',
          ),
          Task(
            name: 'Task 2',
            status: TaskStatus.done,
            dateStr: '2022-01-02',
            reminderStr: '11:00',
          ),
        ];

        await tester.pumpWidget(
          MyAppWrapper(
            child: MaterialAppTest(
              home: Scaffold(
                body: TaskList(tasks: tasks, onNavigate: mock.onNavigate),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        await longPress(tester, find.text('Task 1'));

        verify(mock.onNavigate(tasks[0])).called(1);

        await longPress(tester, find.text('Task 2'));

        verify(mock.onNavigate(tasks[1])).called(1);
      });
    });

    testWidgets('should display task date and reminder', (tester) async {
      await tester.runAsync(() async {
        final tasks = [
          Task(
            name: 'Task 1',
            status: TaskStatus.todo,
            dateStr: '$currentYear-01-01',
            reminderStr: '10:00',
          ),
          Task(
            name: 'Task 2',
            status: TaskStatus.done,
            dateStr: '$currentYear-01-02',
            reminderStr: '11:00',
          ),
        ];

        await tester.pumpWidget(
          MyAppWrapper(
            child: MaterialAppTest(
              home: Scaffold(
                body: TaskList(tasks: tasks),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Jan 1'), findsOneWidget);
        expect(find.text('Jan 2'), findsOneWidget);
        expect(find.text('10:00'), findsOneWidget);
        expect(find.text('11:00'), findsOneWidget);
      });
    });

    testWidgets('should display only task date', (tester) async {
      await tester.runAsync(() async {
        final tasks = [
          Task(
            name: 'Task 1',
            status: TaskStatus.todo,
            dateStr: '$currentYear-01-01',
          ),
          Task(
            name: 'Task 2',
            status: TaskStatus.done,
            dateStr: '$currentYear-01-02',
          ),
        ];

        await tester.pumpWidget(
          MyAppWrapper(
            child: MaterialAppTest(
              home: Scaffold(
                body: TaskList(tasks: tasks),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Jan 1'), findsOneWidget);
        expect(find.text('10:00'), findsNothing);
        expect(find.text('Jan 2'), findsOneWidget);
        expect(find.text('11:00'), findsNothing);
      });
    });

    testWidgets('should display task date with year', (tester) async {
      await tester.runAsync(() async {
        final tasks = [
          Task(
            name: 'Task 1',
            status: TaskStatus.todo,
            dateStr: '${currentYear + 1}-01-01',
          ),
          Task(
            name: 'Task 2',
            status: TaskStatus.done,
            dateStr: '${currentYear + 1}-01-02',
          ),
        ];

        await tester.pumpWidget(
          MyAppWrapper(
            child: MaterialAppTest(
              home: Scaffold(
                body: TaskList(tasks: tasks),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Jan 1, ${currentYear + 1}'), findsOneWidget);
        expect(find.text('Jan 2, ${currentYear + 1}'), findsOneWidget);
      });
    });
  });
}

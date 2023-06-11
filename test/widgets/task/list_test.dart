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
  void onToggle(int index, Task task);
  void onNavigate(int index, Task task);
}

void main() {
  group('TaskList', () {
    final currentYear = DateTime.now().year;

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
            date: '2022-01-01',
            reminder: '10:00',
            status: TaskStatus.todo,
          ),
          Task(
            name: 'Task 2',
            date: '2022-01-02',
            reminder: '11:00',
            status: TaskStatus.done,
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
            date: '2022-01-01',
            reminder: '10:00',
            status: TaskStatus.todo,
          ),
          Task(
            name: 'Task 2',
            date: '2022-01-02',
            reminder: '11:00',
            status: TaskStatus.done,
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

        verify(mock.onToggle(0, tasks[0])).called(1);

        await tester.tap(find.text('Task 2'));

        verify(mock.onToggle(1, tasks[1])).called(1);
      });
    });

    testWidgets('should call onNavigate', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final mock = MockFunctions();
        final tasks = [
          Task(
            name: 'Task 1',
            date: '2022-01-01',
            reminder: '10:00',
            status: TaskStatus.todo,
          ),
          Task(
            name: 'Task 2',
            date: '2022-01-02',
            reminder: '11:00',
            status: TaskStatus.done,
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

        verify(mock.onNavigate(0, tasks[0])).called(1);

        await longPress(tester, find.text('Task 2'));

        verify(mock.onNavigate(1, tasks[1])).called(1);
      });
    });

    testWidgets('should display task date and reminder', (tester) async {
      await tester.runAsync(() async {
        final tasks = [
          Task(
            name: 'Task 1',
            date: '$currentYear-01-01',
            reminder: '10:00',
            status: TaskStatus.todo,
          ),
          Task(
            name: 'Task 2',
            date: '$currentYear-01-02',
            reminder: '11:00',
            status: TaskStatus.done,
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
            date: '$currentYear-01-01',
            status: TaskStatus.todo,
          ),
          Task(
            name: 'Task 2',
            date: '$currentYear-01-02',
            status: TaskStatus.done,
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

    // This shouldn't happen, but it's here just in case
    testWidgets('should display only task reminder', (tester) async {
      await tester.runAsync(() async {
        final tasks = [
          Task(
            name: 'Task 1',
            reminder: '10:00',
            status: TaskStatus.todo,
          ),
          Task(
            name: 'Task 2',
            reminder: '11:00',
            status: TaskStatus.done,
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

        expect(find.text('Jan 1'), findsNothing);
        expect(find.text('10:00'), findsOneWidget);
        expect(find.text('Jan 2'), findsNothing);
        expect(find.text('11:00'), findsOneWidget);
      });
    });

    testWidgets('should display no date or reminder', (tester) async {
      await tester.runAsync(() async {
        final tasks = [
          Task(
            name: 'Task 1',
            status: TaskStatus.todo,
          ),
          Task(
            name: 'Task 2',
            status: TaskStatus.done,
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

        expect(find.text('Jan 1'), findsNothing);
        expect(find.text('10:00'), findsNothing);
        expect(find.text('Jan 2'), findsNothing);
        expect(find.text('11:00'), findsNothing);
      });
    });
  });
}

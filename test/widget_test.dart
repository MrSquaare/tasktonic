// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:tasktonic/main.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/wrapper.dart';

import 'setup.dart';

void main() async {
  setUpAll(() async {
    await setUpAllTestEnv();
  });

  setUp(() async {
    await setupTestEnv();
  });

  tearDown(() async {
    await tearDownTestEnv();
  });

  tearDownAll(() async {
    await tearDownAllTestEnv();
  });

  testWidgets('Should build', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MyAppWrapper(
          child: MyApp(),
        ),
      );

      await tester.pump();
    });
  });

  testWidgets('Should have a task', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final box = Hive.box<Task>('tasks');

      await box.add(
        Task(
          name: 'Test Task',
          description: 'Test Description',
        ),
      );

      await tester.pumpWidget(
        MyAppWrapper(
          child: MyApp(),
        ),
      );

      await tester.pump();

      expect(find.text('Test Task'), findsOneWidget);
    });
  });

  testWidgets('Should have no task', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MyAppWrapper(
          child: MyApp(),
        ),
      );

      await tester.pump();

      expect(find.text('Test Task'), findsNothing);
    });
  });

  testWidgets('Should toggle task', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final box = Hive.box<Task>('tasks');

      await box.add(
        Task(
          name: 'Test Task',
          description: 'Test Description',
        ),
      );

      await tester.pumpWidget(
        MyAppWrapper(
          child: MyApp(),
        ),
      );

      await tester.pump();

      await tester.tap(find.byType(ListTile));

      await tester.pump();

      expect(find.byIcon(Icons.check_box), findsOneWidget);
    });
  });

  testWidgets('Should create a new task', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MyAppWrapper(
          child: MyApp(),
        ),
      );

      await tester.pump();

      expect(find.text('Test Task'), findsNothing);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);

      await tester.enterText(textFields.at(0), 'Test Task');
      await tester.enterText(textFields.at(1), 'Test Description');
      await tester.tap(find.byType(TextButton).at(1));

      await tester.pumpAndSettle();

      await expectLater(find.byType(ListTile), findsOneWidget);
    });
  });

  testWidgets('Should show task details', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final box = Hive.box<Task>('tasks');

      await box.add(
        Task(
          name: 'Test Task',
          description: 'Test Description',
        ),
      );

      await tester.pumpWidget(
        MyAppWrapper(
          child: MyApp(),
        ),
      );

      await tester.pump();

      await tester.longPress(find.byType(ListTile));

      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.text('Test Task'), findsNWidgets(2));
      expect(find.text('Test Description'), findsOneWidget);
    });
  });
}

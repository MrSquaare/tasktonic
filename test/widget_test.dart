// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tasktonic/main.dart';
import 'package:tasktonic/models/adapters.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/repositories/boxes.dart';
import 'package:tasktonic/wrapper.dart';

import 'controller.dart';
import 'mock.dart';
import 'utility.dart';

void main() async {
  Directory? testDirectory;

  setUpAll(() async {
    testDirectory = getTestDirectory();

    TestWidgetsFlutterBinding.ensureInitialized();

    mockPathProviderChannel(testDirectory!.path);
    SharedPreferences.setMockInitialValues({});

    await EasyLocalization.ensureInitialized();
    await Hive.initFlutter();

    registerAdapters();
  });

  setUp(() async {
    await openBoxes();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  tearDownAll(() async {
    testDirectory!.deleteSync(recursive: true);
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

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Test Task'), findsOneWidget);
    });
  });

  testWidgets('Should create a new task', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final box = Hive.box<Task>('tasks');

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

      expect(textFields, findsNWidgets(2));

      await tester.tap(textFields.at(0));
      await tester.pumpAndSettle();
      await tester.enterText(textFields.at(0), 'Test Task');
      await tester.tap(textFields.at(1));
      await tester.pumpAndSettle();
      await tester.enterText(textFields.at(1), 'Test Description');
      await tester.tap(find.byType(TextButton).at(1));
      await box.flush();
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Test Task'), findsOneWidget);
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
      await box.flush();
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_box), findsOneWidget);
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

      expect(find.byType(ListTile), findsOneWidget);

      await longPress(tester, find.byType(ListTile));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.text('Test Task'), findsNWidgets(2));
      expect(find.text('Test Description'), findsOneWidget);
    });
  });

  testWidgets('Should edit task', (WidgetTester tester) async {
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

      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(ListTile), findsOneWidget);

      await longPress(tester, find.byType(ListTile));
      await tester.pumpAndSettle();

      final bottomSheet = find.byType(BottomSheet);
      final bottomSheetButtons = find.descendant(
        of: bottomSheet,
        matching: find.byType(TextButton),
      );

      await tester.tap(bottomSheetButtons.at(0));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);

      expect(textFields, findsNWidgets(2));
      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);

      await tester.tap(textFields.at(0));
      await tester.pumpAndSettle();
      await tester.enterText(textFields.at(0), 'Test Task Edited');
      await tester.tap(textFields.at(1));
      await tester.pumpAndSettle();
      await tester.enterText(textFields.at(1), 'Test Description Edited');
      await tester.tap(find.byType(TextButton).at(1));
      await box.flush();
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Test Task Edited'), findsNWidgets(2));
      expect(find.text('Test Description Edited'), findsOneWidget);
    });
  });

  testWidgets('Should delete task', (WidgetTester tester) async {
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

      expect(find.byType(ListTile), findsOneWidget);

      await longPress(tester, find.byType(ListTile));
      await tester.pumpAndSettle();

      final bottomSheet = find.byType(BottomSheet);
      final bottomSheetButtons = find.descendant(
        of: bottomSheet,
        matching: find.byType(TextButton),
      );

      await tester.tap(bottomSheetButtons.at(1));
      await tester.pumpAndSettle();

      final alertDialog = find.byType(AlertDialog);

      expect(alertDialog, findsOneWidget);

      final alertDialogButtons = find.descendant(
        of: alertDialog,
        matching: find.byType(TextButton),
      );

      await tester.tap(alertDialogButtons.at(1));
      await box.flush();
      await tester.pumpAndSettle();

      expect(alertDialog, findsNothing);
      expect(bottomSheet, findsNothing);
      expect(find.byType(ListTile), findsNothing);
    });
  });
}

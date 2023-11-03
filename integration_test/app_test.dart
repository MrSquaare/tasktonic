// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:integration_test/integration_test.dart';

import 'package:tasktonic/main.dart' as app;
import 'package:tasktonic/models/task.dart';

void main() async {
  setUpAll(() async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('''
Scenario 1: 
User creates a task, mark it as done, edit it's name and description and delete it.
''', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await app.main();

      await Hive.box<Task>('tasks').clear();

      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      expect(find.text('There is no task for this day'), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      final addTextFields = find.byType(TextField);

      await tester.tap(addTextFields.at(0));
      await tester.pumpAndSettle();
      await tester.enterText(addTextFields.at(0), 'Test Task');
      await tester.tap(addTextFields.at(1));
      await tester.pumpAndSettle();
      await tester.enterText(addTextFields.at(1), 'Test Description');
      await tester.tap(find.byType(TextButton).at(1));
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Test Task'), findsOneWidget);

      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_box), findsOneWidget);

      await tester.longPress(find.byType(ListTile));
      await tester.pumpAndSettle();

      final bottomSheet = find.byType(BottomSheet);

      expect(bottomSheet, findsOneWidget);
      expect(find.text('Test Task'), findsNWidgets(2));
      expect(find.text('Test Description'), findsOneWidget);

      final bottomSheetButtons = find.descendant(
        of: bottomSheet,
        matching: find.byType(TextButton),
      );

      await tester.tap(bottomSheetButtons.at(0));
      await tester.pumpAndSettle();

      final editTextFields = find.byType(TextField);

      await tester.tap(editTextFields.at(0));
      await tester.pumpAndSettle();
      await tester.enterText(editTextFields.at(0), 'Test Task Edited');
      await tester.tap(editTextFields.at(1));
      await tester.pumpAndSettle();
      await tester.enterText(editTextFields.at(1), 'Test Description Edited');
      await tester.tap(find.byType(TextButton).at(1));
      await tester.pumpAndSettle();

      expect(find.text('Test Task Edited'), findsNWidgets(2));
      expect(find.text('Test Description Edited'), findsOneWidget);

      await tester.tap(bottomSheetButtons.at(1));
      await tester.pumpAndSettle();

      final alertDialog = find.byType(AlertDialog);

      expect(alertDialog, findsOneWidget);

      final alertDialogButtons = find.descendant(
        of: alertDialog,
        matching: find.byType(TextButton),
      );

      await tester.tap(alertDialogButtons.last);
      await tester.pumpAndSettle();

      expect(alertDialog, findsNothing);
      expect(bottomSheet, findsNothing);
      expect(find.byType(ListTile), findsNothing);
      expect(find.text('There is no task for this day'), findsOneWidget);
    });
  });
}

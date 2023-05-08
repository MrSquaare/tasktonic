import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/pages/home.dart';
import 'package:tasktonic/providers/task.dart';
import 'package:tasktonic/wrapper.dart';

class MockTaskNotifier extends AsyncNotifier<Iterable<Task>>
    with Mock
    implements TaskNotifier {
  @override
  FutureOr<Iterable<Task>> build() {
    return super.noSuchMethod(
      Invocation.method(
        #build,
        [],
      ),
      returnValue: Future<Iterable<Task>>.value(<Task>[]),
    );
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    SharedPreferences.setMockInitialValues({});

    await EasyLocalization.ensureInitialized();
  });

  testWidgets('Should show data', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final taskNotifier = MockTaskNotifier();

      when(taskNotifier.build()).thenAnswer((_) {
        return [Task(name: 'Task Test')];
      });

      final taskProviderOverride = taskProvider.overrideWith(
        () => taskNotifier,
      );

      await tester.pumpWidget(
        MyAppWrapper(
          providerOverrides: [taskProviderOverride],
          child: const MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Task Test'), findsOneWidget);
    });
  });

  testWidgets('Should show loading', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final taskNotifier = MockTaskNotifier();

      when(taskNotifier.build()).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));

        return [];
      });

      final taskProviderOverride = taskProvider.overrideWith(
        () => taskNotifier,
      );

      await tester.pumpWidget(
        MyAppWrapper(
          providerOverrides: [taskProviderOverride],
          child: const MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  testWidgets('Should show error', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final taskNotifier = MockTaskNotifier();

      when(taskNotifier.build()).thenAnswer((_) async {
        await Future.error(Exception());

        return [];
      });

      final taskProviderOverride = taskProvider.overrideWith(
        () => taskNotifier,
      );

      await tester.pumpWidget(
        MyAppWrapper(
          providerOverrides: [taskProviderOverride],
          child: const MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('home.error'), findsOneWidget);
    });
  });
}

class TaskProvider {}
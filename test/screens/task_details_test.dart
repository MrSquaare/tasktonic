import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/providers/task.dart';
import 'package:tasktonic/screens/task_details.dart';
import 'package:tasktonic/widgets/task/details.dart';
import 'package:tasktonic/wrapper.dart';

import '../__helpers__/widget.dart';

class MockTaskNotifier extends AsyncNotifier<Map<dynamic, Task>>
    with Mock
    implements TaskNotifier {
  @override
  FutureOr<Map<dynamic, Task>> build() {
    return super.noSuchMethod(
      Invocation.method(
        #build,
        [],
      ),
      returnValue: Future<Map<dynamic, Task>>.value(<dynamic, Task>{}),
    );
  }
}

void main() {
  group('TaskDetailsScreen', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      SharedPreferences.setMockInitialValues({});

      await EasyLocalization.ensureInitialized();
    });

    testWidgets('Should show task details', (tester) async {
      await tester.runAsync(() async {
        final taskNotifier = MockTaskNotifier();

        when(taskNotifier.build()).thenAnswer((_) async {
          return Future.value(
            {
              '0': Task(
                name: 'Task Test',
                dateStr: '2022-01-01',
              ),
            },
          );
        });

        final taskProviderOverride = taskProvider.overrideWith(
          () => taskNotifier,
        );

        await tester.pumpWidget(
          MyAppWrapper(
            providerOverrides: [taskProviderOverride],
            child: const MaterialAppTest(
              home: Scaffold(
                body: TaskDetailsScreen(taskId: '0'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(TaskDetails), findsOneWidget);
        expect(find.text('task_details.edit'.tr()), findsOneWidget);
        expect(find.text('task_details.delete'.tr()), findsOneWidget);
      });
    });

    // TODO: Find a way to test the edit and delete buttons
    // Needs to be able to test with GoRouter

    // TODO: Find a way to test the not found redirect
    // Needs to be able to test with GoRouter
  });
}

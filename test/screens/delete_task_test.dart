import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/providers/task.dart';
import 'package:tasktonic/screens/delete_task.dart';
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

  @override
  Future<void> deleteTask(String? id) async {
    return super.noSuchMethod(
      Invocation.method(
        #deleteTask,
        [id],
      ),
      returnValue: Future<void>.value(),
    );
  }

  @override
  Future<void> cancelTaskNotification(String? id) async {
    return super.noSuchMethod(
      Invocation.method(
        #cancelTaskNotification,
        [id],
      ),
      returnValue: Future<void>.value(),
    );
  }
}

void main() {
  group('DeleteTaskDialog', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      SharedPreferences.setMockInitialValues({});

      await EasyLocalization.ensureInitialized();
    });

    testWidgets('Should show delete task dialog', (tester) async {
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
              home: DeleteTaskDialog(taskId: '0'),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('delete_task.title'.tr()), findsOneWidget);
        expect(
          find.text(
            "${'delete_task.content.1'.tr()}Task Test${'delete_task.content.2'.tr()}",
            findRichText: true,
          ),
          findsOneWidget,
        );
        expect(find.text('delete_task.cancel'.tr()), findsOneWidget);
        expect(find.text('delete_task.delete'.tr()), findsOneWidget);
      });
    });

    testWidgets('Should delete task when delete button is pressed',
        (tester) async {
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
              home: DeleteTaskDialog(taskId: '0'),
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(find.text('delete_task.delete'.tr()));
        await tester.pumpAndSettle();

        verify(taskNotifier.deleteTask('0')).called(1);
        verify(taskNotifier.cancelTaskNotification('0')).called(1);
      });
    });

    // TODO: Find a way to test the cancel button
    // Needs to be able to test with GoRouter

    // TODO: Find a way to test the not found redirect
    // Needs to be able to test with GoRouter
  });
}

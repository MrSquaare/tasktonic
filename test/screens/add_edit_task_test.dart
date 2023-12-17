import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/providers/task.dart';
import 'package:tasktonic/screens/add_edit_task.dart';
import 'package:tasktonic/utilities/date.dart';
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
  group('AddEditTaskScreen', () {
    final currentDate = DateTime.now();
    final currentDateStr = DateUtilities.formatDate(currentDate);

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      SharedPreferences.setMockInitialValues({});

      await EasyLocalization.ensureInitialized();
    });

    testWidgets('Should show add task screen', (tester) async {
      await tester.runAsync(() async {
        final taskNotifier = MockTaskNotifier();

        when(taskNotifier.build()).thenAnswer((_) async {
          return Future.value(
            {
              '0': Task(
                name: 'Task Test',
                dateStr: currentDateStr,
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
            child: MaterialAppTest(
              home: AddEditTaskScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('add_task.title'.tr()), findsOneWidget);
        expect(find.text('add_task.cancel'.tr()), findsOneWidget);
        expect(find.text('add_task.add'.tr()), findsOneWidget);
      });
    });

    testWidgets('Should show edit task screen', (tester) async {
      await tester.runAsync(() async {
        final taskNotifier = MockTaskNotifier();

        when(taskNotifier.build()).thenAnswer((_) async {
          return Future.value(
            {
              '0': Task(
                name: 'Task Test',
                dateStr: currentDateStr,
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
            child: MaterialAppTest(
              home: AddEditTaskScreen(taskId: '0'),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('edit_task.title'.tr()), findsOneWidget);
        expect(find.text('edit_task.cancel'.tr()), findsOneWidget);
        expect(find.text('edit_task.edit'.tr()), findsOneWidget);
      });
    });

    // TODO: Find a way to test the cancel and add/edit buttons
    // Needs to be able to test with GoRouter

    // TODO: Find a way to test the not found redirect
    // Needs to be able to test with GoRouter
  });
}

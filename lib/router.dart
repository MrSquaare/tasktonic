import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/home.dart';
import 'pages/settings.dart';
import 'screens/add_task.dart';
import 'screens/delete_task.dart';
import 'screens/edit_task.dart';
import 'screens/language_settings.dart';
import 'screens/main.dart';
import 'screens/task_details.dart';
import 'widgets/page/bottom_sheet.dart';
import 'widgets/page/dialog.dart';

GoRouter createRouter() {
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return MainScreen(child: child);
        },
        routes: [
          GoRoute(
            parentNavigatorKey: shellNavigatorKey,
            path: '/',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: HomePage(),
              );
            },
            routes: [
              GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                path: 'task/:id/details',
                pageBuilder: (context, state) {
                  final taskId = state.pathParameters['id']!;
                  final taskIndex = int.parse(taskId);

                  return ModalBottomSheetPage(
                    builder: (context) =>
                        TaskDetailsScreen(taskIndex: taskIndex),
                    isScrollControlled: false,
                  );
                },
              )
            ],
          ),
          GoRoute(
            parentNavigatorKey: shellNavigatorKey,
            path: '/settings',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: SettingsPage(),
              );
            },
            routes: [
              GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                path: 'language',
                builder: (context, state) {
                  return const LanguageSettingsScreen();
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/task/add',
        builder: (context, state) {
          return AddTaskScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/task/:id/edit',
        builder: (context, state) {
          final taskId = state.pathParameters['id']!;
          final taskIndex = int.parse(taskId);

          return EditTaskScreen(taskIndex: taskIndex);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/task/:id/delete',
        pageBuilder: (context, state) {
          final taskId = state.pathParameters['id']!;
          final taskIndex = int.parse(taskId);

          return DialogPage(
            builder: (context) => DeleteTaskDialog(taskIndex: taskIndex),
          );
        },
      ),
    ],
  );
}

class MyAppRouter {
  static GoRouter? _instance;

  static GoRouter get instance => _instance ??= createRouter();

  static set instance(GoRouter? router) {
    _instance = router;
  }
}

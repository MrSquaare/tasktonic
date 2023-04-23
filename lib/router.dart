import 'package:go_router/go_router.dart';
import 'package:tasktonic/pages/home.dart';
import 'package:tasktonic/pages/language_settings.dart';
import 'package:tasktonic/pages/settings.dart';
import 'package:tasktonic/screens/main.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(
          path: "/",
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: HomePage(),
            );
          },
        ),
        GoRoute(
          path: "/settings",
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: SettingsPage(),
            );
          },
          routes: [
            GoRoute(
              path: "language",
              builder: (context, state) {
                return const LanguageSettingsPage();
              },
            ),
          ],
        ),
      ],
    )
  ],
);

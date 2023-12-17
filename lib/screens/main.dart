import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'navigation.home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: 'navigation.settings'.tr(),
          ),
        ],
        currentIndex: state.uri.toString() == '/' ? 0 : 1,
        onTap: (index) {
          context.go(index == 0 ? '/' : '/settings');
        },
      ),
    );
  }
}

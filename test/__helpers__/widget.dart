import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MaterialAppTest extends StatelessWidget {
  const MaterialAppTest({
    super.key,
    required this.home,
    this.navigatorObservers = const <NavigatorObserver>[],
  });

  final Widget home;
  final List<NavigatorObserver> navigatorObservers;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: home,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      navigatorObservers: navigatorObservers,
    );
  }
}

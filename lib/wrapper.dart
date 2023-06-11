import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale.dart';
import 'notification.dart';
import 'info.dart';

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({
    super.key,
    required this.child,
    this.localePath = 'assets/translations',
    this.supportedLocales = const [Locale('en'), Locale('fr')],
    this.fallbackLocale = const Locale('en'),
    this.perAppLocale = false,
    this.providerOverrides = const [],
    this.providerObservers,
  });

  final Widget child;
  final String localePath;
  final List<Locale> supportedLocales;
  final Locale fallbackLocale;
  final bool perAppLocale;
  final List<Override> providerOverrides;
  final List<ProviderObserver>? providerObservers;

  @override
  Widget build(BuildContext context) {
    return MyAppInfo(
      perAppLocale: perAppLocale,
      child: ProviderScope(
        overrides: providerOverrides,
        observers: providerObservers,
        child: EasyLocalization(
          path: localePath,
          supportedLocales: supportedLocales,
          fallbackLocale: fallbackLocale,
          saveLocale: !perAppLocale,
          child: LocaleListenerWidget(
            perAppLocale: perAppLocale,
            child: NotificationListenerWidget(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

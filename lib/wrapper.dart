import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale.dart';
import 'provider.dart';

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({
    super.key,
    required this.child,
    this.perAppLocale = false,
    this.providerOverrides = const [],
    this.providerObservers,
  });

  final Widget child;
  final bool perAppLocale;
  final List<Override> providerOverrides;
  final List<ProviderObserver>? providerObservers;

  @override
  Widget build(BuildContext context) {
    return MyAppProvider(
      perAppLocale: perAppLocale,
      child: ProviderScope(
        overrides: providerOverrides,
        observers: providerObservers,
        child: EasyLocalization(
          path: 'assets/translations',
          supportedLocales: const [Locale('en'), Locale('fr')],
          fallbackLocale: const Locale('en'),
          saveLocale: perAppLocale == false,
          child: LocaleListenerWidget(
            perAppLocale: perAppLocale,
            child: child,
          ),
        ),
      ),
    );
  }
}

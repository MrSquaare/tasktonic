import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale.dart';
import 'providers/android_info.dart';
import 'router.dart';
import 'screens/loading.dart';
import 'utilities/android_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  final androidInfo = await getAndroidInfo();
  final perAppLocale = hasPerAppLocale(androidInfo);

  runApp(
    MyAppWrapper(
      perAppLocale: perAppLocale,
      child: LocaleListenerWidget(
        child: MyApp(),
      ),
    ),
  );
}

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
    return ProviderScope(
      overrides: providerOverrides,
      observers: providerObservers,
      child: EasyLocalization(
        path: 'assets/translations',
        supportedLocales: const [Locale('en'), Locale('fr')],
        fallbackLocale: const Locale('en'),
        saveLocale: perAppLocale == false,
        child: child,
      ),
    );
  }
}

class MyApp extends ConsumerWidget with WidgetsBindingObserver {
  MyApp({super.key});

  bool _isAppReady(WidgetRef ref) {
    final androidInfo = ref.watch(androidInfoProvider);

    return androidInfo.isLoading == false;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAppReady = _isAppReady(ref);

    return MaterialApp.router(
      title: 'TaskTonic',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        return isAppReady ? child! : const LoadingScreen();
      },
    );
  }
}

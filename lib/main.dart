import 'package:android_intent_plus/android_intent.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

bool hasPerAppLocale(AndroidDeviceInfo? info) {
  if (info == null) return false;

  return info.version.sdkInt >= 33;
}

Future<AndroidDeviceInfo?> getAndroidInfo() async {
  try {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    return androidInfo;
  } catch (e) {
    return null;
  }
}

final androidInfoProvider = FutureProvider((ref) => getAndroidInfo());

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier(int initialValue) : super(initialValue);

  void increment() => state++;
}

final counterProvider = StateNotifierProvider(
  (ref) => CounterNotifier(0),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  final androidInfo = await getAndroidInfo();
  final perAppLocale = hasPerAppLocale(androidInfo);

  runApp(
    MyAppWrappers(
      perAppLocale: perAppLocale,
      child: LocaleListenerWidget(
        child: MyApp(),
      ),
    ),
  );
}

class MyAppWrappers extends StatelessWidget {
  const MyAppWrappers({
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

class LocaleListenerWidget extends StatefulWidget {
  const LocaleListenerWidget({super.key, required this.child});

  final Widget child;

  @override
  State<LocaleListenerWidget> createState() => _LocaleListenerWidgetState();
}

class _LocaleListenerWidgetState extends State<LocaleListenerWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);

    final locale = locales?.first;

    if (locale != null) {
      context.setLocale(Locale(locale.languageCode));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class MyApp extends ConsumerWidget with WidgetsBindingObserver {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: "/",
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MyRootNavigationPage(child: child);
        },
        routes: [
          GoRoute(
            path: "/",
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: MyHomePage(),
              );
            },
          ),
          GoRoute(
            path: "/settings",
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: MySettingsPage(),
              );
            },
            routes: [
              GoRoute(
                path: "language",
                builder: (context, state) {
                  return const MyLanguageSettingsPage();
                },
              ),
            ],
          ),
        ],
      )
    ],
  );

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
      routerConfig: _router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        return isAppReady ? child! : const MyLoadingPage();
      },
    );
  }
}

class MyLoadingPage extends StatelessWidget {
  const MyLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class MyRootNavigationPage extends StatelessWidget {
  const MyRootNavigationPage({super.key, required this.child});

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
            label: "navigation.home".tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: "navigation.settings".tr(),
          )
        ],
        currentIndex: state.location == "/" ? 0 : 1,
        onTap: (index) {
          context.go(index == 0 ? "/" : "/settings");
        },
      ),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    context.locale; // force rebuild when locale changes

    final counter = ref.watch(counterProvider);

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('home.title'.tr()),
      ),
      body: <Widget>[
        Text('home.counter_text'.tr()),
        Text('$counter').fontSize(32),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center).center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        tooltip: 'home.increment'.tr(),
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MySettingsPage extends ConsumerWidget {
  const MySettingsPage({super.key});

  void _openAndroidAppLocaleSettings() {
    const AndroidIntent(
      action: 'android.settings.APP_LOCALE_SETTINGS',
      data: 'package:fr.mrsquaare.tasktonic',
    ).launch();
  }

  void _goToLanguageSettings(BuildContext context, bool perAppLocale) {
    if (perAppLocale) {
      _openAndroidAppLocaleSettings();
    } else {
      context.go("/settings/language");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    context.locale; // force rebuild when locale changes

    final androidInfo = ref.read(androidInfoProvider).requireValue;
    final perAppLocale = hasPerAppLocale(androidInfo);

    return Scaffold(
      appBar: AppBar(
        title: Text('settings.title'.tr()),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('settings.languages'.tr()),
            onTap: () {
              _goToLanguageSettings(context, perAppLocale);
            },
          ),
        ],
      ),
    );
  }
}

class MyLanguageSettingsPage extends StatelessWidget {
  const MyLanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings.language.title'.tr()),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('English'),
            onTap: () {
              context.setLocale(const Locale('en'));
              context.pop();
            },
          ),
          ListTile(
            title: const Text('Français'),
            onTap: () {
              context.setLocale(const Locale('fr'));
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}

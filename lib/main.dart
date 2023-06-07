import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'models/adapters.dart';
import 'repositories/boxes.dart';
import 'router.dart';
import 'utilities/android_info.dart';
import 'wrapper.dart';

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'general_channel_group',
        channelKey: 'reminder_channel',
        channelName: 'Reminder',
        channelDescription: 'Reminder notifications',
        defaultColor: Colors.blue,
        ledColor: Colors.white,
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'general_channel_group',
        channelGroupName: 'General',
      )
    ],
    debug: true,
  );

  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();

  registerAdapters();
  await openBoxes();
}

Future<void> main() async {
  await setup();

  final androidInfo = await getAndroidInfo();
  final perAppLocale = hasPerAppLocale(androidInfo);

  runApp(
    MyAppWrapper(
      perAppLocale: perAppLocale,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = createRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
    );
  }
}

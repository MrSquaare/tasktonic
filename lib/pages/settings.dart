import 'package:android_intent_plus/android_intent.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../info.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _openAndroidAppLocaleSettings() {
    const AndroidIntent(
      action: 'android.settings.APP_LOCALE_SETTINGS',
      data: 'package:fr.mrsquaare.tasktonic',
    ).launch();
  }

  void _goToLanguageSettings(BuildContext context) {
    if (context.perAppLocale) {
      _openAndroidAppLocaleSettings();
    } else {
      context.go('/settings/language');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    context.locale; // force rebuild when locale changes

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
              _goToLanguageSettings(context);
            },
          ),
        ],
      ),
    );
  }
}

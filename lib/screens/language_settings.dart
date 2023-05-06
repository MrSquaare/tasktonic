import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

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

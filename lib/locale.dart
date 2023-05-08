import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class LocaleListenerWidget extends StatefulWidget {
  const LocaleListenerWidget({
    super.key,
    required this.child,
    this.perAppLocale = false,
  });

  final Widget child;
  final bool perAppLocale;

  @override
  State<LocaleListenerWidget> createState() => _LocaleListenerWidgetState();
}

class _LocaleListenerWidgetState extends State<LocaleListenerWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);

    if (!widget.perAppLocale) return;

    final locale = locales?.first;

    if (locale == null) return;

    context.setLocale(Locale(locale.languageCode));
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

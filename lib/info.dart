import 'package:flutter/widgets.dart';

class MyAppInfo extends InheritedWidget {
  const MyAppInfo({
    super.key,
    required super.child,
    this.perAppLocale = false,
  });

  final bool perAppLocale;

  static MyAppInfo of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyAppInfo>()!;
  }

  @override
  bool updateShouldNotify(MyAppInfo oldWidget) {
    return perAppLocale != oldWidget.perAppLocale;
  }
}

extension MyAppProviderBuildContext on BuildContext {
  bool get perAppLocale => MyAppInfo.of(this).perAppLocale;
}

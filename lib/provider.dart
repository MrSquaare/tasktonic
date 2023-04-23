import 'package:flutter/widgets.dart';

class MyAppProvider extends InheritedWidget {
  const MyAppProvider({
    super.key,
    required super.child,
    this.perAppLocale = false,
  });

  final bool perAppLocale;

  static MyAppProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyAppProvider>()!;
  }

  @override
  bool updateShouldNotify(MyAppProvider oldWidget) {
    return perAppLocale != oldWidget.perAppLocale;
  }
}

extension MyAppProviderBuildContext on BuildContext {
  bool get perAppLocale => MyAppProvider.of(this).perAppLocale;
}

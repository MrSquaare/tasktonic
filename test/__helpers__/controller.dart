import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

/// See [WidgetTester.longPress].
Future<void> longPress(
  WidgetTester tester,
  Finder finder, {
  int? pointer,
  int buttons = kPrimaryButton,
  bool warnIfMissed = true,
}) {
  return longPressAt(
    tester,
    tester.getCenter(
      finder,
      warnIfMissed: warnIfMissed,
      callee: 'longPress',
    ),
    pointer: pointer,
    buttons: buttons,
  );
}

/// See [WidgetTester.longPressAt].
Future<void> longPressAt(
  WidgetTester tester,
  Offset location, {
  int? pointer,
  int buttons = kPrimaryButton,
}) {
  return TestAsyncUtils.guard<void>(() async {
    final TestGesture gesture = await tester.startGesture(
      location,
      pointer: pointer,
      buttons: buttons,
    );
    // Apply fix as suggested here
    // https://github.com/flutter/flutter/issues/95203#issuecomment-1209135475
    await Future.delayed(kLongPressTimeout + kPressTimeout);
    await gesture.up();
  });
}

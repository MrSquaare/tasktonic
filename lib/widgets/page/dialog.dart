import 'package:flutter/material.dart';

class DialogPage<T> extends Page<T> {
  const DialogPage({
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    required this.builder,
    this.themes,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.anchorPoint,
  });

  /// See [DialogRoute]
  final WidgetBuilder builder;

  /// See [DialogRoute]
  final CapturedThemes? themes;

  /// See [RawDialogRoute.barrierColor]
  final Color? barrierColor;

  /// See [RawDialogRoute.barrierLabel]
  final String? barrierLabel;

  /// See [RawDialogRoute.barrierDismissible]
  final bool barrierDismissible;

  /// See [DialogRoute]
  final bool useSafeArea;

  /// See [RawDialogRoute.anchorPoint]
  final Offset? anchorPoint;

  @override
  Route<T> createRoute(BuildContext context) {
    return DialogRoute(
      context: context,
      settings: this,
      builder: this.builder,
      themes: this.themes,
      barrierColor: this.barrierColor,
      barrierLabel: this.barrierLabel,
      barrierDismissible: this.barrierDismissible,
      useSafeArea: this.useSafeArea,
      anchorPoint: this.anchorPoint,
    );
  }
}

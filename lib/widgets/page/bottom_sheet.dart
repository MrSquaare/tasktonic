import 'package:flutter/material.dart';

class ModalBottomSheetPage<T> extends Page<T> {
  const ModalBottomSheetPage({
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    required this.builder,
    this.capturedThemes,
    required this.isScrollControlled,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.modalBarrierColor,
    this.isDismissible = true,
    this.enableDrag = true,
    this.transitionAnimationController,
    this.anchorPoint,
    this.useSafeArea = false,
    this.barrierLabel,
  });

  /// See [ModalBottomSheetRoute.builder]
  final WidgetBuilder builder;

  /// See [ModalBottomSheetRoute.capturedThemes]
  final CapturedThemes? capturedThemes;

  /// See [ModalBottomSheetRoute.isScrollControlled]
  final bool isScrollControlled;

  /// See [ModalBottomSheetRoute.backgroundColor]
  final Color? backgroundColor;

  /// See [ModalBottomSheetRoute.elevation]
  final double? elevation;

  /// See [ModalBottomSheetRoute.shape]
  final ShapeBorder? shape;

  /// See [ModalBottomSheetRoute.clipBehavior]
  final Clip? clipBehavior;

  /// See [ModalBottomSheetRoute.constraints]
  final BoxConstraints? constraints;

  /// See [ModalBottomSheetRoute.modalBarrierColor]
  final Color? modalBarrierColor;

  /// See [ModalBottomSheetRoute.isDismissible]
  final bool isDismissible;

  /// See [ModalBottomSheetRoute.enableDrag]
  final bool enableDrag;

  /// See [ModalBottomSheetRoute.transitionAnimationController]
  final AnimationController? transitionAnimationController;

  /// See [ModalBottomSheetRoute.anchorPoint]
  final Offset? anchorPoint;

  /// See [ModalBottomSheetRoute.useSafeArea]
  final bool useSafeArea;

  /// See [ModalBottomSheetRoute.barrierLabel]
  final String? barrierLabel;

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute(
      settings: this,
      builder: this.builder,
      capturedThemes: this.capturedThemes,
      isScrollControlled: this.isScrollControlled,
      backgroundColor: this.backgroundColor,
      elevation: this.elevation,
      shape: this.shape,
      clipBehavior: this.clipBehavior,
      constraints: this.constraints,
      modalBarrierColor: this.modalBarrierColor,
      isDismissible: this.isDismissible,
      enableDrag: this.enableDrag,
      transitionAnimationController: this.transitionAnimationController,
      anchorPoint: this.anchorPoint,
      useSafeArea: this.useSafeArea,
      barrierLabel: this.barrierLabel,
    );
  }
}

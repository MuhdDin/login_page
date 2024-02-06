import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class AnimatorWidgetSlideLR extends StatelessWidget {
  const AnimatorWidgetSlideLR({
    super.key,
    required this.child,
    required this.time1,
    required this.time2,
    this.scale,
    this.curve,
    required this.animation,
    this.complete,
  });

  final Widget child;
  final int time1;
  final int time2;
  final double? scale;
  final Curve? curve;
  final int animation;
  final dynamic Function(Key?)? complete;

  @override
  Widget build(BuildContext context) {
    switch (animation) {
      case 0:
        return WidgetAnimator(
          onIncomingAnimationComplete: complete,
          incomingEffect: WidgetTransitionEffects.incomingSlideInFromLeft(
              delay: Duration(milliseconds: time1),
              scale: scale,
              curve: curve,
              duration: Duration(milliseconds: time2)),
          child: child,
        );
      case 1:
        return WidgetAnimator(
          incomingEffect: WidgetTransitionEffects.incomingSlideInFromBottom(
              delay: Duration(milliseconds: time1),
              scale: scale,
              curve: curve,
              duration: Duration(milliseconds: time2)),
          child: child,
        );

      default:
        return WidgetAnimator(
          incomingEffect: WidgetTransitionEffects.incomingSlideInFromLeft(
              delay: Duration(milliseconds: time1),
              scale: scale,
              curve: curve,
              duration: Duration(milliseconds: time2)),
          child: child,
        );
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide AnimatedBuilder;

import 'builders.dart';

sealed class AdaptiveLayoutAnimation extends StatelessWidget {
  const AdaptiveLayoutAnimation({
    required this.child,
    required this.animation,
    super.key,
  });

  final Widget child;
  final Animation<double> animation;

  static AnimationBuilder builder<T extends AdaptiveLayoutAnimation>() => (
        final Widget c,
        final Animation<double> a,
      ) {
        StayOnScreenAnimation stayOnScreen;
        FadeOutAnimation fadeOut;
        FadeInAnimation fadeIn;
        RightOutInAnimation rightOutIn;
        BottomToTopAnimation bottomToTop;
        TopToBottomAnimation topToBottom;
        LeftOutInAnimation leftOutIn;
        LeftInOutAnimation leftInOut;
        if ((stayOnScreen = StayOnScreenAnimation._(c, a)) is T) {
          return stayOnScreen;
        } else if ((fadeOut = FadeOutAnimation._(c, a)) is T) {
          return fadeOut;
        } else if ((fadeIn = FadeInAnimation._(c, a)) is T) {
          return fadeIn;
        } else if ((rightOutIn = RightOutInAnimation._(c, a)) is T) {
          return rightOutIn;
        } else if ((bottomToTop = BottomToTopAnimation._(c, a)) is T) {
          return bottomToTop;
        } else if ((topToBottom = TopToBottomAnimation._(c, a)) is T) {
          return topToBottom;
        } else if ((leftOutIn = LeftOutInAnimation._(c, a)) is T) {
          return leftOutIn;
        } else if ((leftInOut = LeftInOutAnimation._(c, a)) is T) {
          return leftInOut;
        } else {
          return throw Exception(
            'A type argument conforming to AdaptiveLayoutAnimation type '
            'bound should be specified when calling '
            '`AdaptiveLayoutAnimation.builder`.',
          );
        }
      };

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Animation<double>>('animation', animation),
    );
  }
}

/// Keep widget on screen while it is leaving.
final class StayOnScreenAnimation extends AdaptiveLayoutAnimation {
  const StayOnScreenAnimation({
    required super.child,
    required super.animation,
    super.key,
  });

  const StayOnScreenAnimation._(
    final Widget child,
    final Animation<double> animation,
  ) : super(child: child, animation: animation);

  @override
  Widget build(final BuildContext context) => FadeTransition(
        opacity: Tween<double>(begin: 1, end: 1).animate(animation),
        child: child,
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Animation<double>>('animation', animation),
    );
  }
}

/// Fade out animation.
final class FadeOutAnimation extends AdaptiveLayoutAnimation {
  const FadeOutAnimation({
    required super.child,
    required super.animation,
    super.key,
  });

  const FadeOutAnimation._(
    final Widget child,
    final Animation<double> animation,
  ) : super(child: child, animation: animation);

  @override
  Widget build(final BuildContext context) => FadeTransition(
        opacity: CurvedAnimation(
          parent: ReverseAnimation(animation),
          curve: Curves.easeInCubic,
        ),
        child: child,
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Animation<double>>('animation', animation),
    );
  }
}

/// Fade in animation.
final class FadeInAnimation extends AdaptiveLayoutAnimation {
  const FadeInAnimation({
    required super.child,
    required super.animation,
    super.key,
  });

  const FadeInAnimation._(final Widget child, final Animation<double> animation)
      : super(child: child, animation: animation);

  @override
  Widget build(final BuildContext context) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInCubic),
        child: child,
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Animation<double>>('animation', animation),
    );
  }
}

/// Animation from right off screen to on screen.
final class RightOutInAnimation extends AdaptiveLayoutAnimation {
  const RightOutInAnimation({
    required super.child,
    required super.animation,
    super.key,
  });

  const RightOutInAnimation._(
    final Widget child,
    final Animation<double> animation,
  ) : super(child: child, animation: animation);

  @override
  AnimatedWidget build(final BuildContext context) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Animation<double>>('animation', animation),
    );
  }
}

/// Animation from bottom offscreen up onto the screen.
final class BottomToTopAnimation extends AdaptiveLayoutAnimation {
  const BottomToTopAnimation({
    required super.child,
    required super.animation,
    super.key,
  });

  const BottomToTopAnimation._(
    final Widget child,
    final Animation<double> animation,
  ) : super(child: child, animation: animation);

  @override
  AnimatedWidget build(final BuildContext context) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Animation<double>>('animation', animation),
    );
  }
}

/// Animation from on the screen down off the screen.
final class TopToBottomAnimation extends AdaptiveLayoutAnimation {
  const TopToBottomAnimation({
    required super.child,
    required super.animation,
    super.key,
  });

  const TopToBottomAnimation._(
    final Widget child,
    final Animation<double> animation,
  ) : super(child: child, animation: animation);

  @override
  AnimatedWidget build(final BuildContext context) => SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, 1),
        ).animate(animation),
        child: child,
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Animation<double>>('animation', animation),
    );
  }
}

/// Animation from left off the screen into the screen.
final class LeftOutInAnimation extends AdaptiveLayoutAnimation {
  const LeftOutInAnimation({
    required super.child,
    required super.animation,
    super.key,
  });

  const LeftOutInAnimation._(
    final Widget child,
    final Animation<double> animation,
  ) : super(child: child, animation: animation);

  @override
  AnimatedWidget build(final BuildContext context) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Animation<double>>('animation', animation),
    );
  }
}

/// Animation from on screen to left off screen.
final class LeftInOutAnimation extends AdaptiveLayoutAnimation {
  const LeftInOutAnimation({
    required super.child,
    required super.animation,
    super.key,
  });

  const LeftInOutAnimation._(
    final Widget child,
    final Animation<double> animation,
  ) : super(child: child, animation: animation);

  @override
  AnimatedWidget build(final BuildContext context) => SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-1, 0),
        ).animate(animation),
        child: child,
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Animation<double>>('animation', animation),
    );
  }
}

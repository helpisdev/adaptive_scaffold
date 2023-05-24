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
        final Widget child,
        final Animation<double> animation,
      ) =>
          switch (T) {
            StayOnScreenAnimation =>
              StayOnScreenAnimation(animation: animation, child: child),
            FadeOutAnimation =>
              FadeOutAnimation(animation: animation, child: child),
            FadeInAnimation =>
              FadeInAnimation(animation: animation, child: child),
            RightOutInAnimation =>
              RightOutInAnimation(animation: animation, child: child),
            BottomToTopAnimation =>
              BottomToTopAnimation(animation: animation, child: child),
            TopToBottomAnimation =>
              TopToBottomAnimation(animation: animation, child: child),
            LeftOutInAnimation =>
              LeftOutInAnimation(animation: animation, child: child),
            LeftInOutAnimation =>
              LeftInOutAnimation(animation: animation, child: child),
            // The compiler should catch this, since parent class is sealed and
            // child classes are final, and T has to conform to
            // AdaptiveLayoutAnimation bound. Type bounds, sealed and final
            // classes are known at compile time, so it would be impossible to
            // pass a non-conforming type as a type argument. Unfortunately
            // though this does not currently work. The reason it does not work
            // is because type bounds are optional in Dart, and it would result
            // at a runtime error. If no-type bounds are provided when calling
            // the builder, it would be best if `dynamic` was inferred, cause
            // then it would be a compile time error (passing dynamic by hand
            // makes the compiler complain, but passing no type argument
            // doesn't).
            // TODO(helpisdev): Open an issue to the official Dart repo.
            _ => throw Exception(
                'A type argument conforming to AdaptiveLayoutAnimation type '
                'bound should be specified when calling '
                '`AdaptiveLayoutAnimation.builder`.',
              )
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

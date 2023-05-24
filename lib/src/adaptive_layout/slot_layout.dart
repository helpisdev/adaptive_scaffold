// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../adaptive_scaffold/builders.dart';
import '../breakpoints/breakpoint.dart';
import 'adaptive_layout.dart';

typedef SlotLayoutConfigRegistry = Map<Breakpoint, SlotLayoutConfig?>;
typedef SlotLayoutConfigRegistrar = MapEntry<Breakpoint, SlotLayoutConfig?>;

class SlotKey extends ValueKey<String> {
  const SlotKey(super.value);
}

enum SlotID implements SlotKey {
  primaryNavigation,
  secondaryNavigation,
  topNavigation,
  bottomNavigation,
  body,
  secondaryBody;

  @override
  String get value => name;
}

/// A Widget that takes a mapping of [SlotLayoutConfig]s to
/// [PredefinedBreakpoint]s and adds the appropriate [Widget] based on the
/// current screen size.
///
/// See also:
/// * [AdaptiveLayout], where [SlotLayout]s are assigned to placements on the
///   screen called "slots".
class SlotLayout extends StatefulWidget {
  /// Creates a [SlotLayout] widget.
  const SlotLayout({required this.config, super.key});

  /// Maps [PredefinedBreakpoint]s to [SlotLayoutConfig]s to determine what
  /// [Widget] to display on which condition of screens.
  ///
  /// The [SlotLayoutConfig]s in this map are nullable since some breakpoints
  /// apply to more open ranges and the nullability allows one to override the
  /// value at that Breakpoint to be null.
  ///
  /// [SlotLayout] picks the last [SlotLayoutConfig] whose corresponding
  /// [PredefinedBreakpoint.isActive] returns true.
  ///
  /// If two [PredefinedBreakpoint]s are active concurrently then the latter one
  /// defined in the map takes priority.
  final SlotLayoutConfigRegistry config;

  @override
  State<SlotLayout> createState() => _SlotState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<SlotLayoutConfigRegistry>(
        'config',
        config,
      ),
    );
  }
}

class _SlotState extends State<SlotLayout> with SingleTickerProviderStateMixin {
  SlotLayoutConfig? chosenWidget;

  @override
  Widget build(final BuildContext context) {
    chosenWidget = SlotLayoutConfig.pickWidget(context, widget.config);
    bool hasAnimation = false;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      layoutBuilder: (
        final Widget? currentChild,
        final List<Widget> previousChildren,
      ) =>
          Stack(
        children: <Widget>[
          if (hasAnimation && previousChildren.isNotEmpty)
            previousChildren.first,
          if (currentChild != null) currentChild,
        ],
      ),
      transitionBuilder: (
        final Widget child,
        final Animation<double> animation,
      ) {
        final SlotLayoutConfig configChild = child as SlotLayoutConfig;
        if (child.key == chosenWidget?.key) {
          return (configChild.inAnimation != null)
              ? child.inAnimation!.call(child, animation)
              : child;
        } else {
          if (configChild.outAnimation != null) {
            hasAnimation = true;
          }
          return (configChild.outAnimation != null)
              ? child.outAnimation!.call(child, ReverseAnimation(animation))
              : child;
        }
      },
      child: chosenWidget,
    );
  }
}

/// Defines how [SlotLayout] should display under a certain
/// [PredefinedBreakpoint].
class SlotLayoutConfig extends StatelessWidget {
  const SlotLayoutConfig({
    required this.builder,
    this.inAnimation,
    this.outAnimation,
    final SlotKey? key,
  }) : super(key: key);

  /// Creates a new [SlotLayoutConfig].
  ///
  /// Returns the child widget as is but holds properties to be accessed by
  /// other classes.
  const SlotLayoutConfig._({
    required this.builder,
    this.inAnimation,
    this.outAnimation,
    final SlotKey? key,
  }) : super(key: key);

  /// A wrapper for the children passed to [SlotLayout] to provide appropriate
  /// config information.
  ///
  /// Acts as a delegate to the abstract class [SlotLayoutConfig].
  /// It first takes a builder which returns the child Widget that [SlotLayout]
  /// eventually displays with an animation.
  ///
  /// It also takes an inAnimation and outAnimation to describe how the Widget
  /// should be animated as it is switched in or out from [SlotLayout]. These
  /// are both defined as functions that takes a [Widget] and an [Animation] and
  /// return a [Widget]. These functions are passed to the [AnimatedSwitcher]
  /// inside [SlotLayout] and are to be played when the child enters/exits.
  ///
  /// Last, it takes a required key. The key should be kept constant but unique
  /// as this key is what is used to let the [SlotLayout] know that a change has
  /// been made to its child.
  ///
  /// If you define a given animation phase, there may be multiple
  /// widgets being displayed depending on the phases you have chosen to
  /// animate.
  ///
  /// If you are using GlobalKeys, this may cause issues with the
  /// [AnimatedSwitcher].
  ///
  /// See also:
  ///
  ///  * [AnimatedWidget] and [ImplicitlyAnimatedWidget], which are commonly
  ///  used as the returned widget for the inAnimation and outAnimation
  ///  functions.
  ///  * [AnimatedSwitcher.defaultTransitionBuilder], which is what takes the
  ///   inAnimation and outAnimation.
  factory SlotLayoutConfig.from({
    required final SlotKey key,
    final AnimationBuilder? inAnimation,
    final AnimationBuilder? outAnimation,
    final WidgetBuilder? builder,
  }) =>
      SlotLayoutConfig._(
        builder: builder ?? emptyBuilder,
        inAnimation: inAnimation,
        outAnimation: outAnimation,
        key: key,
      );

  @override
  SlotKey? get key => super.key as SlotKey?;

  /// Given a context and a config, it returns the [SlotLayoutConfig] that will
  /// be chosen from the config under the context's conditions.
  static SlotLayoutConfig? pickWidget(
    final BuildContext context, [
    final SlotLayoutConfigRegistry? config,
  ]) {
    if (config == null) {
      return null;
    }
    SlotLayoutConfig? chosenWidget;
    config.forEach(
      (final Breakpoint breakpoint, final SlotLayoutConfig? pickedWidget) {
        if (breakpoint.isActive(context)) {
          chosenWidget = pickedWidget ?? chosenWidget;
        }
      },
    );
    return chosenWidget ?? SlotLayoutConfig.from(key: const SlotKey(''));
  }

  /// The child Widget that [SlotLayout] eventually returns with an animation.
  final WidgetBuilder builder;

  /// A function that provides the animation to be wrapped around the builder
  /// child as it is being moved in during a switch in [SlotLayout].
  ///
  /// See also:
  ///
  ///  * [AnimatedWidget] and [ImplicitlyAnimatedWidget], which are commonly
  ///  used as the returned widget.
  final AnimationBuilder? inAnimation;

  /// A function that provides the animation to be wrapped around the builder
  /// child as it is being moved in during a switch in [SlotLayout].
  ///
  /// See also:
  ///
  ///  * [AnimatedWidget] and [ImplicitlyAnimatedWidget], which are commonly
  ///  used as the returned widget.
  final AnimationBuilder? outAnimation;

  @override
  Widget build(final BuildContext context) => builder(context);

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<WidgetBuilder?>.has('builder', builder))
      ..add(
        ObjectFlagProperty<AnimationBuilder?>.has('inAnimation', inAnimation),
      )
      ..add(
        ObjectFlagProperty<AnimationBuilder?>.has('outAnimation', outAnimation),
      );
  }
}

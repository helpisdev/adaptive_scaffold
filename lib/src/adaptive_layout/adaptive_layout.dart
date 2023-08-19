// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:breakpoints_utilities/breakpoints_utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../adaptive_scaffold/adaptive_scaffold.dart';
import '../adaptive_scaffold/builders.dart';
import 'adaptive_layout_delegate.dart';
import 'slot_layout.dart';

/// Layout an app that adapts to different screens using predefined slots.
///
/// This widget separates the app window into predefined sections called
/// "slots". It lays out the app using the following kinds of slots (in order):
///
///  * [topNavigation], full width at the top. Must have defined size.
///  * [bottomNavigation], full width at the bottom. Must have defined size.
///  * [primaryNavigation], displayed on the beginning side of the app window
///    from the bottom of [topNavigation] to the top of [bottomNavigation]. Must
///    have defined size.
///  * [secondaryNavigation], displayed on the end side of the app window from
///    the bottom of [topNavigation] to the top of [bottomNavigation]. Must have
///    defined size.
///  * [body], first panel; fills the remaining space from the beginning side.
///    The main view should have flexible size (like a container).
///  * [secondaryBody], second panel; fills the remaining space from the end
///    side. The use of this property is common in apps that have a main view
///    and a detail view. The main view should have flexible size (like a
///    Container). This provides some automatic functionality with foldable
///    screens.
///
/// Slots can display differently under different screen conditions (such as
/// different widths), and each slot is defined with a [SlotLayout], which maps
/// [PredefinedBreakpoint]s to [SlotLayoutConfig], where [SlotLayoutConfig]
/// defines the content and transition.
///
/// [AdaptiveLayout] handles the placement of the slots on the app window and
/// animations regarding their macro movements.
///
/// ```dart
/// AdaptiveLayout(
///   primaryNavigation: SlotLayout(
///     config: {
///       Breakpoints.small: SlotLayout.from(
///         key: const Key('Primary Navigation Small'),
///         builder: (_) => const SizedBox.shrink(),
///       ),
///       Breakpoints.medium: SlotLayout.from(
///         inAnimation: leftOutIn,
///         key: const Key('Primary Navigation Medium'),
///         builder: (_) => AdaptiveScaffold.toNavigationRail(
///           destinations: destinations,
///         ),
///       ),
///       Breakpoints.large: SlotLayout.from(
///         key: const Key('Primary Navigation Large'),
///         inAnimation: leftOutIn,
///         builder: (_) => AdaptiveScaffold.toNavigationRail(
///           extended: true,
///           destinations: destinations,
///         ),
///       ),
///     },
///   ),
///   body: SlotLayout(
///     config: {
///       Breakpoints.small: SlotLayout.from(
///         key: const Key('Body Small'),
///         builder: (_) => ListView.builder(
///           itemCount: children.length,
///           itemBuilder: (_, idx) => children[idx]
///         ),
///       ),
///       Breakpoints.medium: SlotLayout.from(
///         key: const Key('Body Medium'),
///         builder: (_) => GridView.count(
///           crossAxisCount: 2,
///           children: children
///         ),
///       ),
///     },
///   ),
///   bottomNavigation: SlotLayout(
///     config: {
///       Breakpoints.small: SlotLayout.from(
///         key: const Key('Bottom Navigation Small'),
///         inAnimation: bottomToTop,
///         builder: (_) =>
///           AdaptiveScaffold.toBottomNavigationBar(
///             destinations: destinations,
///           ),
///       ),
///     },
///   ),
/// )
/// ```
///
/// See also:
///
///  * [SlotLayout], which handles the actual switching and animations between
///    elements based on [Breakpoint]s.
///  * [SlotLayoutConfig.from], which holds information regarding the actual
///    Widgets and the desired way to animate between switches. Often used
///     within [SlotLayout].
///  * [AdaptiveScaffold], which provides a more friendly API with less
///    customizability. and holds a preset of animations and helper builders.
///  * [Design Doc](https://flutter.dev/go/adaptive-layout-foldables).
///  * [Material Design 3 Specifications]
///  (https://m3.material.io/foundations/adaptive-design/overview).
class AdaptiveLayout extends StatefulWidget {
  /// Creates a const [AdaptiveLayout] widget.
  const AdaptiveLayout({
    super.key,
    this.topNavigation,
    this.primaryNavigation,
    this.secondaryNavigation,
    this.bottomNavigation,
    this.body,
    this.secondaryBody,
    this.bodyRatio,
    this.useInternalAnimations = true,
    this.bodyOrientation = Axis.horizontal,
  });

  /// The slot placed on the beginning side of the app window.
  ///
  /// The beginning side means the right when the ambient [Directionality] is
  /// [TextDirection.rtl] and on the left when it is [TextDirection.ltr].
  ///
  /// If the content is a flexibly sized Widget like [Container], wrap the
  /// content in a [SizedBox] or limit its size (width and height) by another
  /// method. See the builder in [StandardNavigationRail] for
  /// an example.
  final SlotLayout? primaryNavigation;

  /// The slot placed on the end side of the app window.
  ///
  /// The end side means the right when the ambient [Directionality] is
  /// [TextDirection.ltr] and on the left when it is [TextDirection.rtl].
  ///
  /// If the content is a flexibly sized Widget like [Container], wrap the
  /// content in a [SizedBox] or limit its size (width and height) by another
  /// method. See the builder in [StandardNavigationRail] for
  /// an example.
  final SlotLayout? secondaryNavigation;

  /// The slot placed on the top part of the app window.
  ///
  /// If the content is a flexibly sized Widget like [Container], wrap the
  /// content in a [SizedBox] or limit its size (width and height) by another
  /// method. See the builder in [StandardNavigationRail] for
  /// an example.
  final SlotLayout? topNavigation;

  /// The slot placed on the bottom part of the app window.
  ///
  /// If the content is a flexibly sized Widget like [Container], wrap the
  /// content in a [SizedBox] or limit its size (width and height) by another
  /// method. See the builder in [StandardNavigationRail] for
  /// an example.
  final SlotLayout? bottomNavigation;

  /// The slot that fills the rest of the space in the center.
  final SlotLayout? body;

  /// A supporting slot for [body].
  ///
  /// The [secondaryBody] as a sliding entrance animation by default.
  ///
  /// The default ratio for the split between [body] and [secondaryBody] is so
  /// that the split axis is in the center of the app window when there is no
  /// hinge and surrounding the hinge when there is one.
  final SlotLayout? secondaryBody;

  /// Defines the fractional ratio of [body] to the [secondaryBody].
  ///
  /// For example 0.3 would mean [body] takes up 30% of the available space
  /// and[secondaryBody] takes up the rest.
  ///
  /// If this value is null, the ratio is defined so that the split axis is in
  /// the center of the app window when there is no hinge and surrounding the
  /// hinge when there is one.
  final double? bodyRatio;

  /// Whether or not the developer wants the smooth entering slide transition on
  /// [secondaryBody].
  ///
  /// Defaults to true.
  final bool useInternalAnimations;

  /// The orientation of the body and secondaryBody. Either horizontal (side by
  /// side) or vertical (top to bottom).
  ///
  /// Defaults to Axis.horizontal.
  final Axis bodyOrientation;

  @override
  State<AdaptiveLayout> createState() => _LayoutState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('bodyRatio', bodyRatio))
      ..add(
        DiagnosticsProperty<bool>('internalAnimations', useInternalAnimations),
      )
      ..add(EnumProperty<Axis>('bodyOrientation', bodyOrientation));
  }
}

typedef AnimatingWidgetBucket = Set<SlotID>;
typedef ChosenWidgetRegistry = Map<SlotID, SlotLayoutConfig?>;
typedef SlotLayoutRegistrar = MapEntry<SlotID, SlotLayout?>;
typedef SlotLayoutRegistry = Map<SlotID, SlotLayout?>;
typedef SlotNotifier = ValueNotifier<SlotKey?>;
typedef SlotNotifierRegistry = Map<SlotID, SlotNotifier>;
typedef SlotSizeRegistry = Map<SlotID, Size?>;

class _LayoutState extends State<AdaptiveLayout> with TickerProviderStateMixin {
  late AnimationController controller;

  final AnimatingWidgetBucket isAnimating = <SlotID>{};
  final ChosenWidgetRegistry chosenWidgets = <SlotID, SlotLayoutConfig?>{};
  final SlotNotifierRegistry notifiers = <SlotID, SlotNotifier>{};
  final SlotSizeRegistry slotSizes = <SlotID, Size?>{};

  @override
  void initState() {
    super.initState();

    if (widget.useInternalAnimations) {
      controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      )..forward();
    } else {
      controller = AnimationController(
        duration: Duration.zero,
        vsync: this,
      );
    }

    for (final SlotID item in SlotID.values) {
      notifiers[item] = SlotNotifier(null)
        ..addListener(
          () {
            isAnimating.add(item);
            controller
              ..reset()
              ..forward();
          },
        );
    }

    controller.addStatusListener(
      (final AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          isAnimating.clear();
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final SlotLayoutRegistry slots = <SlotID, SlotLayout?>{
      SlotID.primaryNavigation: widget.primaryNavigation,
      SlotID.secondaryNavigation: widget.secondaryNavigation,
      SlotID.topNavigation: widget.topNavigation,
      SlotID.bottomNavigation: widget.bottomNavigation,
      SlotID.body: widget.body,
      SlotID.secondaryBody: widget.secondaryBody,
    };

    chosenWidgets.clear();

    slots.forEach(
      (final SlotID key, final SlotLayout? value) {
        chosenWidgets.putIfAbsent(
          key,
          () => SlotLayoutConfig.pickWidget(context, value?.config),
        );
      },
    );
    chosenWidgets.removeWhere(
      (final SlotID key, final SlotLayoutConfig? value) {
        if (value == null || value.key == const SlotKey('')) {
          return true;
        }
        final SlotLayoutConfigRegistry layout = slots[key]!.config;
        return !layout.entries.any(
          (final SlotLayoutConfigRegistrar el) {
            final bool flag = el.key.isActive(context) && el.value != null;
            return flag;
          },
        );
      },
    );
    final List<Widget> entries = slots.entries
        .map(
          (final SlotLayoutRegistrar entry) {
            final SlotLayout? child = entry.value;
            if (child != null) {
              return LayoutId(id: entry.key, child: child);
            }
          },
        )
        .whereType<Widget>()
        .toList();

    notifiers.forEach(
      (final SlotID key, final SlotNotifier notifier) {
        notifier.value = chosenWidgets[key]?.key;
      },
    );

    return CustomMultiChildLayout(
      delegate: AdaptiveLayoutDelegate(
        slots: slots,
        chosenWidgets: chosenWidgets,
        slotSizes: slotSizes,
        controller: controller,
        bodyRatio: widget.bodyRatio,
        isAnimating: isAnimating,
        useInternalAnimations: widget.useInternalAnimations,
        bodyOrientation: widget.bodyOrientation,
        isLTR: Directionality.of(context) == TextDirection.ltr,
        hinge: context.hinge,
      ),
      children: entries,
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<AnimationController>('controller', controller),
      )
      ..add(IterableProperty<SlotID>('isAnimating', isAnimating))
      ..add(DiagnosticsProperty<SlotNotifierRegistry>('notifiers', notifiers))
      ..add(DiagnosticsProperty<SlotSizeRegistry>('slotSizes', slotSizes))
      ..add(
        DiagnosticsProperty<ChosenWidgetRegistry>(
          'chosenWidgets',
          chosenWidgets,
        ),
      );
  }
}

extension HasHinge on DisplayFeature {
  bool get hasHinge =>
      (type == DisplayFeatureType.fold || type == DisplayFeatureType.hinge) &&
      bounds.left != 0;
}

extension GetHinge on BuildContext {
  Rect? get hinge {
    Rect? val;
    for (final DisplayFeature e in MediaQuery.of(this).displayFeatures) {
      if (e.hasHinge) {
        val = e.bounds;
      }
    }
    return val;
  }
}

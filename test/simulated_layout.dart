// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:adaptive_scaffold/adaptive_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'test_breakpoints.dart';

AnimatedWidget leftOutIn(
  final Widget child,
  final Animation<double> animation,
) =>
    SlideTransition(
      key: SlotKey('in-${child.key}'),
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );

AnimatedWidget leftInOut(
  final Widget child,
  final Animation<double> animation,
) =>
    SlideTransition(
      key: SlotKey('out-${child.key}'),
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1, 0),
      ).animate(animation),
      child: child,
    );

class TestScaffold extends StatefulWidget {
  const TestScaffold({
    super.key,
    this.initialIndex = 0,
    this.isAnimated = true,
  });

  final int? initialIndex;
  final bool isAnimated;

  static const List<NavigationDestination> destinations =
      <NavigationDestination>[
    NavigationDestination(
      key: Key('Inbox'),
      icon: Icon(Icons.inbox),
      label: 'Inbox',
    ),
    NavigationDestination(
      key: Key('Articles'),
      icon: Icon(Icons.article),
      label: 'Articles',
    ),
    NavigationDestination(
      key: Key('Chat'),
      icon: Icon(Icons.chat),
      label: 'Chat',
    ),
  ];

  @override
  State<TestScaffold> createState() => TestScaffoldState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isAnimated', isAnimated))
      ..add(IntProperty('initialIndex', initialIndex));
  }
}

class TestScaffoldState extends State<TestScaffold> {
  late int? index = widget.initialIndex;

  @override
  Widget build(final BuildContext context) => AdaptiveScaffold(
        config: AdaptiveScaffoldConfig(
          navigationRailConfig: NavigationRailConfig(
            selectedIndex: index,
            onDestinationSelected: (
              final int index,
              final NavigationDestination destination,
              final NavigationRailConfig config,
            ) {
              setState(
                () {
                  this.index = index;
                },
              );
            },
            destinations: TestScaffold.destinations,
            leadingExtended: const Text('leading_extended'),
            leading: const Text('leading_unextended'),
            trailing: const Text('trailing'),
          ),
          breakpointConfig: const BreakpointConfig(
            small: testBreakpoint0_800,
            medium: testBreakpoint800_1000,
            large: testBreakpoint1000,
          ),
          drawerConfig: const AdaptiveDrawerConfig(
            breakpoint: neverOnBreakpoint,
          ),
          useInternalAnimations: widget.isAnimated,
          bodyConfig: BodyConfig(
            small: (final _) => Container(color: Colors.red),
            body: (final _) => Container(color: Colors.green),
            large: (final _) => Container(color: Colors.blue),
            smallSecondary: (final _) => Container(color: Colors.red),
            secondary: (final _) => Container(color: Colors.green),
            largeSecondary: (final _) => Container(color: Colors.blue),
          ),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('index', index));
  }
}

enum SimulatedLayout {
  small(
    breakpoint: testBreakpoint400_800,
    navSlotKey: SlotID.bottomNavigation,
  ),
  medium(
    breakpoint: testBreakpoint800_1100,
    navSlotKey: SlotID.primaryNavigation,
  ),
  large(
    breakpoint: testBreakpoint1100,
    navSlotKey: SlotKey('primaryNavigation1'),
  );

  const SimulatedLayout({
    required this.breakpoint,
    required this.navSlotKey,
  });

  final double _height = 800;
  final Breakpoint breakpoint;
  final SlotKey navSlotKey;

  Size get size => Size(breakpoint.begin, _height);

  MaterialApp app({
    final int? initialIndex,
    final bool animations = true,
  }) =>
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: size),
          child: TestScaffold(
            initialIndex: initialIndex,
            isAnimated: animations,
          ),
        ),
      );

  SlotLayoutConfig _widget(final SlotKey key) => SlotLayoutConfig.from(
        key: key,
        builder: (final BuildContext context) => Container(),
      );

  MediaQuery get slot => MediaQuery(
        // ignore: deprecated_member_use
        data: MediaQueryData.fromView(WidgetsBinding.instance.window).copyWith(
          size: size,
        ),
        child: Theme(
          data: ThemeData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SlotLayout(
              config: <Breakpoint, SlotLayoutConfig>{
                testBreakpoint0_600: _widget(
                  const SlotKey('small'),
                ),
                testBreakpoint600_840: _widget(
                  const SlotKey('medium'),
                ),
                testBreakpoint840: _widget(
                  const SlotKey('large'),
                ),
                testBreakpoint0_600Mobile: _widget(
                  const SlotKey('smallMobile'),
                ),
                testBreakpoint600_840Mobile: _widget(
                  const SlotKey('mediumMobile'),
                ),
                testBreakpoint840Mobile: _widget(
                  const SlotKey('largeMobile'),
                ),
                testBreakpoint0_600Desktop: _widget(
                  const SlotKey('smallDesktop'),
                ),
                testBreakpoint600_840Desktop: _widget(
                  const SlotKey('mediumDesktop'),
                ),
                testBreakpoint840Desktop: _widget(
                  const SlotKey('largeDesktop'),
                ),
              },
            ),
          ),
        ),
      );
}

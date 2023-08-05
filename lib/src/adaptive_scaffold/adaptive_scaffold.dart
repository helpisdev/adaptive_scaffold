// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Stack;
import 'package:stack/stack.dart';
import 'package:utilities/utilities.dart';

import '../adaptive_layout/adaptive_layout.dart';
import '../adaptive_layout/slot_layout.dart';
import '../appbar.dart';
import '../breakpoints/breakpoint.dart';
import 'layout_slots.dart';
import 'scaffold_config.dart';

/// Implements the basic visual layout structure for
/// [Material Design 3](https://m3.material.io/foundations/adaptive-design/overview)
/// that adapts to a variety of screens.
///
/// [AdaptiveScaffold] provides a preset of layout, including positions and
/// animations, by handling macro changes in navigational elements and bodies
/// based on the current features of the screen, namely screen width and
/// platform. For example, the navigational elements would be a
/// [BottomNavigationBar] on a small mobile device or a [Drawer] on a small
/// desktop device and a [NavigationRail] on larger devices. When the app's size
/// changes, for example because its window is resized, the corresponding layout
/// transition is animated. The layout and navigation changes are dictated by
/// "breakpoints" which can be customized or overridden.
///
/// Also provides a variety of helper methods for navigational elements,
/// animations, and more.
///
/// [AdaptiveScaffold] is based on [AdaptiveLayout] but is easier to use at the
/// cost of being less customizable. Apps that would like more refined layout
/// and/or animation should use [AdaptiveLayout].
///
/// ```dart
/// AdaptiveScaffold(
///   config: AdaptiveScaffoldConfig(
///     destinations: const [
///       NavigationDestination(icon: Icon(Icons.inbox), label: 'Inbox'),
///       NavigationDestination(icon: Icon(Icons.article), label: 'Articles'),
///       NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
///       NavigationDestination(icon: Icon(Icons.video_call), label: 'Video'),
///     ],
///     smallBody: (_) => ListView.builder(
///       itemCount: children.length,
///       itemBuilder: (_, idx) => children[idx]
///     ),
///     body: (_) => GridView.count(crossAxisCount: 2, children: children),
///   ),
/// ),
/// ```
///
/// See also:
///
///  * [AdaptiveLayout], which is what this widget is built upon internally and
///   acts as a more customizable alternative.
///  * [SlotLayout], which handles switching and animations between elements
///   based on [Breakpoint]s.
///  * [SlotLayoutConfig.from], which holds information regarding Widgets and
///   the desired way to animate between switches. Often used within
///   [SlotLayout].
///  * [Design Doc](https://flutter.dev/go/adaptive-layout-foldables).
///  * [Material Design 3 Specifications](https://m3.material.io/foundations/adaptive-design/overview).
class AdaptiveScaffold extends StatefulWidget {
  /// Returns a const [AdaptiveScaffold] by passing information down to an
  /// [AdaptiveLayout].
  const AdaptiveScaffold({
    required this.config,
    super.key,
  });

  final AdaptiveScaffoldConfig config;

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<AdaptiveScaffoldConfig>('config', config),
    );
  }
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  late AdaptiveScaffoldConfig conf = widget.config;
  late int? index = widget.config.navigationRailConfig.selectedIndex;
  Key? _scrollbarKey;
  final Stack<int> _prevIndexes = Stack();

  static const BreakpointGenerator mobile = BreakpointGenerator.generate(
    type: DeviceType.mobile,
  );

  void changeIndex(final int index, final BuildContext context) {
    final NavigationRailConfig config = conf.navigationRailConfig;
    final NavigationDestination destination = config.destinations[index];

    changeIndexWithRailInfo(
      index: index,
      destination: destination,
      config: config,
      context: context,
    );
  }

  void changeIndexWithRailInfo({
    required final int index,
    required final NavigationDestination destination,
    required final NavigationRailConfig config,
    required final BuildContext context,
  }) {
    setState(
      () {
        this.index = index;
        _prevIndexes.push(index);
      },
    );
    conf.navigationRailConfig.onDestinationSelected?.call(
      index,
      destination,
      config,
    );
    Scaffold.of(context)
      ..closeDrawer()
      ..closeEndDrawer();
  }

  @override
  void initState() {
    super.initState();

    final Key? scrollbar = conf.scrollbarConfig.key;
    if (scrollbar != null) {
      _scrollbarKey = scrollbar;
    }
    _scrollbarKey ??= GlobalKey<State<AdaptiveScrollbar>>();
  }

  @override
  void didUpdateWidget(final AdaptiveScaffold oldWidget) {
    if (oldWidget.config != widget.config) {
      setState(
        () => conf = widget.config,
      );
    }

    final NavigationRailConfig rail = widget.config.navigationRailConfig;
    final NavigationRailConfig oldRail = oldWidget.config.navigationRailConfig;

    if (rail.selectedIndex != oldRail.selectedIndex) {
      setState(
        () => index = rail.selectedIndex,
      );
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    final AdaptiveDrawerConfig drawerConf = conf.drawerConfig;
    final AdaptiveAppBar? userDefinedAppBar = conf.appBar;
    final Breakpoint breakpoint = drawerConf.breakpoint;
    final bool useDrawer = breakpoint.isActive(context) &&
        (drawerConf.useDrawer || drawerConf.useEndDrawer);
    final Widget? drawer = _configDrawer(drawerConf);
    final Widget? endDrawer = _configDrawer(drawerConf, isEndDrawer: true);
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: context.width,
          height: context.height,
          child: Scaffold(
            onDrawerChanged: drawerConf.onDrawerChanged,
            onEndDrawerChanged: drawerConf.onEndDrawerChanged,
            drawerDragStartBehavior: drawerConf.drawerDragStartBehavior,
            drawerScrimColor: drawerConf.drawerScrimColor,
            drawerEdgeDragWidth: drawerConf.drawerEdgeDragWidth,
            drawerEnableOpenDragGesture: (useDrawer && drawer != null) &&
                drawerConf.drawerEnableOpenDragGesture,
            endDrawerEnableOpenDragGesture: (useDrawer && endDrawer != null) &&
                drawerConf.endDrawerEnableOpenDragGesture,
            floatingActionButton: conf.floatingActionButton,
            floatingActionButtonLocation: conf.floatingActionButtonLocation,
            floatingActionButtonAnimator: conf.floatingActionButtonAnimator,
            persistentFooterButtons: conf.persistentFooterButtons,
            persistentFooterAlignment: conf.persistentFooterAlignment,
            bottomSheet: conf.bottomSheet,
            backgroundColor: conf.backgroundColor,
            resizeToAvoidBottomInset: conf.resizeToAvoidBottomInset,
            primary: conf.primary,
            extendBody: conf.extendBody,
            extendBodyBehindAppBar: conf.extendBodyBehindAppBar,
            restorationId: conf.restorationId,
            appBar: AdaptiveAppBar.generateFrom(
              context: context,
              useDrawer: useDrawer,
              appBar: userDefinedAppBar,
            ),
            drawer: drawer,
            endDrawer: endDrawer,
            body: Builder(
              builder: (final BuildContext context) {
                final Widget child = WillPopScope(
                  onWillPop: () async {
                    if (_prevIndexes.isEmpty) {
                      return false;
                    }
                    final bool canPop = Navigator.of(context).canPop();
                    final bool r = await userDefinedAppBar?.onWillPopCb
                            ?.call(_prevIndexes.top()) ??
                        true;

                    if (canPop && r) {
                      setState(() {
                        index = _prevIndexes.pop();
                      });
                      return true;
                    }
                    return false;
                  },
                  child: AdaptiveLayout(
                    bodyOrientation: conf.bodyConfig.orientation,
                    bodyRatio: conf.bodyConfig.ratio,
                    useInternalAnimations: conf.useInternalAnimations,
                    primaryNavigation: PrimaryNavigation(
                      medium: conf.breakpointConfig.medium,
                      large: conf.breakpointConfig.large,
                      navigationRailConfig: _getNavRailConf(context),
                    ),
                    bottomNavigation: BottomNavigation.maybeEnable(
                      context: context,
                      drawerBreakpoint: drawerConf.breakpoint,
                      useDrawer: drawerConf.useDrawer,
                      small: conf.breakpointConfig.small,
                      destinations: conf.navigationRailConfig.destinations,
                      selectedIndex: index,
                      onDestinationSelected: (final int i) =>
                          changeIndex(i, context),
                      useSalomonBar: conf.useSalomonBar,
                      iconSize: conf.iconSize,
                    ),
                    body: SlotLayoutBody.primary(
                      config: conf.bodyConfig,
                      breakpoints: conf.breakpointConfig,
                    ),
                    secondaryBody: SlotLayoutBody.secondary(
                      config: conf.bodyConfig,
                      breakpoints: conf.breakpointConfig,
                    ),
                  ),
                );

                if (useDrawer && !mobile.isActive(context)) {
                  final AdaptiveScrollbarConfig scrollbar =
                      conf.scrollbarConfig;
                  final ScrollController controller =
                      scrollbar.controller ?? ScrollController();
                  final double desktopEnd = PredefinedBreakpoint.small.end!;
                  double minimumScrollbarWidth = breakpoint.end ?? desktopEnd;
                  if (minimumScrollbarWidth == double.infinity) {
                    minimumScrollbarWidth = max(context.width, desktopEnd);
                  }
                  return AdaptiveScrollbar(
                    key: _scrollbarKey,
                    position: ScrollbarPosition.bottom,
                    controller: controller,
                    width: scrollbar.width,
                    sliderHeight: scrollbar.sliderHeight,
                    sliderChild: scrollbar.sliderChild,
                    sliderDefaultColor: scrollbar.sliderDefaultColor,
                    sliderActiveColor: scrollbar.sliderActiveColor,
                    underColor: scrollbar.underColor,
                    underSpacing: scrollbar.underSpacing,
                    sliderSpacing: scrollbar.sliderSpacing,
                    scrollToClickDelta: scrollbar.scrollToClickDelta,
                    scrollToClickFirstDelay: scrollbar.scrollToClickFirstDelay,
                    scrollToClickOtherDelay: scrollbar.scrollToClickOtherDelay,
                    underDecoration: scrollbar.underDecoration,
                    sliderDecoration: scrollbar.sliderDecoration,
                    sliderActiveDecoration: scrollbar.sliderActiveDecoration,
                    child: SingleChildScrollView(
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: minimumScrollbarWidth,
                          maxWidth: minimumScrollbarWidth,
                          maxHeight: context.height,
                        ),
                        child: child,
                      ),
                    ),
                  );
                }
                return child;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget? _configDrawer(
    final AdaptiveDrawerConfig adaptiveDrawer, {
    final bool isEndDrawer = false,
  }) {
    bool hasDrawer = true;
    final Widget res = Builder(
      builder: (final BuildContext context) {
        final Widget? drawer = AdaptiveDrawer.maybeOf(
          context: context,
          config: adaptiveDrawer.copyWith(
            updates: <String, dynamic>{
              'selectedIndex': index,
              'onDestinationSelected': (final int index) =>
                  changeIndex(index, context),
            },
          ),
          navRailConf: _getNavRailConf(context),
          endDrawer: isEndDrawer,
        );
        hasDrawer = drawer != null;
        return drawer ?? const SizedBox.shrink();
      },
    );
    if (hasDrawer) {
      return res;
    }
    return null;
  }

  NavigationRailConfig _getNavRailConf(final BuildContext context) =>
      NavigationRailConfig(
        destinations: conf.navigationRailConfig.destinations,
        selectedIndex: index,
        onDestinationSelected: (
          final int index,
          final NavigationDestination destination,
          final NavigationRailConfig config,
        ) =>
            changeIndexWithRailInfo(
          index: index,
          destination: destination,
          config: config,
          context: context,
        ),
        width: conf.navigationRailConfig.width,
        extendedWidth: conf.navigationRailConfig.extendedWidth,
        leading: conf.navigationRailConfig.leading,
        leadingExtended: conf.navigationRailConfig.leadingExtended,
        trailing: conf.navigationRailConfig.trailing,
        key: conf.navigationRailConfig.key,
        backgroundColor: conf.navigationRailConfig.backgroundColor,
        elevation: conf.navigationRailConfig.elevation,
        groupAlignment: conf.navigationRailConfig.groupAlignment,
        labelType: conf.navigationRailConfig.labelType,
        unselectedLabelTextStyle:
            conf.navigationRailConfig.unselectedLabelTextStyle,
        selectedLabelTextStyle:
            conf.navigationRailConfig.selectedLabelTextStyle,
        unselectedIconTheme: conf.navigationRailConfig.unselectedIconTheme,
        selectedIconTheme: conf.navigationRailConfig.selectedIconTheme,
        useIndicator: conf.navigationRailConfig.useIndicator,
        indicatorColor: conf.navigationRailConfig.indicatorColor,
        indicatorShape: conf.navigationRailConfig.indicatorShape,
        padding: conf.navigationRailConfig.padding,
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<AdaptiveScaffoldConfig>('conf', conf))
      ..add(IntProperty('index', index));
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';

import '../adaptive_layout/slot_layout.dart';
import '../breakpoints/breakpoint.dart';
import 'animations.dart';
import 'builders.dart';
import 'scaffold_config.dart';

@immutable
class BottomNavigation extends SlotLayout {
  const BottomNavigation._({required super.config});

  @factory
  static BottomNavigation? maybeEnable({
    required final BuildContext context,
    required final Breakpoint drawerBreakpoint,
    required final bool useDrawer,
    required final Breakpoint small,
    required final List<NavigationDestination> destinations,
    final int? selectedIndex,
    final double? iconSize,
    final OnIndexChangedCallback? onDestinationSelected,
    final bool useSalomonBar = false,
  }) {
    if (!drawerBreakpoint.isActive(context) || !useDrawer) {
      final BottomBarBuilder builder = useSalomonBar
          ? SalomonBottomNavigationBar.builder
          : StandardBottomNavigationBar.builder;
      return BottomNavigation._(
        config: <Breakpoint, SlotLayoutConfig>{
          small: SlotLayoutConfig.from(
            key: SlotID.bottomNavigation,
            builder: (final BuildContext context) => builder(
              currentIndex: selectedIndex,
              destinations: destinations,
              onDestinationSelected: onDestinationSelected,
              iconSize: iconSize,
            ),
          ),
        },
      );
    }
    return null;
  }
}

class PrimaryNavigation extends SlotLayout {
  PrimaryNavigation({
    required final Breakpoint medium,
    required final Breakpoint large,
    required this.navigationRailConfig,
    super.key,
  }) : super(
          config: configBuilder(
            medium: medium,
            large: large,
            navigationRailConfig: navigationRailConfig,
          ),
        );

  final NavigationRailConfig navigationRailConfig;

  static SlotLayoutConfigRegistry configBuilder({
    required final Breakpoint medium,
    required final Breakpoint large,
    required final NavigationRailConfig navigationRailConfig,
  }) =>
      <Breakpoint, SlotLayoutConfig>{
        medium: layoutConfigBuilder(railConfig: navigationRailConfig),
        large: layoutConfigBuilder(
          railConfig: navigationRailConfig,
          extended: true,
        ),
      };

  @factory
  static SlotLayoutConfig layoutConfigBuilder({
    required final NavigationRailConfig railConfig,
    final bool extended = false,
  }) =>
      SlotLayoutConfig.from(
        key: extended
            ? const SlotKey('primaryNavigation1')
            : SlotID.primaryNavigation,
        builder: (final BuildContext context) => StandardNavigationRail.builder(
          railConf: railConfig,
          extended: extended,
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<NavigationRailConfig>(
        'navigationRailConfig',
        navigationRailConfig,
      ),
    );
  }
}

enum BodyConfigType {
  _none,
  standard,
  primarySmallBody,
  primaryBody,
  primaryLargeBody,
  secondarySmallBody,
  secondaryBody,
  secondaryLargeBody;

  SlotKey get key {
    switch (this) {
      case BodyConfigType._none:
        throw UnsupportedError('Cannot create a key for _none type.');
      case BodyConfigType.primarySmallBody:
        return const SlotKey('smallBody');
      case BodyConfigType.primaryBody:
        return SlotID.body;
      case BodyConfigType.primaryLargeBody:
        return const SlotKey('largeBody');
      case BodyConfigType.secondarySmallBody:
        return const SlotKey('smallSBody');
      case BodyConfigType.secondaryBody:
        return const SlotKey('sBody');
      case BodyConfigType.secondaryLargeBody:
        return const SlotKey('largeSBody');
      case BodyConfigType.standard:
        return const SlotKey('standard');
    }
  }
}

@immutable
class SlotBodyConfig extends SlotLayoutConfig {
  const SlotBodyConfig._({
    required super.builder,
    super.inAnimation,
    super.outAnimation,
    super.key,
  });

  factory SlotBodyConfig._default({
    required final SlotKey key,
    required final WidgetBuilder builder,
    final bool primary = true,
  }) =>
      SlotBodyConfig._(
        key: key,
        inAnimation:
            primary ? AdaptiveLayoutAnimation.builder<FadeInAnimation>() : null,
        outAnimation: primary
            ? AdaptiveLayoutAnimation.builder<FadeOutAnimation>()
            : AdaptiveLayoutAnimation.builder<StayOnScreenAnimation>(),
        builder: builder,
      );

  factory SlotBodyConfig.standard({required final WidgetBuilder builder}) =>
      SlotBodyConfig._default(
        key: BodyConfigType.standard.key,
        builder: builder,
      );

  factory SlotBodyConfig.primaryBody({required final WidgetBuilder builder}) =>
      SlotBodyConfig._default(
        key: BodyConfigType.primaryBody.key,
        builder: builder,
      );

  factory SlotBodyConfig.primarySmallBody({
    required final WidgetBuilder builder,
  }) =>
      SlotBodyConfig._default(
        key: BodyConfigType.primarySmallBody.key,
        builder: builder,
      );

  factory SlotBodyConfig.primaryLargeBody({
    required final WidgetBuilder builder,
  }) =>
      SlotBodyConfig._default(
        key: BodyConfigType.primaryLargeBody.key,
        builder: builder,
      );

  factory SlotBodyConfig.secondaryBody({
    required final WidgetBuilder builder,
  }) =>
      SlotBodyConfig._default(
        key: BodyConfigType.secondaryBody.key,
        primary: false,
        builder: builder,
      );

  factory SlotBodyConfig.secondarySmallBody({
    required final WidgetBuilder builder,
  }) =>
      SlotBodyConfig._default(
        key: BodyConfigType.secondarySmallBody.key,
        primary: false,
        builder: builder,
      );

  factory SlotBodyConfig.secondaryLargeBody({
    required final WidgetBuilder builder,
  }) =>
      SlotBodyConfig._default(
        key: BodyConfigType.secondaryLargeBody.key,
        primary: false,
        builder: builder,
      );

  @factory
  static SlotBodyConfig? maybeOfType({
    required final BodyConfigType type,
    final WidgetBuilder? builder,
  }) {
    final BodyConfigType internalType =
        builder == null ? BodyConfigType._none : type;
    switch (internalType) {
      case BodyConfigType.primarySmallBody:
        return SlotBodyConfig.primarySmallBody(builder: builder!);
      case BodyConfigType.primaryBody:
        return SlotBodyConfig.primaryBody(builder: builder!);
      case BodyConfigType.primaryLargeBody:
        return SlotBodyConfig.primaryLargeBody(builder: builder!);
      case BodyConfigType.secondarySmallBody:
        return SlotBodyConfig.secondarySmallBody(builder: builder!);
      case BodyConfigType.secondaryBody:
        return SlotBodyConfig.secondaryBody(builder: builder!);
      case BodyConfigType.secondaryLargeBody:
        return SlotBodyConfig.secondaryLargeBody(builder: builder!);
      case BodyConfigType.standard:
        return SlotBodyConfig.standard(builder: builder!);
      case BodyConfigType._none:
        break;
    }

    return null;
  }
}

@immutable
class SlotLayoutBody extends SlotLayout {
  const SlotLayoutBody._({
    required super.config,
    super.key,
  });

  factory SlotLayoutBody._default({
    required final BodyConfig config,
    required final BreakpointConfig breakpoints,
    final SlotKey? key,
    final bool primary = true,
  }) {
    late final WidgetBuilder? body;
    late final WidgetBuilder? smallBody;
    late final WidgetBuilder? largeBody;

    if (primary) {
      body = config.body;
      smallBody = config.small;
      largeBody = config.large;
    } else {
      body = config.secondary;
      smallBody = config.smallSecondary;
      largeBody = config.largeSecondary;
    }

    final WidgetBuilder? builder = body ?? smallBody ?? largeBody;

    return SlotLayoutBody._(
      config: <Breakpoint, SlotLayoutConfig?>{
        if (primary)
          PredefinedBreakpoint.standard: SlotBodyConfig.maybeOfType(
            type: BodyConfigType.standard,
            builder: body ?? builder,
          ),
        breakpoints.small: SlotBodyConfig.maybeOfType(
          type: primary
              ? BodyConfigType.primarySmallBody
              : BodyConfigType.secondarySmallBody,
          builder: smallBody ?? builder,
        ),
        breakpoints.medium: SlotBodyConfig.maybeOfType(
          type: primary
              ? BodyConfigType.primaryBody
              : BodyConfigType.secondaryBody,
          builder: body ?? builder,
        ),
        breakpoints.large: SlotBodyConfig.maybeOfType(
          type: primary
              ? BodyConfigType.primaryLargeBody
              : BodyConfigType.secondaryLargeBody,
          builder: largeBody ?? builder,
        ),
      },
      key: key,
    );
  }

  @factory
  static SlotLayoutBody? primary({
    required final BodyConfig config,
    required final BreakpointConfig breakpoints,
    final SlotKey? key,
  }) {
    final SlotLayoutBody body = SlotLayoutBody._default(
      key: key,
      config: config,
      breakpoints: breakpoints,
    );
    if (body.config.values.every(
      (final SlotLayoutConfig? val) => val != null,
    )) {
      return body;
    }
    return null;
  }

  @factory
  static SlotLayoutBody? secondary({
    required final BodyConfig config,
    required final BreakpointConfig breakpoints,
    final SlotKey? key,
  }) {
    final SlotLayoutBody body = SlotLayoutBody._default(
      key: key,
      primary: false,
      config: config,
      breakpoints: breakpoints,
    );
    if (body.config.values.every(
      (final SlotLayoutConfig? val) => val != null,
    )) {
      return body;
    }
    return null;
  }
}

@immutable
class AdaptiveDrawer extends NavigationDrawer {
  const AdaptiveDrawer({
    required super.children,
    this.shape,
    this.width,
    this.semanticLabel,
    super.backgroundColor,
    super.shadowColor,
    super.surfaceTintColor,
    super.elevation,
    super.indicatorColor,
    super.indicatorShape,
    super.onDestinationSelected,
    super.selectedIndex,
    super.key,
  });

  /// See [AdaptiveDrawerConfig.shape].
  final ShapeBorder? shape;

  /// See [AdaptiveDrawerConfig.width].
  final double? width;

  /// See [AdaptiveDrawerConfig.semanticLabel].
  final String? semanticLabel;

  @factory
  static Widget? maybeOf({
    required final BuildContext context,
    required final AdaptiveDrawerConfig config,
    required final NavigationRailConfig navRailConf,
    final bool endDrawer = false,
  }) {
    final bool useDrawer =
        (config.useDrawer && !endDrawer) || config.useEndDrawer;
    if (config.breakpoint.isActive(context) && useDrawer) {
      return (config.useEndDrawer
              ? config.customEndDrawer
              : config.customDrawer) ??
          AdaptiveDrawer(
            backgroundColor: config.backgroundColor,
            elevation: config.elevation,
            indicatorColor: config.indicatorColor,
            indicatorShape: config.indicatorShape,
            key: config.key,
            onDestinationSelected: config.onDestinationSelected,
            selectedIndex: config.selectedIndex,
            semanticLabel: config.semanticLabel,
            shadowColor: config.shadowColor,
            shape: config.shape,
            surfaceTintColor: config.surfaceTintColor,
            width: config.width,
            children: config.children ??
                navRailConf.destinations
                    .map(
                      (final NavigationDestination destination) =>
                          NavigationDrawerDestination(
                        icon: destination.icon,
                        label: LabelLarge(destination.label),
                        selectedIcon: destination.selectedIcon,
                      ),
                    )
                    .toList(),
          );
    }
    return null;
  }

  @override
  Widget build(final BuildContext context) {
    final Drawer drawer = super.build(context) as Drawer;

    return Drawer(
      backgroundColor: backgroundColor,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      elevation: elevation,
      shape: shape,
      width: width,
      semanticLabel: semanticLabel,
      child: drawer.child,
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ShapeBorder?>('shape', shape))
      ..add(DoubleProperty('width', width))
      ..add(StringProperty('semanticLabel', semanticLabel));
  }
}

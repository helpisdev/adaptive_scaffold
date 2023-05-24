import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:utilities/typography.dart';

import '../../adaptive_scaffold.dart';
import 'brick_layout.dart';

/// Signature fora callback that picks the desired bottom bar builder.
typedef BottomBarBuilder = Widget Function({
  required List<NavigationDestination> destinations,
  int? currentIndex,
  double? iconSize,
  Key? key,
  OnIndexChangedCallback? onDestinationSelected,
});

typedef AnimationBuilder = Widget Function(
  Widget child,
  Animation<double> animation,
);

/// Callback function for when the index of a [NavigationRail] changes.
WidgetBuilder get emptyBuilder => (final _) => const SizedBox();

/// Creates a Material 3 Design Spec abiding [NavigationRail] from a
/// list of [NavigationDestination]s.
///
/// Takes in a [NavigationRailConfig.selectedIndex] property for the current
/// selected item in the [NavigationRail] and [extended] for whether the
/// [NavigationRail] is extended or not.
class StandardNavigationRail extends StatelessWidget {
  const StandardNavigationRail.builder({
    required this.railConfig,
    this.extended = false,
    super.key,
  });

  final bool extended;
  final NavigationRailConfig railConfig;

  /// Public helper method to be used for creating a [NavigationRailDestination]
  /// from a [NavigationDestination].
  static NavigationRailDestination toRailDestination(
    final NavigationDestination destination,
  ) =>
      NavigationRailDestination(
        label: LabelLarge(destination.label),
        icon: destination.icon,
        selectedIcon: destination.selectedIcon,
      );

  void _onDestinationSelected(final int index) {
    railConfig.onDestinationSelected?.call(
      index,
      railConfig.destinations[index],
      railConfig,
    );
  }

  @override
  Widget build(final BuildContext context) => Builder(
        builder: (final BuildContext context) => Padding(
          padding: railConfig.padding,
          child: SizedBox(
            width:
                (extended && railConfig.width == 72) ? 192 : railConfig.width,
            height: MediaQuery.of(context).size.height,
            child: LayoutBuilder(
              builder: (
                final BuildContext context,
                final BoxConstraints constraints,
              ) {
                final NavigationRailThemeData navRailTheme =
                    Theme.of(context).navigationRailTheme;
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: NavigationRail(
                        backgroundColor: railConfig.backgroundColor ??
                            navRailTheme.backgroundColor,
                        destinations: railConfig.destinations
                            .map(toRailDestination)
                            .toList(),
                        elevation:
                            railConfig.elevation ?? navRailTheme.elevation,
                        extended: extended,
                        groupAlignment: railConfig.groupAlignment ??
                            navRailTheme.groupAlignment,
                        indicatorColor: railConfig.indicatorColor ??
                            navRailTheme.indicatorColor,
                        indicatorShape: railConfig.indicatorShape,
                        key: railConfig.key,
                        labelType:
                            railConfig.labelType ?? navRailTheme.labelType,
                        leading: extended
                            ? railConfig.leadingExtended
                            : railConfig.leading,
                        onDestinationSelected: _onDestinationSelected,
                        selectedIconTheme: railConfig.selectedIconTheme ??
                            navRailTheme.selectedIconTheme,
                        selectedIndex: railConfig.selectedIndex,
                        selectedLabelTextStyle:
                            railConfig.selectedLabelTextStyle ??
                                navRailTheme.selectedLabelTextStyle,
                        trailing: railConfig.trailing,
                        unselectedIconTheme: railConfig.unselectedIconTheme ??
                            navRailTheme.unselectedIconTheme,
                        unselectedLabelTextStyle:
                            railConfig.unselectedLabelTextStyle ??
                                navRailTheme.unselectedLabelTextStyle,
                        useIndicator: railConfig.useIndicator ??
                            navRailTheme.useIndicator,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<NavigationRailConfig>(
          'navigationRailConfig',
          railConfig,
        ),
      )
      ..add(DiagnosticsProperty<bool>('extended', extended));
  }
}

/// Public helper method to be used for creating a [BottomNavigationBar] from
/// a list of [NavigationDestination]s.
class StandardBottomNavigationBar extends StatelessWidget {
  const StandardBottomNavigationBar.builder({
    required this.destinations,
    this.onDestinationSelected,
    this.currentIndex = 0,
    final double? iconSize,
    super.key,
  }) : iconSize = iconSize ?? 24;

  final List<NavigationDestination> destinations;
  final OnIndexChangedCallback? onDestinationSelected;
  final double iconSize;
  final int? currentIndex;

  BottomNavigationBarItem _toBottomNavItem(final NavigationDestination dest) =>
      BottomNavigationBarItem(
        label: dest.label,
        icon: dest.icon,
        activeIcon: dest.selectedIcon,
      );

  @override
  Widget build(final BuildContext context) => Builder(
        builder: (final BuildContext context) => BottomNavigationBar(
          currentIndex: currentIndex ?? 0,
          iconSize: iconSize,
          items: destinations.map(_toBottomNavItem).toList(),
          onTap: onDestinationSelected,
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('currentIndex', currentIndex))
      ..add(
        IterableProperty<NavigationDestination>('destinations', destinations),
      )
      ..add(DoubleProperty('iconSize', iconSize))
      ..add(
        ObjectFlagProperty<OnIndexChangedCallback?>.has(
          'onDestinationSelected',
          onDestinationSelected,
        ),
      );
  }
}

/// Public helper method to be used for creating a [SalomonBottomBar] from
/// a list of [NavigationDestination]s.
class SalomonBottomNavigationBar extends StatelessWidget {
  const SalomonBottomNavigationBar.builder({
    required this.destinations,
    this.onDestinationSelected,
    this.currentIndex = 0,
    final double? iconSize,
    super.key,
  }) : iconSize = iconSize ?? 24;

  final List<NavigationDestination> destinations;
  final OnIndexChangedCallback? onDestinationSelected;
  final double iconSize;
  final int? currentIndex;

  SalomonBottomBarItem _toBottomNavItem(final NavigationDestination dest) =>
      SalomonBottomBarItem(
        title: dest.label,
        icon: dest.icon,
        activeIcon: dest.selectedIcon,
      );

  @override
  Widget build(final BuildContext context) => Builder(
        builder: (final BuildContext context) => SalomonBottomBar(
          currentIndex: currentIndex ?? 0,
          iconSize: iconSize,
          items: destinations.map(_toBottomNavItem).toList(),
          onTap: onDestinationSelected,
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('currentIndex', currentIndex))
      ..add(
        IterableProperty<NavigationDestination>('destinations', destinations),
      )
      ..add(DoubleProperty('iconSize', iconSize))
      ..add(
        ObjectFlagProperty<OnIndexChangedCallback?>.has(
          'onDestinationSelected',
          onDestinationSelected,
        ),
      );
  }
}

/// Public helper method to be used for creating a staggered grid following m3
/// specs from a list of [Widget]s.
class MaterialGrid extends StatelessWidget {
  const MaterialGrid.builder({
    this.children = const <Widget>[],
    this.breakpoints = const <Breakpoint>[
      PredefinedBreakpoint.small,
      PredefinedBreakpoint.medium,
      PredefinedBreakpoint.large,
    ],
    this.margin = 8,
    this.itemColumns = 1,
    super.key,
  });

  final List<Widget> children;
  final List<Breakpoint> breakpoints;
  final double margin;
  final int itemColumns;

  /// Gutter value between different parts of the body slot depending on
  /// material 3 design spec.
  static const double kMaterialGutterValue = 8;

  /// Margin value of the compact breakpoint layout according to the material
  /// design 3 spec.
  static const double kMaterialCompactMinMargin = 8;

  /// Margin value of the medium breakpoint layout according to the material
  /// design 3 spec.
  static const double kMaterialMediumMinMargin = 12;

  /// Margin value of the expanded breakpoint layout according to the material
  /// design 3 spec.
  static const double kMaterialExpandedMinMargin = 32;

  @override
  Widget build(final BuildContext context) => Builder(
        builder: (final BuildContext context) {
          Breakpoint? currentBreakpoint;
          for (final Breakpoint breakpoint in breakpoints) {
            if (breakpoint.isActive(context)) {
              currentBreakpoint = breakpoint;
            }
          }
          late final double thisMargin;

          if (currentBreakpoint == PredefinedBreakpoint.smallAndDown) {
            thisMargin = max(margin, kMaterialCompactMinMargin);
          } else if (currentBreakpoint == PredefinedBreakpoint.medium) {
            thisMargin = max(margin, kMaterialMediumMinMargin);
          } else {
            thisMargin = max(margin, kMaterialExpandedMinMargin);
          }
          return CustomScrollView(
            primary: false,
            controller: ScrollController(),
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(thisMargin),
                  child: BrickLayout(
                    columns: itemColumns,
                    columnSpacing: kMaterialGutterValue,
                    itemPadding: const EdgeInsets.only(
                      bottom: kMaterialGutterValue,
                    ),
                    children: children,
                  ),
                ),
              ),
            ],
          );
        },
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('margin', margin))
      ..add(IterableProperty<Breakpoint>('breakpoints', breakpoints))
      ..add(IntProperty('itemColumns', itemColumns))
      ..add(IterableProperty<Widget>('children', children));
  }
}

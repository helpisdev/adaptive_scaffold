import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:utilities/typography.dart';
import 'package:utilities/utils.dart';

import '../appbar.dart';
import '../bottom_bar.dart';
import '../breakpoints/breakpoint.dart';
import 'adaptive_scaffold.dart';

/// Signature for a callback that reacts to an index change.
typedef OnIndexChangedCallback = void Function(int index);

/// Signature for a callback that reacts to a navigation rail index change.
typedef OnNavigationRailIndexChangedCallback = void Function(
  int index,
  NavigationDestination destination,
  NavigationRailConfig config,
);

@immutable
class AdaptiveScaffoldConfig implements Copyable<AdaptiveScaffoldConfig> {
  /// Returns a const [AdaptiveScaffoldConfig].
  const AdaptiveScaffoldConfig({
    required this.navigationRailConfig,
    this.appBar,
    this.bodyConfig = const BodyConfig(),
    this.breakpointConfig = const BreakpointConfig(),
    this.drawerConfig = const AdaptiveDrawerConfig(),
    this.scrollbarConfig = const AdaptiveScrollbarConfig(),
    this.useInternalAnimations = true,
    this.useSalomonBar = false,
    this.iconSize,
    final GlobalKey<ScaffoldState>? scaffoldKey,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.restorationId,
  }) : _scaffoldKey = scaffoldKey ?? const _ScaffoldGlobalKey();

  /// If true, and [BottomNavigationBar] or [persistentFooterButtons]
  /// is specified, then the [BodyConfig.body] extends to the bottom of the
  /// [Scaffold], instead of only extending to the top of the
  /// [BottomNavigationBar] or the [persistentFooterButtons].
  ///
  /// If true, a [MediaQuery] widget whose bottom padding matches the height
  /// of the [BottomNavigationBar] will be added above the scaffold's
  /// [BodyConfig.body].
  ///
  /// This property is often useful when the [BottomNavigationBar] has
  /// a non-rectangular shape, like [CircularNotchedRectangle], which
  /// adds a [FloatingActionButton] sized notch to the top edge of the bar.
  /// In this case specifying `extendBody: true` ensures that scaffold's
  /// body will be visible through the bottom navigation bar's notch.
  ///
  /// See also:
  ///
  ///  * [extendBodyBehindAppBar], which extends the height of the body
  ///    to the top of the scaffold.
  final bool extendBody;

  /// If true, and an [appBar] is specified, then the height of the
  /// [BodyConfig.body] is extended to include the height of the app bar and the
  /// top of the body is aligned with the top of the app bar.
  ///
  /// This is useful if the app bar's [AppBar.backgroundColor] is not
  /// completely opaque.
  ///
  /// This property is false by default. It must not be null.
  ///
  /// See also:
  ///
  ///  * [extendBody], which extends the height of the body to the bottom
  ///    of the scaffold.
  final bool extendBodyBehindAppBar;

  /// A button displayed floating above [BodyConfig.body], in the bottom right
  /// corner.
  ///
  /// Typically a [FloatingActionButton].
  final Widget? floatingActionButton;

  /// Responsible for determining where the [floatingActionButton] should go.
  ///
  /// If null, the [ScaffoldState] will use the default location,
  /// [FloatingActionButtonLocation.endFloat].
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Animator to move the [floatingActionButton] to a new
  /// [floatingActionButtonLocation].
  ///
  /// If null, the [ScaffoldState] will use the default animator,
  /// [FloatingActionButtonAnimator.scaling].
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// A set of buttons that are displayed at the bottom of the scaffold.
  ///
  /// Typically this is a list of [TextButton] widgets. These buttons are
  /// persistently visible, even if the [BodyConfig.body] of the scaffold
  /// scrolls.
  ///
  /// These widgets will be wrapped in an [OverflowBar].
  ///
  /// The [persistentFooterButtons] are rendered above the
  /// [BottomNavigationBar] but below the [BodyConfig.body].
  final List<Widget>? persistentFooterButtons;

  /// The alignment of the [persistentFooterButtons] inside the [OverflowBar].
  ///
  /// Defaults to [AlignmentDirectional.centerEnd].
  final AlignmentDirectional persistentFooterAlignment;

  /// The color of the [Material] widget that underlies the entire Scaffold.
  ///
  /// The theme's [ThemeData.scaffoldBackgroundColor] by default.
  final Color? backgroundColor;

  /// The persistent bottom sheet to display.
  ///
  /// A persistent bottom sheet shows information that supplements the primary
  /// content of the app. A persistent bottom sheet remains visible even when
  /// the user interacts with other parts of the app.
  ///
  /// A closely related widget is a modal bottom sheet, which is an alternative
  /// to a menu or a dialog and prevents the user from interacting with the rest
  /// of the app. Modal bottom sheets can be created and displayed with the
  /// [showModalBottomSheet] function.
  ///
  /// Unlike the persistent bottom sheet displayed by [showBottomSheet]
  /// this bottom sheet is not a [LocalHistoryEntry] and cannot be dismissed
  /// with the scaffold appbar's back button.
  ///
  /// If a persistent bottom sheet created with [showBottomSheet] is already
  /// visible, it must be closed before building the Scaffold with a new
  /// [bottomSheet].
  ///
  /// The value of [bottomSheet] can be any widget at all. It's unlikely to
  /// actually be a [BottomSheet], which is used by the implementations of
  /// [showBottomSheet] and [showModalBottomSheet]. Typically it's a widget
  /// that includes [Material].
  ///
  /// See also:
  ///
  ///  * [showBottomSheet], which displays a bottom sheet as a route that can
  ///    be dismissed with the scaffold's back button.
  ///  * [showModalBottomSheet], which displays a modal bottom sheet.
  ///  * [BottomSheetThemeData], which can be used to customize the default
  ///    bottom sheet property values when using a [BottomSheet].
  final Widget? bottomSheet;

  /// If true the [BodyConfig.body] and the scaffold's floating widgets should
  /// size themselves to avoid the onscreen keyboard whose height is defined by
  /// the ambient [MediaQuery]'s [MediaQueryData.viewInsets] `bottom` property.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// scaffold, the body can be resized to avoid overlapping the keyboard, which
  /// prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true.
  final bool? resizeToAvoidBottomInset;

  /// Whether this scaffold is being displayed at the top of the screen.
  ///
  /// If true then the height of the [appBar] will be extended by the height
  /// of the screen's status bar, i.e. the top padding for [MediaQuery].
  ///
  /// The default value of this property, like the default value of
  /// [AppBar.primary], is true.
  final bool primary;

  /// Restoration ID to save and restore the state of the [Scaffold].
  ///
  /// If it is non-null, the scaffold will persist and restore whether the
  /// [AdaptiveDrawerConfig.customDrawer] and
  /// [AdaptiveDrawerConfig.customEndDrawer] was open or closed.
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  final String? restorationId;

  /// Key for the underlying [Scaffold] used within the [AdaptiveScaffold] to
  /// gain programmatic access to its components.
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  /// [AdaptiveScaffold] body configuration.
  final BodyConfig bodyConfig;

  /// [AdaptiveScaffold] breakpoint configuration.
  final BreakpointConfig breakpointConfig;

  /// [AdaptiveScaffold] scrollbar configuration.
  final AdaptiveScrollbarConfig scrollbarConfig;

  /// [AdaptiveScaffold] navigation rail configuration.
  final NavigationRailConfig navigationRailConfig;

  /// [AdaptiveScaffold] adaptive drawer configuration.
  final AdaptiveDrawerConfig drawerConfig;

  /// The icon size of the bottom bar icons.
  final double? iconSize;

  /// Whether or not the developer wants the smooth entering slide transition on
  /// secondaryBody.
  ///
  /// Defaults to true.
  final bool useInternalAnimations;

  /// Whether to use a [SalomonBottomBar] over a [BottomNavigationBar] if a
  /// bottom is to be used.
  ///
  /// Defaults to true.
  final bool useSalomonBar;

  /// Option to override the default [AppBar] when using drawer in desktop
  /// small.
  final AdaptiveAppBar? appBar;

  @override
  AdaptiveScaffoldConfig copy() => AdaptiveScaffoldConfig(
        navigationRailConfig: navigationRailConfig,
        bodyConfig: bodyConfig,
        breakpointConfig: breakpointConfig,
        appBar: appBar,
        useInternalAnimations: useInternalAnimations,
        useSalomonBar: useSalomonBar,
        scrollbarConfig: scrollbarConfig,
        scaffoldKey: const _ScaffoldGlobalKey(),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
        persistentFooterButtons: persistentFooterButtons,
        persistentFooterAlignment: persistentFooterAlignment,
        bottomSheet: bottomSheet,
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        primary: primary,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        restorationId: restorationId,
        drawerConfig: drawerConfig,
        iconSize: iconSize,
      );

  @override
  AdaptiveScaffoldConfig copyWith({
    final JSON updates = const <String, dynamic>{},
    final AdaptiveScaffoldConfig? other,
  }) =>
      AdaptiveScaffoldConfig(
        appBar: updates['appBar'] ??
            updates['app_bar'] ??
            updates['appbar'] ??
            other?.appBar ??
            appBar,
        scaffoldKey: updates['scaffoldKey'] ??
            updates['scaffold_key'] ??
            other?.scaffoldKey ??
            const _ScaffoldGlobalKey(),
        useInternalAnimations: updates['useInternalAnimations'] ??
            updates['use_internal_animations'] ??
            other?.useInternalAnimations ??
            useInternalAnimations,
        bodyConfig: updates['bodyConfig'] ??
            updates['body_config'] ??
            other?.bodyConfig ??
            bodyConfig,
        breakpointConfig: updates['breakpointConfig'] ??
            updates['breakpoint_config'] ??
            other?.breakpointConfig ??
            breakpointConfig,
        navigationRailConfig: updates['navigationRailConfig'] ??
            updates['navigation_rail_config'] ??
            other?.navigationRailConfig ??
            navigationRailConfig,
        useSalomonBar: updates['useSalomonBar'] ??
            updates['use_salomon_bar'] ??
            other?.useSalomonBar ??
            useSalomonBar,
        scrollbarConfig: updates['scrollbarConfig'] ??
            updates['scrollbar_config'] ??
            other?.scrollbarConfig ??
            scrollbarConfig,
        floatingActionButton: updates['floatingActionButton'] ??
            updates['floating_action_button'] ??
            other?.floatingActionButton ??
            floatingActionButton,
        floatingActionButtonLocation: updates['floatingActionButtonLocation'] ??
            updates['floating_action_button_location'] ??
            other?.floatingActionButtonLocation ??
            floatingActionButtonLocation,
        floatingActionButtonAnimator: updates['floatingActionButtonAnimator'] ??
            updates['floating_action_button_animator'] ??
            other?.floatingActionButtonAnimator ??
            floatingActionButtonAnimator,
        persistentFooterButtons: updates['persistentFooterButtons'] ??
            updates['persistent_footer_buttons'] ??
            other?.persistentFooterButtons ??
            persistentFooterButtons,
        persistentFooterAlignment: updates['persistentFooterAlignment'] ??
            updates['persistent_footer_alignment'] ??
            other?.persistentFooterAlignment ??
            persistentFooterAlignment,
        bottomSheet: updates['bottomSheet'] ??
            updates['bottom_sheet'] ??
            other?.bottomSheet ??
            bottomSheet,
        backgroundColor: updates['backgroundColor'] ??
            updates['background_color'] ??
            other?.backgroundColor ??
            backgroundColor,
        resizeToAvoidBottomInset: updates['resizeToAvoidBottomInset'] ??
            updates['resize_to_avoid_bottom_inset'] ??
            other?.resizeToAvoidBottomInset ??
            resizeToAvoidBottomInset,
        primary: updates['primary'] ?? other?.primary ?? primary,
        extendBody: updates['extendBody'] ??
            updates['extend_body'] ??
            other?.extendBody ??
            extendBody,
        extendBodyBehindAppBar: updates['extendBodyBehindAppBar'] ??
            updates['extend_body_behind_app_bar'] ??
            other?.extendBodyBehindAppBar ??
            extendBodyBehindAppBar,
        restorationId: updates['restorationId'] ??
            updates['restoration_id'] ??
            other?.restorationId ??
            restorationId,
        drawerConfig: updates['drawerConfig'] ??
            updates['drawer_config'] ??
            other?.drawerConfig ??
            drawerConfig,
        iconSize: updates['iconSize'] ??
            updates['icon_size'] ??
            other?.iconSize ??
            iconSize,
      );

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is AdaptiveScaffoldConfig &&
          runtimeType == other.runtimeType &&
          navigationRailConfig == other.navigationRailConfig &&
          bodyConfig == other.bodyConfig &&
          breakpointConfig == other.breakpointConfig &&
          appBar == other.appBar &&
          useInternalAnimations == other.useInternalAnimations &&
          useSalomonBar == other.useSalomonBar &&
          scrollbarConfig == other.scrollbarConfig &&
          scaffoldKey == other.scaffoldKey &&
          floatingActionButton == other.floatingActionButton &&
          floatingActionButtonLocation == other.floatingActionButtonLocation &&
          floatingActionButtonAnimator == other.floatingActionButtonAnimator &&
          persistentFooterButtons == other.persistentFooterButtons &&
          persistentFooterAlignment == other.persistentFooterAlignment &&
          bottomSheet == other.bottomSheet &&
          backgroundColor == other.backgroundColor &&
          resizeToAvoidBottomInset == other.resizeToAvoidBottomInset &&
          primary == other.primary &&
          extendBody == other.extendBody &&
          extendBodyBehindAppBar == other.extendBodyBehindAppBar &&
          restorationId == other.restorationId &&
          drawerConfig == other.drawerConfig &&
          iconSize == other.iconSize;

  @override
  int get hashCode =>
      navigationRailConfig.hashCode ^
      bodyConfig.hashCode ^
      breakpointConfig.hashCode ^
      useInternalAnimations.hashCode ^
      useSalomonBar.hashCode ^
      scrollbarConfig.hashCode ^
      scaffoldKey.hashCode ^
      floatingActionButton.hashCode ^
      floatingActionButtonLocation.hashCode ^
      floatingActionButtonAnimator.hashCode ^
      persistentFooterButtons.hashCode ^
      persistentFooterAlignment.hashCode ^
      bottomSheet.hashCode ^
      backgroundColor.hashCode ^
      resizeToAvoidBottomInset.hashCode ^
      primary.hashCode ^
      extendBody.hashCode ^
      extendBodyBehindAppBar.hashCode ^
      restorationId.hashCode ^
      drawerConfig.hashCode ^
      iconSize.hashCode ^
      appBar.hashCode;
}

@immutable
class NavigationRailConfig implements Copyable<NavigationRailConfig> {
  const NavigationRailConfig({
    required this.destinations,
    this.selectedIndex = 0,
    final double? width,
    final double? extendedWidth,
    this.leading,
    this.leadingExtended,
    this.trailing,
    this.key,
    this.backgroundColor,
    this.onDestinationSelected,
    this.elevation,
    this.groupAlignment,
    this.labelType = NavigationRailLabelType.none,
    this.unselectedLabelTextStyle,
    this.selectedLabelTextStyle,
    this.unselectedIconTheme,
    this.selectedIconTheme,
    this.useIndicator,
    this.indicatorColor,
    this.indicatorShape,
    this.padding = const EdgeInsets.all(8.0),
  })  : width = width ?? 72,
        extendedWidth = extendedWidth ?? 192,
        assert(
          destinations.length >= 2,
          'At least two navigation rail destinations must be provided.',
        ),
        assert(
          selectedIndex == null ||
              (selectedIndex >= 0 && selectedIndex < destinations.length),
          'Selected index must either be unspecified (null) or within '
          'destinations index range (0 - destinations.length).',
        ),
        assert(
          elevation == null || elevation > 0,
          'elevation must either be unspecified (null) or greater than 0.',
        ),
        assert(
          width == null || width > 0,
          'width must either be unspecified (null) or greater than 0.',
        ),
        assert(
          extendedWidth == null || extendedWidth > 0,
          'extendedWidth must either be unspecified (null) '
          'or greater than 0.',
        ),
        assert(
          (width == null || extendedWidth == null) || extendedWidth >= width,
          'If both width and extendedWidth are specified (not null), '
          'then extendedWidth must be equal or greater than width.',
        );

  final Key? key;

  final EdgeInsetsGeometry padding;

  /// The destinations to be used in navigation items. These are converted to
  /// [NavigationRailDestination]s and [BottomNavigationBarItem]s or
  /// [SalomonBottomBarItem]s and inserted into the appropriate places. If
  /// passing destinations, you must also pass a selected index to be used by
  /// the [NavigationRail].
  final List<NavigationDestination> destinations;

  /// The index to be used by the [NavigationRail].
  final int? selectedIndex;

  /// Option to display a leading widget at the top of the navigation rail
  /// at the middle breakpoint.
  final Widget? leading;

  /// Option to display a leading widget at the top of the navigation rail
  /// at the largest breakpoint.
  final Widget? leadingExtended;

  /// Option to display a trailing widget below the destinations of the
  /// navigation rail at the largest breakpoint.
  final Widget? trailing;

  /// Callback function for when the index of a [NavigationRail] changes.
  final OnNavigationRailIndexChangedCallback? onDestinationSelected;

  /// The width used for the internal [NavigationRail] at the medium
  /// [Breakpoint].
  final double width;

  /// The width used for the internal extended [NavigationRail] at the large
  /// [Breakpoint].
  final double extendedWidth;

  /// Sets the color of the Container that holds all of the [NavigationRail]'s
  /// contents.
  ///
  /// The default value is [NavigationRailThemeData.backgroundColor]. If
  /// [NavigationRailThemeData.backgroundColor] is null, then the default value
  /// is based on [ColorScheme.surface] of [ThemeData.colorScheme].
  final Color? backgroundColor;

  /// The rail's elevation or z-coordinate.
  ///
  /// If [Directionality] is [intl.TextDirection.LTR], the inner side is the
  /// right side, and if [Directionality] is [intl.TextDirection.RTL], it is
  /// the left side.
  ///
  /// The default value is 0.
  final double? elevation;

  /// The vertical alignment for the group of [destinations] within the rail.
  ///
  /// The [NavigationRailDestination]s are grouped together with the
  /// [trailing] widget, between the [leadingExtended] or
  /// [leading] widget and the bottom of the rail.
  ///
  /// The value must be between -1.0 and 1.0.
  ///
  /// If [groupAlignment] is -1.0, then the items are aligned to the top. If
  /// [groupAlignment] is 0.0, then the items are aligned to the center. If
  /// [groupAlignment] is 1.0, then the items are aligned to the bottom.
  ///
  /// The default is -1.0.
  ///
  /// See also:
  ///   * [Alignment.y]
  ///
  final double? groupAlignment;

  /// Defines the layout and behavior of the labels for the default, unextended
  /// [NavigationRail].
  ///
  /// When a navigation rail is `extended`, the labels are always shown.
  ///
  /// The default value is [NavigationRailThemeData.labelType]. If
  /// [NavigationRailThemeData.labelType] is null, then the default value is
  /// [NavigationRailLabelType.none].
  ///
  /// See also:
  ///
  ///   * [NavigationRailLabelType] for information on the meaning of different
  ///   types.
  final NavigationRailLabelType? labelType;

  /// The [TextStyle] of a destination's label when it is unselected.
  ///
  /// When one of the [destinations] is selected the [selectedLabelTextStyle]
  /// will be used instead.
  ///
  /// The default value is based on the [Theme]'s [TextTheme.bodyLarge]. The
  /// default color is based on the [Theme]'s [ColorScheme.onSurface].
  ///
  /// Properties from this text style, or
  /// [NavigationRailThemeData.unselectedLabelTextStyle] if this is null, are
  /// merged into the defaults.
  final ResizableTextStyle? unselectedLabelTextStyle;

  /// The [ResizableTextStyle] of a destination's label when it is selected.
  ///
  /// When a [NavigationRailDestination] is not selected,
  /// [unselectedLabelTextStyle] will be used.
  ///
  /// The default value is based on the [TextTheme.bodyLarge] of
  /// [ThemeData.textTheme]. The default color is based on the [Theme]'s
  /// [ColorScheme.primary].
  ///
  /// Properties from this text style,
  /// or [NavigationRailThemeData.selectedLabelTextStyle] if this is null, are
  /// merged into the defaults.
  final ResizableTextStyle? selectedLabelTextStyle;

  /// The visual properties of the icon in the unselected destination.
  ///
  /// If this field is not provided, or provided with any null properties, then
  /// a copy of the [IconThemeData.fallback] with a custom [NavigationRail]
  /// specific color will be used.
  ///
  /// The default value is the [Theme]'s [ThemeData.iconTheme] with a color
  /// of the [Theme]'s [ColorScheme.onSurface] with an opacity of 0.64.
  /// Properties from this icon theme, or
  /// [NavigationRailThemeData.unselectedIconTheme] if this is null, are
  /// merged into the defaults.
  final IconThemeData? unselectedIconTheme;

  /// The visual properties of the icon in the selected destination.
  ///
  /// When a [NavigationRailDestination] is not selected,
  /// [unselectedIconTheme] will be used.
  ///
  /// The default value is the [Theme]'s [ThemeData.iconTheme] with a color
  /// of the [Theme]'s [ColorScheme.primary]. Properties from this icon theme,
  /// or [NavigationRailThemeData.selectedIconTheme] if this is null, are
  /// merged into the defaults.
  final IconThemeData? selectedIconTheme;

  /// If `true`, adds a rounded [NavigationIndicator] behind the selected
  /// destination's icon.
  ///
  /// The indicator's shape will be circular if [labelType] is
  /// [NavigationRailLabelType.none], or a [StadiumBorder] if [labelType] is
  /// [NavigationRailLabelType.all] or [NavigationRailLabelType.selected].
  ///
  /// If `null`, defaults to [NavigationRailThemeData.useIndicator]. If that is
  /// `null`, defaults to [ThemeData.useMaterial3].
  final bool? useIndicator;

  /// Overrides the default value of [NavigationRail]'s selection indicator
  /// color, when [useIndicator] is true.
  ///
  /// If this is null, [NavigationRailThemeData.indicatorColor] is used. If
  /// that is null, defaults to [ColorScheme.secondaryContainer].
  final Color? indicatorColor;

  /// Overrides the default value of [NavigationRail]'s selection indicator
  /// shape, when [useIndicator] is true.
  ///
  /// If this is null, [NavigationRailThemeData.indicatorShape] is used. If
  /// that is null, defaults to [StadiumBorder].
  final ShapeBorder? indicatorShape;

  @override
  NavigationRailConfig copy() => NavigationRailConfig(
        destinations: destinations,
        selectedIndex: selectedIndex,
        width: width,
        extendedWidth: extendedWidth,
        leading: leading,
        leadingExtended: leadingExtended,
        trailing: trailing,
        key: key,
        backgroundColor: backgroundColor,
        onDestinationSelected: onDestinationSelected,
        elevation: elevation,
        groupAlignment: groupAlignment,
        labelType: labelType,
        unselectedLabelTextStyle: unselectedLabelTextStyle,
        selectedLabelTextStyle: selectedLabelTextStyle,
        unselectedIconTheme: unselectedIconTheme,
        selectedIconTheme: selectedIconTheme,
        useIndicator: useIndicator,
        indicatorColor: indicatorColor,
        indicatorShape: indicatorShape,
        padding: padding,
      );

  @override
  NavigationRailConfig copyWith({
    final JSON updates = const <String, dynamic>{},
    final NavigationRailConfig? other,
  }) =>
      NavigationRailConfig(
        destinations:
            updates['destinations'] ?? other?.destinations ?? destinations,
        selectedIndex: updates['selectedIndex'] ??
            updates['selected_index'] ??
            other?.selectedIndex ??
            selectedIndex,
        width: updates['width'] ?? other?.width ?? width,
        extendedWidth: updates['extendedWidth'] ??
            updates['extended_width'] ??
            other?.extendedWidth ??
            extendedWidth,
        leading: updates['leading'] ?? other?.leading ?? leading,
        leadingExtended: updates['leadingExtended'] ??
            updates['leading_extended'] ??
            other?.leadingExtended ??
            leadingExtended,
        trailing: updates['trailing'] ?? other?.trailing ?? trailing,
        key: updates['key'] ?? other?.key ?? key,
        backgroundColor: updates['backgroundColor'] ??
            updates['background_color'] ??
            other?.backgroundColor ??
            backgroundColor,
        onDestinationSelected: updates['onDestinationSelected'] ??
            updates['on_destination_selected'] ??
            updates['onSelectedIndexChanged'] ??
            updates['on_selected_index_changed'] ??
            other?.onDestinationSelected ??
            onDestinationSelected,
        elevation: updates['elevation'] ?? other?.elevation ?? elevation,
        groupAlignment: updates['groupAlignment'] ??
            updates['group_alignment'] ??
            other?.groupAlignment ??
            groupAlignment,
        labelType: updates['labelType'] ??
            updates['label_type'] ??
            other?.labelType ??
            labelType,
        unselectedLabelTextStyle: updates['unselectedLabelTextStyle'] ??
            updates['unselected_label_text_style'] ??
            other?.unselectedLabelTextStyle ??
            unselectedLabelTextStyle,
        selectedLabelTextStyle: updates['selectedLabelTextStyle'] ??
            updates['selected_label_text_style'] ??
            other?.selectedLabelTextStyle ??
            selectedLabelTextStyle,
        unselectedIconTheme: updates['unselectedIconTheme'] ??
            updates['unselected_icon_theme'] ??
            other?.unselectedIconTheme ??
            unselectedIconTheme,
        selectedIconTheme: updates['selectedIconTheme'] ??
            updates['selected_icon_theme'] ??
            other?.selectedIconTheme ??
            selectedIconTheme,
        useIndicator: updates['useIndicator'] ??
            updates['use_indicator'] ??
            other?.useIndicator ??
            useIndicator,
        indicatorColor: updates['indicatorColor'] ??
            updates['indicator_color'] ??
            other?.indicatorColor ??
            indicatorColor,
        indicatorShape: updates['indicatorShape'] ??
            updates['indicator_shape'] ??
            other?.indicatorShape ??
            indicatorShape,
        padding: updates['padding'] ?? other?.padding ?? padding,
      );

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is NavigationRailConfig &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          !listEquals(destinations, other.destinations) &&
          selectedIndex == other.selectedIndex &&
          leading == other.leading &&
          leadingExtended == other.leadingExtended &&
          trailing == other.trailing &&
          onDestinationSelected == other.onDestinationSelected &&
          width == other.width &&
          extendedWidth == other.extendedWidth &&
          backgroundColor == other.backgroundColor &&
          elevation == other.elevation &&
          groupAlignment == other.groupAlignment &&
          labelType == other.labelType &&
          unselectedLabelTextStyle == other.unselectedLabelTextStyle &&
          selectedLabelTextStyle == other.selectedLabelTextStyle &&
          unselectedIconTheme == other.unselectedIconTheme &&
          selectedIconTheme == other.selectedIconTheme &&
          useIndicator == other.useIndicator &&
          indicatorColor == other.indicatorColor &&
          padding == other.padding &&
          indicatorShape == other.indicatorShape;

  @override
  int get hashCode =>
      key.hashCode ^
      destinations.hashCode ^
      selectedIndex.hashCode ^
      leading.hashCode ^
      leadingExtended.hashCode ^
      trailing.hashCode ^
      onDestinationSelected.hashCode ^
      width.hashCode ^
      extendedWidth.hashCode ^
      backgroundColor.hashCode ^
      elevation.hashCode ^
      groupAlignment.hashCode ^
      labelType.hashCode ^
      unselectedLabelTextStyle.hashCode ^
      selectedLabelTextStyle.hashCode ^
      unselectedIconTheme.hashCode ^
      selectedIconTheme.hashCode ^
      useIndicator.hashCode ^
      indicatorColor.hashCode ^
      padding.hashCode ^
      indicatorShape.hashCode;
}

@immutable
class BreakpointConfig implements Copyable<BreakpointConfig> {
  const BreakpointConfig({
    this.large = PredefinedBreakpoint.largeAndUp,
    this.medium = PredefinedBreakpoint.medium,
    this.small = PredefinedBreakpoint.smallAndDown,
  });

  /// The breakpoint defined for the small size, associated with mobile-like
  /// features.
  ///
  /// Defaults to [PredefinedBreakpoint.smallAndDown].
  final Breakpoint small;

  /// The breakpoint defined for the medium size, associated with tablet-like
  /// features.
  ///
  /// Defaults to [PredefinedBreakpoint.medium].
  final Breakpoint medium;

  /// The breakpoint defined for the large size, associated with desktop-like
  /// features.
  ///
  /// Defaults to [PredefinedBreakpoint.largeAndUp].
  final Breakpoint large;

  @override
  BreakpointConfig copy() => BreakpointConfig(
        large: large,
        medium: medium,
        small: small,
      );

  @override
  BreakpointConfig copyWith({
    final JSON updates = const <String, dynamic>{},
    final BreakpointConfig? other,
  }) =>
      BreakpointConfig(
        large: updates['large'] ?? other?.large ?? large,
        medium: updates['medium'] ?? other?.medium ?? medium,
        small: updates['small'] ?? other?.small ?? small,
      );

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is BreakpointConfig &&
          runtimeType == other.runtimeType &&
          small == other.small &&
          medium == other.medium &&
          large == other.large;

  @override
  int get hashCode => small.hashCode ^ medium.hashCode ^ large.hashCode;
}

typedef WidgetBuilderWrapper = WidgetBuilder? Function(WidgetBuilder? body);

@immutable
class BodyConfig implements Copyable<BodyConfig> {
  const BodyConfig({
    this.body,
    this.large,
    this.largeSecondary,
    this.orientation = Axis.horizontal,
    this.ratio,
    this.secondary,
    this.small,
    this.smallSecondary,
  });

  /// Widget to be displayed in the body slot at the smallest breakpoint.
  ///
  /// If nothing is entered for this property, then the default [body] is
  /// displayed in the slot. If null is entered for this slot, the slot stays
  /// empty.
  final WidgetBuilder? small;

  /// Widget to be displayed in the body slot at the middle breakpoint.
  ///
  /// The default displayed body.
  final WidgetBuilder? body;

  /// Widget to be displayed in the body slot at the largest breakpoint.
  ///
  /// If nothing is entered for this property, then the default [body] is
  /// displayed in the slot. If null is entered for this slot, the slot stays
  /// empty.
  final WidgetBuilder? large;

  /// Widget to be displayed in the secondaryBody slot at the smallest
  /// breakpoint.
  ///
  /// If nothing is entered for this property, then the default [secondary]
  /// is displayed in the slot. If null is entered for this slot, the slot stays
  /// empty.
  final WidgetBuilder? smallSecondary;

  /// Widget to be displayed in the secondaryBody slot at the middle breakpoint.
  ///
  /// The default displayed secondaryBody.
  final WidgetBuilder? secondary;

  /// Widget to be displayed in the secondaryBody slot at the largest
  /// breakpoint.
  ///
  /// If nothing is entered for this property, then the default [secondary]
  /// is displayed in the slot. If null is entered for this slot, the slot stays
  /// empty.
  final WidgetBuilder? largeSecondary;

  /// Defines the fractional ratio of body to the secondaryBody.
  ///
  /// For example 0.3 would mean body takes up 30% of the available space and
  /// secondaryBody takes up the rest.
  ///
  /// If this value is null, the ratio is defined so that the split axis is in
  /// the center of the screen.
  final double? ratio;

  /// The orientation of the body and secondaryBody. Either horizontal (side by
  /// side) or vertical (top to bottom).
  ///
  /// Defaults to Axis.horizontal.
  final Axis orientation;

  @override
  BodyConfig copy() => BodyConfig(
        body: body,
        large: large,
        largeSecondary: largeSecondary,
        orientation: orientation,
        ratio: ratio,
        secondary: secondary,
        small: small,
        smallSecondary: smallSecondary,
      );

  BodyConfig wrap(final WidgetBuilderWrapper builder) => BodyConfig(
        body: builder(body),
        large: builder(large),
        largeSecondary: builder(largeSecondary),
        orientation: orientation,
        ratio: ratio,
        secondary: builder(secondary),
        small: builder(small),
        smallSecondary: builder(smallSecondary),
      );

  @override
  BodyConfig copyWith({
    final JSON updates = const <String, dynamic>{},
    final BodyConfig? other,
  }) =>
      BodyConfig(
        body: updates['body'] ?? other?.body ?? body,
        large: updates['large'] ?? other?.large ?? large,
        largeSecondary: updates['largeSecondary'] ??
            updates['large_secondary'] ??
            other?.largeSecondary ??
            largeSecondary,
        orientation:
            updates['orientation'] ?? other?.orientation ?? orientation,
        ratio: updates['ratio'] ?? other?.ratio ?? ratio,
        secondary: updates['secondary'] ?? other?.secondary ?? secondary,
        small: updates['small'] ?? other?.small ?? small,
        smallSecondary: updates['smallSecondary'] ??
            updates['small_secondary'] ??
            other?.smallSecondary ??
            smallSecondary,
      );

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is BodyConfig &&
          runtimeType == other.runtimeType &&
          small == other.small &&
          body == other.body &&
          large == other.large &&
          smallSecondary == other.smallSecondary &&
          secondary == other.secondary &&
          largeSecondary == other.largeSecondary &&
          ratio == other.ratio &&
          orientation == other.orientation;

  @override
  int get hashCode =>
      small.hashCode ^
      body.hashCode ^
      large.hashCode ^
      smallSecondary.hashCode ^
      secondary.hashCode ^
      largeSecondary.hashCode ^
      ratio.hashCode ^
      orientation.hashCode;
}

@immutable
class AdaptiveDrawerConfig implements Copyable<AdaptiveDrawerConfig> {
  const AdaptiveDrawerConfig({
    this.key,
    this.children,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.width,
    this.semanticLabel,
    this.indicatorColor,
    this.indicatorShape,
    this.onDestinationSelected,
    this.selectedIndex,
    this.breakpoint = const BreakpointGenerator.generate(
      begin: 0,
      end: 600,
      type: DeviceType.desktop,
    ),
    this.useDrawer = true,
    this.useEndDrawer = false,
    this.customDrawer,
    this.onDrawerChanged,
    this.customEndDrawer,
    this.onEndDrawerChanged,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
  }) : assert(
          elevation == null || elevation >= 0.0,
          'If an elevation value is provided, '
          'it must be equal or greater to zero.',
        );

  /// A panel displayed to the side of the [BodyConfig.body], often hidden on
  /// mobile devices. Swipes in from either left-to-right ([TextDirection.ltr])
  /// or right-to-left ([TextDirection.rtl])
  ///
  /// Typically a [Drawer].
  ///
  /// This is configured and handled by [AdaptiveScaffold] by default, but it
  /// can be overriden using this property.
  ///
  /// To open the drawer, use the [ScaffoldState.openDrawer] function.
  ///
  /// To close the drawer, use either [ScaffoldState.closeDrawer],
  /// [Navigator.pop] or press the escape key on the keyboard.
  ///
  /// {@tool dartpad}
  /// To disable the drawer edge swipe on mobile, set the
  /// [Scaffold.drawerEnableOpenDragGesture] to false. Then, use
  /// [ScaffoldState.openDrawer] to open the drawer and [Navigator.pop] to close
  /// it.
  ///
  /// ** See code in examples/api/lib/material/scaffold/scaffold.drawer.0.dart **
  /// {@end-tool}
  final Widget? customDrawer;

  /// Optional callback that is called when the [Scaffold.drawer] is opened or
  /// closed.
  final DrawerCallback? onDrawerChanged;

  /// A panel displayed to the side of the [BodyConfig.body], often hidden on
  /// mobile devices. Swipes in from right-to-left ([TextDirection.ltr]) or
  /// left-to-right ([TextDirection.rtl])
  ///
  /// Typically a [Drawer].
  ///
  /// This is configured and handled by [AdaptiveScaffold] by default, but it
  /// can be overriden using this property.
  ///
  /// To open the drawer, use the [ScaffoldState.openEndDrawer] function.
  ///
  /// To close the drawer, use either [ScaffoldState.closeEndDrawer],
  /// [Navigator.pop] or press the escape key on the keyboard.
  ///
  /// {@tool dartpad}
  /// To disable the drawer edge swipe, set the
  /// [Scaffold.endDrawerEnableOpenDragGesture] to false. Then, use
  /// [ScaffoldState.openEndDrawer] to open the drawer and [Navigator.pop] to
  /// close it.
  ///
  /// ** See code in examples/api/lib/material/scaffold/scaffold.end_drawer.0.dart **
  /// {@end-tool}
  final Widget? customEndDrawer;

  /// Optional callback that is called when the [Scaffold.endDrawer] is opened
  /// or closed.
  final DrawerCallback? onEndDrawerChanged;

  /// The color to use for the scrim that obscures primary content while a
  /// drawer is open.
  ///
  /// If this is null, then [DrawerThemeData.scrimColor] is used. If that
  /// is also null, then it defaults to [Colors.black54].
  final Color? drawerScrimColor;

  /// {@macro flutter.material.DrawerController.dragStartBehavior}
  final DragStartBehavior drawerDragStartBehavior;

  /// The width of the area within which a horizontal swipe will open the
  /// drawer.
  ///
  /// By default, the value used is 20.0 added to the padding edge of
  /// `MediaQuery.paddingOf(context)` that corresponds to the surrounding
  /// [TextDirection]. This ensures that the drag area for notched devices is
  /// not obscured. For example, if `TextDirection.of(context)` is set to
  /// [TextDirection.ltr], 20.0 will be added to
  /// `MediaQuery.paddingOf(context).left`.
  final double? drawerEdgeDragWidth;

  /// Determines if the [Scaffold.drawer] can be opened with a drag
  /// gesture on mobile.
  ///
  /// On desktop platforms, the drawer is not draggable.
  ///
  /// By default, the drag gesture is enabled on mobile.
  final bool drawerEnableOpenDragGesture;

  /// Determines if the [Scaffold.endDrawer] can be opened with a
  /// gesture on mobile.
  ///
  /// On desktop platforms, the drawer is not draggable.
  ///
  /// By default, the drag gesture is enabled on mobile.
  final bool endDrawerEnableOpenDragGesture;

  /// Drawer's key.
  final Key? key;

  /// Sets the color of the [Material] that holds all of the [Drawer]'s
  /// contents.
  ///
  /// If this is null, then [DrawerThemeData.backgroundColor] is used. If that
  /// is also null, then it falls back to [Material]'s default.
  final Color? backgroundColor;

  /// The z-coordinate at which to place this drawer relative to its parent.
  ///
  /// This controls the size of the shadow below the drawer.
  ///
  /// If this is null, then [DrawerThemeData.elevation] is used. If that
  /// is also null, then it defaults to 16.0.
  final double? elevation;

  /// The color used to paint a drop shadow under the drawer's [Material],
  /// which reflects the drawer's [elevation].
  ///
  /// If null and [ThemeData.useMaterial3] is true then no drop shadow will
  /// be rendered.
  ///
  /// If null and [ThemeData.useMaterial3] is false then it will default to
  /// [ThemeData.shadowColor].
  ///
  /// See also:
  ///   * [Material.shadowColor], which describes how the drop shadow is
  ///     painted.
  ///   * [elevation], which affects how the drop shadow is painted.
  ///   * [surfaceTintColor], which can be used to indicate elevation through
  ///     tinting the background color.
  final Color? shadowColor;

  /// The color used as a surface tint overlay on the drawer's background color,
  /// which reflects the drawer's [elevation].
  ///
  /// If [ThemeData.useMaterial3] is false property has no effect.
  ///
  /// If null and [ThemeData.useMaterial3] is true then [ThemeData]'s
  /// [ColorScheme.surfaceTint] will be used.
  ///
  /// To disable this feature, set [surfaceTintColor] to [Colors.transparent].
  ///
  /// See also:
  ///   * [Material.surfaceTintColor], which describes how the surface tint will
  ///     be applied to the background color of the drawer.
  ///   * [elevation], which affects the opacity of the surface tint.
  ///   * [shadowColor], which can be used to indicate elevation through
  ///     a drop shadow.
  final Color? surfaceTintColor;

  /// The color of the [indicatorShape] when this destination is selected.
  ///
  /// If this is null, [NavigationDrawerThemeData.indicatorColor] is used.
  /// If that is also null, defaults to [ColorScheme.secondaryContainer].
  final Color? indicatorColor;

  /// The shape of the selected indicator.
  ///
  /// If this is null, [NavigationDrawerThemeData.indicatorShape] is used.
  /// If that is also null, defaults to [StadiumBorder].
  final ShapeBorder? indicatorShape;

  /// Defines the appearance of the items within the navigation drawer.
  ///
  /// The list contains [NavigationDrawerDestination] widgets and/or customized
  /// widgets like headlines and dividers.
  ///
  /// If null, the [NavigationRailConfig.destinations] will be used.
  final List<Widget>? children;

  /// The index into destinations for the current selected
  /// [NavigationDrawerDestination] or null if no destination is selected.
  ///
  /// A valid [selectedIndex] satisfies 0 <= [selectedIndex] < number of
  /// [NavigationDrawerDestination]. For an invalid [selectedIndex] like `-1`,
  /// all destinations will appear unselected.
  final int? selectedIndex;

  /// Called when one of the [NavigationDrawerDestination] children is selected.
  ///
  /// This callback usually updates the int passed to [selectedIndex].
  ///
  /// Upon updating [selectedIndex], the [NavigationDrawer] will be rebuilt.
  final ValueChanged<int>? onDestinationSelected;

  /// The shape of the drawer.
  ///
  /// Defines the drawer's [Material.shape].
  ///
  /// If this is null, then [DrawerThemeData.shape] is used. If that
  /// is also null, then it falls back to [Material]'s default.
  final ShapeBorder? shape;

  /// The width of the drawer.
  ///
  /// If this is null, then [DrawerThemeData.width] is used. If that is also
  /// null, then it falls back to the Material spec's default (304.0).
  final double? width;

  /// The semantic label of the drawer used by accessibility frameworks to
  /// announce screen transitions when the drawer is opened and closed.
  ///
  /// If this label is not provided, it will default to
  /// [MaterialLocalizations.drawerLabel].
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.namesRoute], for a description of how this
  ///    value is used.
  final String? semanticLabel;

  /// Option to override the drawerBreakpoint for the usage of [Drawer] over the
  /// usual [BottomNavigationBar].
  ///
  /// Defaults to `Breakpoint(begin: 0, end: 600, type: DeviceType.desktop)`.
  final Breakpoint breakpoint;

  /// Whether to use a [Drawer] over a [BottomNavigationBar] when not on mobile
  /// and [Breakpoint] is small.
  ///
  /// Defaults to true.
  final bool useDrawer;

  /// Whether to use an end drawer.
  final bool useEndDrawer;

  @override
  AdaptiveDrawerConfig copy() => AdaptiveDrawerConfig(
        breakpoint: breakpoint,
        key: key,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        shape: shape,
        width: width,
        children: children,
        indicatorColor: indicatorColor,
        indicatorShape: indicatorShape,
        onDestinationSelected: onDestinationSelected,
        selectedIndex: selectedIndex,
        semanticLabel: semanticLabel,
        useDrawer: useDrawer,
        useEndDrawer: useEndDrawer,
        customDrawer: customDrawer,
        onDrawerChanged: onDrawerChanged,
        customEndDrawer: customEndDrawer,
        onEndDrawerChanged: onEndDrawerChanged,
        drawerScrimColor: drawerScrimColor,
        drawerDragStartBehavior: drawerDragStartBehavior,
        drawerEdgeDragWidth: drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      );

  @override
  AdaptiveDrawerConfig copyWith({
    final JSON updates = const <String, dynamic>{},
    final AdaptiveDrawerConfig? other,
  }) =>
      AdaptiveDrawerConfig(
        breakpoint: updates['breakpoint'] ?? other?.breakpoint ?? breakpoint,
        key: updates['key'] ?? other?.key ?? key,
        backgroundColor: updates['backgroundColor'] ??
            updates['background_color'] ??
            other?.backgroundColor ??
            backgroundColor,
        elevation: updates['elevation'] ?? other?.elevation ?? elevation,
        shadowColor: updates['shadowColor'] ??
            updates['shadow_color'] ??
            other?.shadowColor ??
            shadowColor,
        surfaceTintColor: updates['surfaceTintColor'] ??
            updates['surfaceTint_color'] ??
            other?.surfaceTintColor ??
            surfaceTintColor,
        shape: updates['shape'] ?? other?.shape ?? shape,
        width: updates['width'] ?? other?.width ?? width,
        semanticLabel: updates['semanticLabel'] ??
            updates['semantic_label'] ??
            other?.semanticLabel ??
            semanticLabel,
        children: updates['children'] ?? other?.children ?? children,
        indicatorColor: updates['indicatorColor'] ??
            updates['indicator_color'] ??
            other?.indicatorColor ??
            indicatorColor,
        indicatorShape: updates['indicatorShape'] ??
            updates['indicator_shape'] ??
            other?.indicatorShape ??
            indicatorShape,
        onDestinationSelected: updates['onDestinationSelected'] ??
            updates['on_destination_selected'] ??
            other?.onDestinationSelected ??
            onDestinationSelected,
        selectedIndex: updates['selectedIndex'] ??
            updates['selected_index'] ??
            other?.selectedIndex ??
            selectedIndex,
        useDrawer: updates['useDrawer'] ??
            updates['use_drawer'] ??
            other?.useDrawer ??
            useDrawer,
        useEndDrawer: updates['useEndDrawer'] ??
            updates['use_end_drawer'] ??
            other?.useEndDrawer ??
            useEndDrawer,
        customDrawer: updates['customDrawer'] ??
            updates['custom_drawer'] ??
            other?.customDrawer ??
            customDrawer,
        onDrawerChanged: updates['onDrawerChanged'] ??
            updates['on_drawer_changed'] ??
            other?.onDrawerChanged ??
            onDrawerChanged,
        customEndDrawer: updates['customEndDrawer'] ??
            updates['custom_end_drawer'] ??
            other?.customEndDrawer ??
            customEndDrawer,
        onEndDrawerChanged: updates['onEndDrawerChanged'] ??
            updates['on_end_drawer_changed'] ??
            other?.onEndDrawerChanged ??
            onEndDrawerChanged,
        drawerScrimColor: updates['drawerScrimColor'] ??
            updates['drawer_scrim_color'] ??
            other?.drawerScrimColor ??
            drawerScrimColor,
        drawerDragStartBehavior: updates['drawerDragStartBehavior'] ??
            updates['drawer_drag_start_behavior'] ??
            other?.drawerDragStartBehavior ??
            drawerDragStartBehavior,
        drawerEdgeDragWidth: updates['drawerEdgeDragWidth'] ??
            updates['drawer_edge_drag_width'] ??
            other?.drawerEdgeDragWidth ??
            drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: updates['drawerEnableOpenDragGesture'] ??
            updates['drawer_enable_open_drag_gesture'] ??
            other?.drawerEnableOpenDragGesture ??
            drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture:
            updates['endDrawerEnableOpenDragGesture'] ??
                updates['end_drawer_enable_open_drag_gesture'] ??
                other?.endDrawerEnableOpenDragGesture ??
                endDrawerEnableOpenDragGesture,
      );

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is AdaptiveDrawerConfig &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          backgroundColor == other.backgroundColor &&
          elevation == other.elevation &&
          shadowColor == other.shadowColor &&
          surfaceTintColor == other.surfaceTintColor &&
          shape == other.shape &&
          width == other.width &&
          semanticLabel == other.semanticLabel &&
          children == other.children &&
          indicatorColor == other.indicatorColor &&
          indicatorShape == other.indicatorShape &&
          onDestinationSelected == other.onDestinationSelected &&
          selectedIndex == other.selectedIndex &&
          useDrawer == other.useDrawer &&
          useEndDrawer == other.useEndDrawer &&
          customDrawer == other.customDrawer &&
          onDrawerChanged == other.onDrawerChanged &&
          customEndDrawer == other.customEndDrawer &&
          onEndDrawerChanged == other.onEndDrawerChanged &&
          drawerScrimColor == other.drawerScrimColor &&
          drawerDragStartBehavior == other.drawerDragStartBehavior &&
          drawerEdgeDragWidth == other.drawerEdgeDragWidth &&
          drawerEnableOpenDragGesture == other.drawerEnableOpenDragGesture &&
          endDrawerEnableOpenDragGesture ==
              other.endDrawerEnableOpenDragGesture &&
          breakpoint == other.breakpoint;

  @override
  int get hashCode =>
      key.hashCode ^
      backgroundColor.hashCode ^
      customDrawer.hashCode ^
      onDrawerChanged.hashCode ^
      customEndDrawer.hashCode ^
      onEndDrawerChanged.hashCode ^
      drawerScrimColor.hashCode ^
      drawerDragStartBehavior.hashCode ^
      drawerEdgeDragWidth.hashCode ^
      drawerEnableOpenDragGesture.hashCode ^
      endDrawerEnableOpenDragGesture.hashCode ^
      elevation.hashCode ^
      shadowColor.hashCode ^
      surfaceTintColor.hashCode ^
      shape.hashCode ^
      width.hashCode ^
      semanticLabel.hashCode ^
      children.hashCode ^
      indicatorColor.hashCode ^
      indicatorShape.hashCode ^
      onDestinationSelected.hashCode ^
      selectedIndex.hashCode ^
      useDrawer.hashCode ^
      useEndDrawer.hashCode ^
      breakpoint.hashCode;
}

@immutable
class AdaptiveScrollbarConfig implements Copyable<AdaptiveScrollbarConfig> {
  const AdaptiveScrollbarConfig({
    this.controller,
    this.width = 16.0,
    this.sliderHeight,
    this.sliderChild,
    this.sliderDefaultColor = Colors.blueGrey,
    this.sliderActiveColor,
    this.underColor = Colors.white,
    this.underSpacing = EdgeInsets.zero,
    this.sliderSpacing = const EdgeInsets.all(2.0),
    this.scrollToClickDelta = 100.0,
    this.scrollToClickFirstDelay = 400,
    this.scrollToClickOtherDelay = 100,
    this.underDecoration,
    this.sliderDecoration,
    this.sliderActiveDecoration,
    this.key,
  });

  final Key? key;

  /// [ScrollController] that attached to [ScrollView] object.
  final ScrollController? controller;

  /// Width of all [AdaptiveScrollbar].
  final double width;

  /// Height of slider. If you set this value,
  /// there will be this height. If not set, the height
  /// will be calculated based on the content, as usual
  final double? sliderHeight;

  /// Child widget for slider.
  final Widget? sliderChild;

  /// Under the slider part of the scrollbar color.
  final Color underColor;

  /// Default slider color.
  final Color sliderDefaultColor;

  /// Active slider color.
  final Color? sliderActiveColor;

  /// Under the slider part of the scrollbar decoration.
  final BoxDecoration? underDecoration;

  /// Slider decoration.
  final BoxDecoration? sliderDecoration;

  /// Slider decoration during pressing.
  final BoxDecoration? sliderActiveDecoration;

  /// Offset of the slider in the direction of the click.
  final double scrollToClickDelta;

  /// Duration of the first delay between scrolls in the click direction, in
  /// milliseconds.
  final int scrollToClickFirstDelay;

  /// Duration of the others delays between scrolls in the click direction, in
  /// milliseconds.
  final int scrollToClickOtherDelay;

  /// Under the slider part of the scrollbar spacing.
  /// If you choose [ScrollbarPosition.top] or [ScrollbarPosition.bottom]
  /// position, the scrollbar will be rotated 90 degrees, and the top will be on
  /// the left. Don't forget this when specifying the [underSpacing].
  final EdgeInsetsGeometry underSpacing;

  /// Slider spacing from bottom.
  /// If you choose [ScrollbarPosition.top] or [ScrollbarPosition.bottom]
  /// position, the scrollbar will be rotated 90 degrees, and the top will be on
  /// the left. Don't forget this when specifying the [sliderSpacing].
  final EdgeInsetsGeometry sliderSpacing;

  @override
  AdaptiveScrollbarConfig copy() => AdaptiveScrollbarConfig(
        controller: controller,
        width: width,
        sliderHeight: sliderHeight,
        sliderChild: sliderChild,
        sliderDefaultColor: sliderDefaultColor,
        sliderActiveColor: sliderActiveColor,
        underColor: underColor,
        underSpacing: underSpacing,
        sliderSpacing: sliderSpacing,
        scrollToClickDelta: scrollToClickDelta,
        scrollToClickFirstDelay: scrollToClickFirstDelay,
        scrollToClickOtherDelay: scrollToClickOtherDelay,
        underDecoration: underDecoration,
        sliderDecoration: sliderDecoration,
        sliderActiveDecoration: sliderActiveDecoration,
      );

  @override
  AdaptiveScrollbarConfig copyWith({
    final JSON updates = const <String, dynamic>{},
    final AdaptiveScrollbarConfig? other,
  }) =>
      AdaptiveScrollbarConfig(
        controller: updates['controller'] ?? other?.controller ?? controller,
        width: updates['width'] ?? other?.width ?? width,
        sliderHeight: updates['sliderHeight'] ??
            updates['slider_height'] ??
            other?.sliderHeight ??
            sliderHeight,
        sliderChild: updates['sliderChild'] ??
            updates['slider_child'] ??
            other?.sliderChild ??
            sliderChild,
        sliderDefaultColor: updates['sliderDefaultColor'] ??
            updates['slider_default_color'] ??
            other?.sliderDefaultColor ??
            sliderDefaultColor,
        sliderActiveColor: updates['sliderActiveColor'] ??
            updates['slider_active_color'] ??
            other?.sliderActiveColor ??
            sliderActiveColor,
        underColor: updates['underColor'] ??
            updates['under_color'] ??
            other?.underColor ??
            underColor,
        underSpacing: updates['underSpacing'] ??
            updates['under_spacing'] ??
            other?.underSpacing ??
            underSpacing,
        sliderSpacing: updates['sliderSpacing'] ??
            updates['slider_spacing'] ??
            other?.sliderSpacing ??
            sliderSpacing,
        scrollToClickDelta: updates['scrollToClickDelta'] ??
            updates['scroll_to_click_delta'] ??
            other?.scrollToClickDelta ??
            scrollToClickDelta,
        scrollToClickFirstDelay: updates['scrollToClickFirstDelay'] ??
            updates['scroll_to_click_first_delay'] ??
            other?.scrollToClickFirstDelay ??
            scrollToClickFirstDelay,
        scrollToClickOtherDelay: updates['scrollToClickOtherDelay'] ??
            updates['scroll_to_click_other_delay'] ??
            other?.scrollToClickOtherDelay ??
            scrollToClickOtherDelay,
        underDecoration: updates['underDecoration'] ??
            updates['under_decoration'] ??
            other?.underDecoration ??
            underDecoration,
        sliderDecoration: updates['sliderDecoration'] ??
            updates['slider_decoration'] ??
            other?.sliderDecoration ??
            sliderDecoration,
        sliderActiveDecoration: updates['sliderActiveDecoration'] ??
            updates['slider_active_decoration'] ??
            other?.sliderActiveDecoration ??
            sliderActiveDecoration,
      );

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is AdaptiveScrollbarConfig &&
          runtimeType == other.runtimeType &&
          controller == other.controller &&
          width == other.width &&
          sliderHeight == other.sliderHeight &&
          sliderChild == other.sliderChild &&
          sliderDefaultColor == other.sliderDefaultColor &&
          sliderActiveColor == other.sliderActiveColor &&
          underColor == other.underColor &&
          underSpacing == other.underSpacing &&
          sliderSpacing == other.sliderSpacing &&
          scrollToClickDelta == other.scrollToClickDelta &&
          scrollToClickFirstDelay == other.scrollToClickFirstDelay &&
          scrollToClickOtherDelay == other.scrollToClickOtherDelay &&
          underDecoration == other.underDecoration &&
          sliderDecoration == other.sliderDecoration &&
          sliderActiveDecoration == other.sliderActiveDecoration;

  @override
  int get hashCode =>
      controller.hashCode ^
      width.hashCode ^
      sliderHeight.hashCode ^
      sliderChild.hashCode ^
      sliderDefaultColor.hashCode ^
      sliderActiveColor.hashCode ^
      underColor.hashCode ^
      underSpacing.hashCode ^
      sliderSpacing.hashCode ^
      scrollToClickDelta.hashCode ^
      scrollToClickFirstDelay.hashCode ^
      scrollToClickOtherDelay.hashCode ^
      underDecoration.hashCode ^
      sliderDecoration.hashCode ^
      sliderActiveDecoration.hashCode;
}

class _ScaffoldGlobalKey extends GlobalKey<ScaffoldState> {
  const _ScaffoldGlobalKey() : super.constructor();
}

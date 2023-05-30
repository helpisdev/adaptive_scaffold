import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'breakpoints/breakpoint.dart';
import 'gtk/non_web.dart' if (dart.library.html) 'gtk/web.dart';

const double kLargeAppBarHeight = 72;
const double kSmallAppBarHeight = 56;

/// AdaptiveAppBar has a leading width of 72.0. Everything else is the same as
/// [AppBar].
mixin AdaptiveAppBar {
  abstract final Color? backgroundColor;
  abstract final Color? foregroundColor;
  abstract final Color? shadowColor;
  abstract final Color? surfaceTintColor;
  abstract final IconThemeData? actionsIconTheme;
  abstract final IconThemeData? iconTheme;
  abstract final List<Widget>? actions;
  abstract final PreferredSizeWidget? bottom;
  abstract final ScrollNotificationPredicate notificationPredicate;
  abstract final ShapeBorder? shape;
  abstract final SystemUiOverlayStyle? systemOverlayStyle;
  abstract final TextStyle? titleTextStyle;
  abstract final TextStyle? toolbarTextStyle;
  abstract final Widget? flexibleSpace;
  abstract final Widget? title;
  abstract final bool automaticallyImplyLeading;
  abstract final bool excludeHeaderSemantics;
  abstract final bool primary;
  abstract final bool? centerTitle;
  abstract final double bottomOpacity;
  abstract final double? titleSpacing;
  abstract final double toolbarOpacity;
  abstract final double? elevation;
  abstract final double? leadingWidth;
  abstract final double? scrolledUnderElevation;
  abstract final double? toolbarHeight;
  abstract final bool forceMaterialTransparency;
  abstract final dynamic customLeading;
  abstract final List<Widget> trailing;
  abstract final Key? key;
  abstract final VoidCallback? onWillPopCallback;
  abstract final WindowResizeCallback? onWindowResize;
  abstract final ButtonStyle? backButtonStyle;
  abstract final Color? backButtonColor;
  abstract final Breakpoint appBarBreakpoint;

  static const Breakpoint desktop = BreakpointGenerator.generate(
    begin: 0,
    type: DeviceType.desktop,
  );

  /// Constructs a default [AppBar] with predefined [leadingWidth] and
  /// [titleSpacing]. Inspired by the AdaptiveAppBar implementation of
  /// material.io.
  static AdaptiveAppBar fromContext({
    required final BuildContext context,
    final Breakpoint appBarBreakpoint = desktop,
    final Color? backgroundColor,
    final Color? foregroundColor,
    final Color? shadowColor,
    final Color? surfaceTintColor,
    final IconThemeData? actionsIconTheme,
    final IconThemeData? iconTheme,
    final Key? key,
    final List<Widget>? actions,
    final PreferredSizeWidget? bottom,
    final ScrollNotificationPredicate notificationPredicate =
        defaultScrollNotificationPredicate,
    final ShapeBorder? shape,
    final SystemUiOverlayStyle? systemOverlayStyle,
    final TextStyle? titleTextStyle,
    final TextStyle? toolbarTextStyle,
    final Widget? flexibleSpace,
    final dynamic leading,
    final List<Widget> trailing = const <Widget>[],
    final Widget? title,
    final bool automaticallyImplyLeading = true,
    final bool excludeHeaderSemantics = false,
    final bool primary = true,
    final bool? centerTitle,
    final double bottomOpacity = 1,
    final double titleSpacing = NavigationToolbar.kMiddleSpacing,
    final double toolbarOpacity = 1,
    final double? elevation,
    final double? leadingWidth,
    final double? scrolledUnderElevation,
    final double? toolbarHeight,
    final bool forceMaterialTransparency = false,
    final VoidCallback? onWillPopCallback,
    final WindowResizeCallback? onWindowResize,
    final ButtonStyle? backButtonStyle,
    final Color? backButtonColor,
  }) {
    if (desktop.isActive(context)) {
      return AdaptiveGTKAppBar(
        title: title,
        leading: leading is List<Widget>
            ? leading
            : <Widget>[if (leading != null) leading],
        trailing: trailing,
        automaticallyImplyLeading: automaticallyImplyLeading,
        onWillPopCallback: onWillPopCallback,
        onWindowResize: onWindowResize,
        backButtonStyle: backButtonStyle,
        backButtonColor: backButtonColor,
        appBarBreakpoint: appBarBreakpoint,
      );
    }

    final bool isLargeScreen = PredefinedBreakpoint.largeAndUp.isActive(
      context,
    );
    return AdaptiveMaterialAppBar(
      leadingWidth: leadingWidth ??
          (isLargeScreen ? kLargeAppBarHeight : kSmallAppBarHeight),
      key: key,
      automaticallyImplyLeading: automaticallyImplyLeading,
      primary: primary,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      leading: leading is Widget? ? leading : null,
      title: title,
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      notificationPredicate: notificationPredicate,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      centerTitle: centerTitle,
      toolbarHeight: toolbarHeight,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      systemOverlayStyle: systemOverlayStyle,
      forceMaterialTransparency: forceMaterialTransparency,
      appBarBreakpoint: appBarBreakpoint,
    );
  }

  static PreferredSizeWidget? generateFrom({
    required final BuildContext context,
    final Breakpoint breakpoint = AdaptiveAppBar.desktop,
    final bool useDrawer = false,
    final AdaptiveAppBar? appBar,
  }) {
    final Breakpoint bp = appBar?.appBarBreakpoint ?? breakpoint;
    final bool shouldUseAppBar = bp.isActive(context);
    if (!shouldUseAppBar) {
      return null;
    }
    return AdaptiveAppBar.fromContext(
      context: context,
      appBarBreakpoint: bp,
      backgroundColor: appBar?.backgroundColor,
      foregroundColor: appBar?.foregroundColor,
      shadowColor: appBar?.shadowColor,
      surfaceTintColor: appBar?.surfaceTintColor,
      actionsIconTheme: appBar?.actionsIconTheme,
      iconTheme: appBar?.iconTheme,
      actions: appBar?.actions,
      bottom: appBar?.bottom,
      notificationPredicate:
          appBar?.notificationPredicate ?? defaultScrollNotificationPredicate,
      shape: appBar?.shape,
      systemOverlayStyle: appBar?.systemOverlayStyle,
      titleTextStyle: appBar?.titleTextStyle,
      toolbarTextStyle: appBar?.toolbarTextStyle,
      flexibleSpace: appBar?.flexibleSpace,
      title: appBar?.title,
      automaticallyImplyLeading: appBar?.automaticallyImplyLeading ?? true,
      excludeHeaderSemantics: appBar?.excludeHeaderSemantics ?? false,
      primary: appBar?.primary ?? true,
      centerTitle: appBar?.centerTitle,
      bottomOpacity: appBar?.bottomOpacity ?? 1,
      titleSpacing: appBar?.titleSpacing ?? NavigationToolbar.kMiddleSpacing,
      toolbarOpacity: appBar?.toolbarOpacity ?? 1,
      elevation: appBar?.elevation,
      leadingWidth: appBar?.leadingWidth,
      scrolledUnderElevation: appBar?.scrolledUnderElevation,
      toolbarHeight: appBar?.toolbarHeight,
      forceMaterialTransparency: appBar?.forceMaterialTransparency ?? false,
      trailing: appBar?.trailing ?? <Widget>[],
      leading: appBar?.customLeading ??
          Builder(
            builder: (final BuildContext context) => Visibility(
              visible: useDrawer,
              child: IconButton(
                onPressed: Scaffold.of(context).openDrawer,
                tooltip: MaterialLocalizations.of(
                  context,
                ).openAppDrawerTooltip,
                icon: Icon(
                  Icons.menu,
                  semanticLabel: MaterialLocalizations.of(
                    context,
                  ).openAppDrawerTooltip,
                ),
              ),
            ),
          ),
      key: appBar?.key,
      onWillPopCallback: appBar?.onWillPopCallback,
      onWindowResize: appBar?.onWindowResize,
      backButtonStyle: appBar?.backButtonStyle,
      backButtonColor: appBar?.backButtonColor,
    ) as PreferredSizeWidget;
  }
}

class AdaptiveGTKAppBar extends GTKHeaderBar with AdaptiveAppBar {
  const AdaptiveGTKAppBar({
    final bool automaticallyImplyLeading = true,
    final Widget? title,
    this.appBarBreakpoint = AdaptiveAppBar.desktop,
    super.backButtonColor,
    super.backButtonStyle,
    super.trailing,
    super.leading,
    super.bottom,
    super.height,
    super.middleSpacing,
    super.padding,
    super.showLeading,
    super.showTrailing,
    super.showMaximizeButton,
    super.showMinimizeButton,
    super.showCloseButton,
    super.showWindowControlsButtons,
    super.onWindowResize,
    super.onWillPopCallback,
    super.key,
  }) : super(autoImplyLeading: automaticallyImplyLeading, middle: title);

  @override
  List<Widget>? get actions => null;

  @override
  IconThemeData? get actionsIconTheme => null;

  @override
  bool get automaticallyImplyLeading => true;

  @override
  Color? get backgroundColor => null;

  @override
  double get bottomOpacity => 0;

  @override
  bool? get centerTitle => null;

  @override
  double? get elevation => null;

  @override
  bool get excludeHeaderSemantics => false;

  @override
  Widget? get flexibleSpace => null;

  @override
  bool get forceMaterialTransparency => false;

  @override
  Color? get foregroundColor => null;

  @override
  IconThemeData? get iconTheme => null;

  @override
  double? get leadingWidth => null;

  @override
  ScrollNotificationPredicate get notificationPredicate =>
      defaultScrollNotificationPredicate;

  @override
  bool get primary => true;

  @override
  double? get scrolledUnderElevation => null;

  @override
  Color? get shadowColor => null;

  @override
  ShapeBorder? get shape => null;

  @override
  Color? get surfaceTintColor => null;

  @override
  SystemUiOverlayStyle? get systemOverlayStyle => null;

  @override
  Widget? get title => middle;

  @override
  double? get titleSpacing => null;

  @override
  TextStyle? get titleTextStyle => null;

  @override
  double? get toolbarHeight => null;

  @override
  double get toolbarOpacity => 1;

  @override
  TextStyle? get toolbarTextStyle => null;

  @override
  List<Widget> get customLeading => leading;

  @override
  final Breakpoint appBarBreakpoint;
}

class AdaptiveMaterialAppBar extends AppBar with AdaptiveAppBar {
  AdaptiveMaterialAppBar({
    this.appBarBreakpoint = AdaptiveAppBar.desktop,
    super.leading,
    super.automaticallyImplyLeading,
    super.title,
    super.actions,
    super.flexibleSpace,
    super.bottom,
    super.elevation,
    super.scrolledUnderElevation,
    super.notificationPredicate,
    super.shadowColor,
    super.surfaceTintColor,
    super.shape,
    super.backgroundColor,
    super.foregroundColor,
    super.iconTheme,
    super.actionsIconTheme,
    super.primary,
    super.centerTitle,
    super.excludeHeaderSemantics,
    super.titleSpacing,
    super.toolbarOpacity,
    super.bottomOpacity,
    super.toolbarHeight,
    super.leadingWidth,
    super.toolbarTextStyle,
    super.titleTextStyle,
    super.systemOverlayStyle,
    super.forceMaterialTransparency,
    super.clipBehavior,
    super.key,
  }) : super();

  @override
  Widget? get customLeading => leading;

  @override
  VoidCallback? get onWillPopCallback => null;

  @override
  WindowResizeCallback? get onWindowResize => null;

  @override
  Color? get backButtonColor => null;

  @override
  ButtonStyle? get backButtonStyle => null;

  @override
  List<Widget> get trailing => <Widget>[];

  @override
  final Breakpoint appBarBreakpoint;
}

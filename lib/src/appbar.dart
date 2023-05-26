import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtk_window/gtk_window.dart';

import 'breakpoints/breakpoint.dart';

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
  abstract final Key? key;
  abstract final VoidCallback? onWillPopCallback;
  abstract final WindowResizeCallback? onWindowResize;

  /// Constructs a default [AppBar] with predefined [leadingWidth] and
  /// [titleSpacing]. Inspired by the AdaptiveAppBar implementation of
  /// material.io.
  static AdaptiveAppBar fromContext({
    required final BuildContext context,
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
  }) {
    const BreakpointGenerator desktopBreakpoint = BreakpointGenerator.generate(
      begin: 0,
      type: DeviceType.desktop,
    );
    if (desktopBreakpoint.isActive(context)) {
      return AdaptiveGTKAppBar(
        middle: title,
        leading: leading is List<Widget>
            ? leading
            : <Widget>[if (leading != null) leading],
        actions: actions,
        actionsIconTheme: actionsIconTheme,
        automaticallyImplyLeading: automaticallyImplyLeading,
        onWillPopCallback: onWillPopCallback,
        onWindowResize: onWindowResize,
        backgroundColor: backgroundColor,
        bottomOpacity: bottomOpacity,
        centerTitle: centerTitle,
        elevation: elevation,
        excludeHeaderSemantics: excludeHeaderSemantics,
        flexibleSpace: flexibleSpace,
        forceMaterialTransparency: forceMaterialTransparency,
        foregroundColor: foregroundColor,
        iconTheme: iconTheme,
        leadingWidth: leadingWidth,
        notificationPredicate: notificationPredicate,
        primary: primary,
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor,
        shape: shape,
        surfaceTintColor: surfaceTintColor,
        systemOverlayStyle: systemOverlayStyle,
        title: title,
        titleSpacing: titleSpacing,
        titleTextStyle: titleTextStyle,
        toolbarHeight: toolbarHeight,
        toolbarOpacity: toolbarOpacity,
        toolbarTextStyle: toolbarTextStyle,
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
    );
  }
}

class AdaptiveGTKAppBar extends GTKHeaderBar with AdaptiveAppBar {
  const AdaptiveGTKAppBar({
    this.actions,
    this.actionsIconTheme,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.bottomOpacity = 1,
    this.centerTitle,
    this.elevation,
    this.excludeHeaderSemantics = false,
    this.flexibleSpace,
    this.forceMaterialTransparency = false,
    this.foregroundColor,
    this.iconTheme,
    this.leadingWidth,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.primary = true,
    this.scrolledUnderElevation,
    this.shadowColor,
    this.shape,
    this.surfaceTintColor,
    this.systemOverlayStyle,
    this.title,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.titleTextStyle,
    this.toolbarHeight,
    this.toolbarOpacity = 1,
    this.toolbarTextStyle,
    super.trailing,
    super.leading,
    super.middle,
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
  }) : super(autoImplyLeading: automaticallyImplyLeading);

  @override
  final List<Widget>? actions;

  @override
  final IconThemeData? actionsIconTheme;

  @override
  final bool automaticallyImplyLeading;

  @override
  final Color? backgroundColor;

  @override
  final double bottomOpacity;

  @override
  final bool? centerTitle;

  @override
  final double? elevation;

  @override
  final bool excludeHeaderSemantics;

  @override
  final Widget? flexibleSpace;

  @override
  final bool forceMaterialTransparency;

  @override
  final Color? foregroundColor;

  @override
  final IconThemeData? iconTheme;

  @override
  final double? leadingWidth;

  @override
  final ScrollNotificationPredicate notificationPredicate;

  @override
  final bool primary;

  @override
  final double? scrolledUnderElevation;

  @override
  final Color? shadowColor;

  @override
  final ShapeBorder? shape;

  @override
  final Color? surfaceTintColor;

  @override
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  final Widget? title;

  @override
  final double? titleSpacing;

  @override
  final TextStyle? titleTextStyle;

  @override
  final double? toolbarHeight;

  @override
  final double toolbarOpacity;

  @override
  final TextStyle? toolbarTextStyle;

  @override
  List<Widget> get customLeading => leading;
}

class AdaptiveMaterialAppBar extends AppBar with AdaptiveAppBar {
  AdaptiveMaterialAppBar({
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
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtk_window/gtk_window.dart';

import 'breakpoints/breakpoint.dart';

const double kLargeAppBarHeight = 72;
const double kSmallAppBarHeight = 56;

/// AdaptiveAppBar has a leading width of 72.0. Everything else is the same as
/// [AppBar].
extension AdaptiveAppBar on AppBar {
  /// Constructs a default [AppBar] with predefined [leadingWidth] and
  /// [titleSpacing]. Inspired by the AdaptiveAppBar implementation of
  /// material.io.
  static PreferredSizeWidget fromContext({
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
    final Widget? leading,
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
  }) {
    const BreakpointGenerator desktopBreakpoint = BreakpointGenerator.generate(
      begin: 0,
      type: DeviceType.desktop,
    );
    if (desktopBreakpoint.isActive(context)) {
      return GTKHeaderBar(
        middle: title,
        leading: <Widget>[if (leading != null) leading],
      );
    }

    final bool isLargeScreen = PredefinedBreakpoint.largeAndUp.isActive(
      context,
    );
    return AppBar(
      leadingWidth: leadingWidth ??
          (isLargeScreen ? kLargeAppBarHeight : kSmallAppBarHeight),
      key: key,
      automaticallyImplyLeading: automaticallyImplyLeading,
      primary: primary,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      leading: leading,
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtk_window/gtk_window.dart';

import 'breakpoints/breakpoint.dart';

const double kLargeAppBarHeight = 72;
const double kSmallAppBarHeight = 56;

/// AdaptiveAppBar has a leading width of 72.0. Everything else is the same as
/// [AppBar].
mixin AdaptiveAppBar {
  abstract final Widget? title;
  abstract final bool automaticallyImplyLeading;
  abstract final dynamic customLeading;
  abstract final Key? key;
  abstract final OnWillPop? onWillPop;
  abstract final Breakpoint appBarBreakpoint;
  abstract final PreferredSizeWidget? bottom;
  abstract final GTKAppBarSpecificOptions gtkSpecificOptions;
  abstract final MaterialAppBarSpecificOptions materialSpecificOptions;

  static const Breakpoint desktop = BreakpointGenerator.generate(
    begin: 0,
    type: DeviceType.desktop,
  );

  static AdaptiveAppBar fromContext({
    required final BuildContext context,
    final Breakpoint appBarBreakpoint = desktop,
    final Key? key,
    final dynamic leading,
    final Widget? title,
    final bool automaticallyImplyLeading = true,
    final OnWillPop? onWillPop,
    final PreferredSizeWidget? bottom,
    final GTKAppBarSpecificOptions gtkSpecificOptions =
        const GTKAppBarSpecificOptions(),
    final MaterialAppBarSpecificOptions materialSpecificOptions =
        const MaterialAppBarSpecificOptions(),
  }) {
    if (desktop.isActive(context)) {
      return AdaptiveGTKAppBar(
        key: key,
        title: title,
        leading: leading is List<Widget>
            ? leading
            : <Widget>[if (leading != null) leading],
        trailing: gtkSpecificOptions.trailing,
        automaticallyImplyLeading: automaticallyImplyLeading,
        onWillPop: onWillPop,
        onBackButtonPressed: gtkSpecificOptions.onBackButtonPressed,
        onDrawerButtonPressed: gtkSpecificOptions.onDrawerButtonPressed,
        onWindowResize: gtkSpecificOptions.onWindowResize,
        backButtonStyle: gtkSpecificOptions.backButtonStyle,
        backButtonColor: gtkSpecificOptions.backButtonColor,
        appBarBreakpoint: appBarBreakpoint,
        bottom: bottom,
        //? TODO(helpisdev): Implementation specific, find better way?
        height: gtkSpecificOptions.height ?? 56,
        middleSpacing: gtkSpecificOptions.middleSpacing,
        padding: gtkSpecificOptions.padding,
        showLeading: gtkSpecificOptions.showLeading,
        showTrailing: gtkSpecificOptions.showTrailing,
        showMaximizeButton: gtkSpecificOptions.showMaximizeButton,
        showMinimizeButton: gtkSpecificOptions.showMinimizeButton,
        showCloseButton: gtkSpecificOptions.showCloseButton,
        showWindowControlsButtons: gtkSpecificOptions.showWindowControlsButtons,
        drawerButtonStyle: gtkSpecificOptions.drawerButtonStyle,
      );
    }

    final bool isLargeScreen = PredefinedBreakpoint.largeAndUp.isActive(
      context,
    );
    return AdaptiveMaterialAppBar(
      leadingWidth: materialSpecificOptions.leadingWidth ??
          (isLargeScreen ? kLargeAppBarHeight : kSmallAppBarHeight),
      key: key,
      automaticallyImplyLeading: automaticallyImplyLeading,
      primary: materialSpecificOptions.primary,
      excludeHeaderSemantics: materialSpecificOptions.excludeHeaderSemantics,
      titleSpacing: materialSpecificOptions.titleSpacing,
      toolbarOpacity: materialSpecificOptions.toolbarOpacity,
      bottomOpacity: materialSpecificOptions.bottomOpacity,
      leading: leading is Widget? ? leading : null,
      title: title,
      actions: materialSpecificOptions.actions,
      flexibleSpace: materialSpecificOptions.flexibleSpace,
      bottom: bottom,
      elevation: materialSpecificOptions.elevation,
      scrolledUnderElevation: materialSpecificOptions.scrolledUnderElevation,
      notificationPredicate: materialSpecificOptions.notificationPredicate,
      shadowColor: materialSpecificOptions.shadowColor,
      surfaceTintColor: materialSpecificOptions.surfaceTintColor,
      shape: materialSpecificOptions.shape,
      backgroundColor: materialSpecificOptions.backgroundColor,
      foregroundColor: materialSpecificOptions.foregroundColor,
      iconTheme: materialSpecificOptions.iconTheme,
      actionsIconTheme: materialSpecificOptions.actionsIconTheme,
      centerTitle: materialSpecificOptions.centerTitle,
      toolbarHeight: materialSpecificOptions.toolbarHeight,
      toolbarTextStyle: materialSpecificOptions.toolbarTextStyle,
      titleTextStyle: materialSpecificOptions.titleTextStyle,
      systemOverlayStyle: materialSpecificOptions.systemOverlayStyle,
      forceMaterialTransparency:
          materialSpecificOptions.forceMaterialTransparency,
      appBarBreakpoint: appBarBreakpoint,
      onWillPop: onWillPop,
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
      title: appBar?.title,
      automaticallyImplyLeading: appBar?.automaticallyImplyLeading ?? true,
      leading: appBar?.customLeading,
      key: appBar?.key,
      onWillPop: appBar?.onWillPop,
      bottom: appBar?.bottom,
      gtkSpecificOptions:
          appBar?.gtkSpecificOptions ?? const GTKAppBarSpecificOptions(),
      materialSpecificOptions: appBar?.materialSpecificOptions ??
          const MaterialAppBarSpecificOptions(),
    ) as PreferredSizeWidget;
  }
}

class AdaptiveGTKAppBar extends GTKHeaderBar with AdaptiveAppBar {
  const AdaptiveGTKAppBar({
    final bool automaticallyImplyLeading = true,
    final Widget? title,
    this.appBarBreakpoint = AdaptiveAppBar.desktop,
    super.onBackButtonPressed,
    super.onDrawerButtonPressed,
    super.onWindowResize,
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
    super.onWillPop,
    super.drawerButtonStyle,
    super.key,
  }) : super(autoImplyLeading: automaticallyImplyLeading, middle: title);

  @override
  List<Widget> get customLeading => leading;

  @override
  final Breakpoint appBarBreakpoint;

  @override
  bool get automaticallyImplyLeading => super.autoImplyLeading;

  @override
  GTKAppBarSpecificOptions get gtkSpecificOptions => GTKAppBarSpecificOptions(
        onBackButtonPressed: super.onBackButtonPressed,
        onDrawerButtonPressed: super.onDrawerButtonPressed,
        onWindowResize: super.onWindowResize,
        backButtonColor: super.backButtonColor,
        backButtonStyle: super.backButtonStyle,
        trailing: super.trailing,
        leading: super.leading,
        bottom: super.bottom,
        height: super.height,
        middleSpacing: super.middleSpacing,
        padding: super.padding,
        showLeading: super.showLeading,
        showTrailing: super.showTrailing,
        showMaximizeButton: super.showMaximizeButton,
        showMinimizeButton: super.showMinimizeButton,
        showCloseButton: super.showCloseButton,
        showWindowControlsButtons: super.showWindowControlsButtons,
        drawerButtonStyle: super.drawerButtonStyle,
      );

  @override
  MaterialAppBarSpecificOptions get materialSpecificOptions =>
      const MaterialAppBarSpecificOptions();

  @override
  Widget? get title => super.middle;
}

class AdaptiveMaterialAppBar extends AppBar with AdaptiveAppBar {
  AdaptiveMaterialAppBar({
    this.appBarBreakpoint = AdaptiveAppBar.desktop,
    this.onWillPop,
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
  final OnWillPop? onWillPop;

  @override
  final Breakpoint appBarBreakpoint;

  @override
  Widget? get customLeading => leading;

  @override
  GTKAppBarSpecificOptions get gtkSpecificOptions =>
      const GTKAppBarSpecificOptions();

  @override
  MaterialAppBarSpecificOptions get materialSpecificOptions =>
      MaterialAppBarSpecificOptions(
        automaticallyImplyLeading: super.automaticallyImplyLeading,
        title: super.title,
        actions: super.actions,
        flexibleSpace: super.flexibleSpace,
        elevation: super.elevation,
        scrolledUnderElevation: super.scrolledUnderElevation,
        notificationPredicate: super.notificationPredicate,
        shadowColor: super.shadowColor,
        surfaceTintColor: super.surfaceTintColor,
        shape: super.shape,
        backgroundColor: super.backgroundColor,
        foregroundColor: super.foregroundColor,
        iconTheme: super.iconTheme,
        actionsIconTheme: super.actionsIconTheme,
        primary: super.primary,
        centerTitle: super.centerTitle,
        excludeHeaderSemantics: super.excludeHeaderSemantics,
        titleSpacing: super.titleSpacing,
        toolbarOpacity: super.toolbarOpacity,
        bottomOpacity: super.bottomOpacity,
        toolbarHeight: super.toolbarHeight,
        leadingWidth: super.leadingWidth,
        toolbarTextStyle: super.toolbarTextStyle,
        titleTextStyle: super.titleTextStyle,
        systemOverlayStyle: super.systemOverlayStyle,
        forceMaterialTransparency: super.forceMaterialTransparency,
      );
}

class GTKAppBarSpecificOptions {
  const GTKAppBarSpecificOptions({
    this.trailing = const <Widget>[],
    this.leading = const <Widget>[],
    this.bottom,
    this.height,
    this.middleSpacing = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.showLeading = true,
    this.showTrailing = true,
    this.showMaximizeButton = true,
    this.showMinimizeButton = true,
    this.showCloseButton = true,
    this.showWindowControlsButtons = true,
    this.onWindowResize,
    this.autoImplyLeading = true,
    this.backButtonStyle,
    this.backButtonColor,
    this.onDrawerButtonPressed,
    this.onBackButtonPressed,
    this.drawerButtonStyle,
  }) : super();

  final VoidCallback? onBackButtonPressed;
  final VoidCallback? onDrawerButtonPressed;
  final WindowResizeCallback? onWindowResize;
  final Color? backButtonColor;
  final ButtonStyle? backButtonStyle;
  final List<Widget> trailing;
  final List<Widget> leading;
  final PreferredSizeWidget? bottom;
  final double? height;
  final double middleSpacing;
  final EdgeInsetsGeometry padding;
  final bool autoImplyLeading;
  final bool showLeading;
  final bool showTrailing;
  final bool showMaximizeButton;
  final bool showMinimizeButton;
  final bool showCloseButton;
  final bool showWindowControlsButtons;
  final ButtonStyle? drawerButtonStyle;
}

class MaterialAppBarSpecificOptions {
  const MaterialAppBarSpecificOptions({
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
    this.titleSpacing,
    this.titleTextStyle,
    this.toolbarHeight,
    this.toolbarOpacity = 1,
    this.toolbarTextStyle,
  }) : super();

  final List<Widget>? actions;
  final IconThemeData? actionsIconTheme;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final double bottomOpacity;
  final bool? centerTitle;
  final double? elevation;
  final bool excludeHeaderSemantics;
  final Widget? flexibleSpace;
  final bool forceMaterialTransparency;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final double? leadingWidth;
  final ScrollNotificationPredicate notificationPredicate;
  final bool primary;
  final double? scrolledUnderElevation;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final Color? surfaceTintColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final Widget? title;
  final double? titleSpacing;
  final TextStyle? titleTextStyle;
  final double? toolbarHeight;
  final double toolbarOpacity;
  final TextStyle? toolbarTextStyle;
}

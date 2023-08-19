import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../typedefs.dart';

/// A regular [Scaffold] that implements [Screen]. Does not add any specific
/// functionality other than enabling using a [Scaffold] as a [Screen].
@immutable
class ScreenScaffold extends Scaffold with Screen {
  const ScreenScaffold._({
    required this.state,
    super.appBar,
    super.body,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
    super.floatingActionButtonAnimator,
    super.persistentFooterButtons,
    super.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    super.drawer,
    super.onDrawerChanged,
    super.endDrawer,
    super.onEndDrawerChanged,
    super.bottomNavigationBar,
    super.bottomSheet,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    super.primary = true,
    super.drawerDragStartBehavior = DragStartBehavior.start,
    super.extendBody = false,
    super.extendBodyBehindAppBar = false,
    super.drawerScrimColor,
    super.drawerEdgeDragWidth,
    super.drawerEnableOpenDragGesture = true,
    super.endDrawerEnableOpenDragGesture = true,
    super.restorationId,
    super.key,
  }) : super();

  /// Generates a [ScreenScaffold] from a regular [Scaffold], optionally
  /// attaches a [GlobalKey] of [ScaffoldState], and provides any requested
  /// overrides.
  factory ScreenScaffold.from({
    required final GoRouterState state,
    required final Scaffold scaffold,
    final GlobalKey<ScaffoldState>? key,
    final bool? extendBody,
    final bool? extendBodyBehindAppBar,
    final PreferredSizeWidget? appBar,
    final Widget? body,
    final Widget? floatingActionButton,
    final FloatingActionButtonLocation? floatingActionButtonLocation,
    final FloatingActionButtonAnimator? floatingActionButtonAnimator,
    final List<Widget>? persistentFooterButtons,
    final AlignmentDirectional? persistentFooterAlignment,
    final Widget? drawer,
    final DrawerCallback? onDrawerChanged,
    final Widget? endDrawer,
    final DrawerCallback? onEndDrawerChanged,
    final Color? drawerScrimColor,
    final Color? backgroundColor,
    final Widget? bottomNavigationBar,
    final Widget? bottomSheet,
    final bool? resizeToAvoidBottomInset,
    final bool? primary,
    final DragStartBehavior? drawerDragStartBehavior,
    final double? drawerEdgeDragWidth,
    final bool? drawerEnableOpenDragGesture,
    final bool? endDrawerEnableOpenDragGesture,
    final String? restorationId,
  }) =>
      ScreenScaffold._(
        state: state,
        extendBody: extendBody ?? scaffold.extendBody,
        extendBodyBehindAppBar:
            extendBodyBehindAppBar ?? scaffold.extendBodyBehindAppBar,
        appBar: appBar ?? scaffold.appBar,
        body: body ?? scaffold.body,
        floatingActionButton:
            floatingActionButton ?? scaffold.floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation ??
            scaffold.floatingActionButtonLocation,
        floatingActionButtonAnimator: floatingActionButtonAnimator ??
            scaffold.floatingActionButtonAnimator,
        persistentFooterButtons:
            persistentFooterButtons ?? scaffold.persistentFooterButtons,
        persistentFooterAlignment:
            persistentFooterAlignment ?? scaffold.persistentFooterAlignment,
        drawer: drawer ?? scaffold.drawer,
        onDrawerChanged: onDrawerChanged ?? scaffold.onDrawerChanged,
        endDrawer: endDrawer ?? scaffold.endDrawer,
        onEndDrawerChanged: onEndDrawerChanged ?? scaffold.onEndDrawerChanged,
        drawerScrimColor: drawerScrimColor ?? scaffold.drawerScrimColor,
        backgroundColor: backgroundColor ?? scaffold.backgroundColor,
        bottomNavigationBar:
            bottomNavigationBar ?? scaffold.bottomNavigationBar,
        bottomSheet: bottomSheet ?? scaffold.bottomSheet,
        resizeToAvoidBottomInset:
            resizeToAvoidBottomInset ?? scaffold.resizeToAvoidBottomInset,
        primary: primary ?? scaffold.primary,
        drawerDragStartBehavior:
            drawerDragStartBehavior ?? scaffold.drawerDragStartBehavior,
        drawerEdgeDragWidth:
            drawerEdgeDragWidth ?? scaffold.drawerEdgeDragWidth,
        drawerEnableOpenDragGesture:
            drawerEnableOpenDragGesture ?? scaffold.drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture ??
            scaffold.endDrawerEnableOpenDragGesture,
        restorationId: restorationId ?? scaffold.restorationId,
        key: key ?? GlobalKey<ScaffoldState>(),
      );

  @override
  final GoRouterState state;
}

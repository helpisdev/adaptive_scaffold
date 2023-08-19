import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:adaptive_scaffold/adaptive_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../typedefs.dart';

/// An [AdaptiveScaffold] wrapper that implements [Screen] and wraps the
/// provided bodies with an [AccessibilityTools] checker.
@immutable
class ScreenAdaptiveScaffold extends StatelessWidget with Screen {
  const ScreenAdaptiveScaffold({
    required this.adaptiveScaffoldConfig,
    required this.state,
    super.key,
  });

  @override
  final GoRouterState state;
  final GoRouterAdaptiveScaffoldConfig adaptiveScaffoldConfig;

  @override
  Widget build(final BuildContext context) => AdaptiveScaffold(
        config: adaptiveScaffoldConfig.copyWith(
          bodyConfig: BodyConfig(
            body: _accessibilityBuilder(
              adaptiveScaffoldConfig.bodyConfig.body?.call(context, state),
            ),
            small: _accessibilityBuilder(
              adaptiveScaffoldConfig.bodyConfig.small?.call(context, state),
            ),
            large: _accessibilityBuilder(
              adaptiveScaffoldConfig.bodyConfig.large?.call(context, state),
            ),
            secondary: _accessibilityBuilder(
              adaptiveScaffoldConfig.bodyConfig.secondary?.call(
                context,
                state,
              ),
            ),
            smallSecondary: _accessibilityBuilder(
              adaptiveScaffoldConfig.bodyConfig.smallSecondary?.call(
                context,
                state,
              ),
            ),
            largeSecondary: _accessibilityBuilder(
              adaptiveScaffoldConfig.bodyConfig.largeSecondary?.call(
                context,
                state,
              ),
            ),
          ),
        ),
      );

  WidgetBuilder? _accessibilityBuilder(final Widget? child) {
    if (child == null) {
      return null;
    }
    return (final BuildContext context) => AccessibilityTools(
          checkFontOverflows: true,
          child: child,
        );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<GoRouterAdaptiveScaffoldConfig>(
          'adaptiveScaffoldConfig',
          adaptiveScaffoldConfig,
        ),
      )
      ..add(DiagnosticsProperty<GoRouterState>('state', state));
  }
}

/// [BodyConfig] that passes [GoRouterState] to its body builders and sets
/// [ratio] to a default value of `1`.
///
/// See also:
///  * [WidgetBuilderWithGoRouterState], the builder type delegate that passes
///   [GoRouterState] to the corresponding [WidgetBuilder].
@immutable
class GoRouterBodyConfig extends BodyConfig {
  const GoRouterBodyConfig({
    final WidgetBuilderWithGoRouterState? small,
    final WidgetBuilderWithGoRouterState? body,
    final WidgetBuilderWithGoRouterState? large,
    final WidgetBuilderWithGoRouterState? smallSecondary,
    final WidgetBuilderWithGoRouterState? secondary,
    final WidgetBuilderWithGoRouterState? largeSecondary,
    super.orientation,
    super.ratio = 1,
  })  : _small = small,
        _body = body,
        _large = large,
        _smallSecondary = smallSecondary,
        _secondary = secondary,
        _largeSecondary = largeSecondary,
        super(
          body: body,
          large: large,
          largeSecondary: largeSecondary,
          secondary: secondary,
          small: small,
          smallSecondary: smallSecondary,
        );

  final WidgetBuilderWithGoRouterState? _small;
  final WidgetBuilderWithGoRouterState? _body;
  final WidgetBuilderWithGoRouterState? _large;
  final WidgetBuilderWithGoRouterState? _smallSecondary;
  final WidgetBuilderWithGoRouterState? _secondary;
  final WidgetBuilderWithGoRouterState? _largeSecondary;

  @override
  WidgetBuilderWithGoRouterState? get small =>
      _small ?? _getSuperWidgetBuilder(super.small);

  @override
  WidgetBuilderWithGoRouterState? get body =>
      _body ?? _getSuperWidgetBuilder(super.body);

  @override
  WidgetBuilderWithGoRouterState? get large =>
      _large ?? _getSuperWidgetBuilder(super.large);

  @override
  WidgetBuilderWithGoRouterState? get smallSecondary =>
      _smallSecondary ?? _getSuperWidgetBuilder(super.smallSecondary);

  @override
  WidgetBuilderWithGoRouterState? get secondary =>
      _secondary ?? _getSuperWidgetBuilder(super.secondary);

  @override
  WidgetBuilderWithGoRouterState? get largeSecondary =>
      _largeSecondary ?? _getSuperWidgetBuilder(super.largeSecondary);

  static WidgetBuilderWithGoRouterState? _getSuperWidgetBuilder(
    final WidgetBuilder? builder,
  ) {
    if (builder != null) {
      return (
        final BuildContext context, [
        final GoRouterState? state,
      ]) =>
          builder.call(context);
    }
    return null;
  }

  @override
  GoRouterBodyConfig wrap(
    covariant final WidgetBuilderWithGoRouterStateWrapper builder,
  ) =>
      GoRouterBodyConfig(
        body: builder(body),
        large: builder(large),
        largeSecondary: builder(largeSecondary),
        orientation: orientation,
        ratio: ratio,
        secondary: builder(secondary),
        small: builder(small),
        smallSecondary: builder(smallSecondary),
      );
}

/// [AdaptiveScaffoldConfig] that takes a [GoRouterBodyConfig] instead of
/// [BodyConfig], passing [GoRouterState] to its bodies.
///
/// See also:
///  * [GoRouterBodyConfig], which configures the body widget builders.
@immutable
class GoRouterAdaptiveScaffoldConfig extends AdaptiveScaffoldConfig {
  const GoRouterAdaptiveScaffoldConfig({
    required super.navigationRailConfig,
    final GoRouterBodyConfig? bodyConfig,
    super.breakpointConfig,
    super.scrollbarConfig,
    super.appBar,
    super.drawerConfig,
    super.useSalomonBar,
    super.useInternalAnimations,
    super.iconSize,
    super.extendBody,
    super.extendBodyBehindAppBar,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
    super.floatingActionButtonAnimator,
    super.persistentFooterButtons,
    super.persistentFooterAlignment,
    super.backgroundColor,
    super.bottomSheet,
    super.resizeToAvoidBottomInset,
    super.primary,
    super.restorationId,
  })  : _bodyConfig = bodyConfig,
        super(bodyConfig: bodyConfig ?? const BodyConfig());

  /// Generates a [GoRouterAdaptiveScaffoldConfig] from an
  /// [AdaptiveScaffoldConfig] and a [GoRouterBodyConfig], with optional
  /// properties overrides.
  factory GoRouterAdaptiveScaffoldConfig.from({
    required final AdaptiveScaffoldConfig config,
    required final GoRouterBodyConfig bodyConfig,
    final BreakpointConfig? breakpointConfig,
    final AdaptiveScrollbarConfig? scrollbarConfig,
    final NavigationRailConfig? navigationRailConfig,
    final AdaptiveDrawerConfig? drawerConfig,
    final double? iconSize,
    final bool? useInternalAnimations,
    final bool? useSalomonBar,
    final AdaptiveAppBar? appBar,
    final bool? extendBody,
    final bool? extendBodyBehindAppBar,
    final Widget? floatingActionButton,
    final FloatingActionButtonLocation? floatingActionButtonLocation,
    final FloatingActionButtonAnimator? floatingActionButtonAnimator,
    final List<Widget>? persistentFooterButtons,
    final AlignmentDirectional? persistentFooterAlignment,
    final Color? backgroundColor,
    final Widget? bottomSheet,
    final bool? resizeToAvoidBottomInset,
    final bool? primary,
    final String? restorationId,
  }) =>
      GoRouterAdaptiveScaffoldConfig(
        navigationRailConfig:
            navigationRailConfig ?? config.navigationRailConfig,
        breakpointConfig: breakpointConfig ?? config.breakpointConfig,
        scrollbarConfig: scrollbarConfig ?? config.scrollbarConfig,
        drawerConfig: drawerConfig ?? config.drawerConfig,
        iconSize: iconSize ?? config.iconSize,
        useInternalAnimations:
            useInternalAnimations ?? config.useInternalAnimations,
        useSalomonBar: useSalomonBar ?? config.useSalomonBar,
        appBar: appBar ?? config.appBar,
        extendBody: extendBody ?? config.extendBody,
        extendBodyBehindAppBar:
            extendBodyBehindAppBar ?? config.extendBodyBehindAppBar,
        floatingActionButton:
            floatingActionButton ?? config.floatingActionButton,
        floatingActionButtonLocation:
            floatingActionButtonLocation ?? config.floatingActionButtonLocation,
        floatingActionButtonAnimator:
            floatingActionButtonAnimator ?? config.floatingActionButtonAnimator,
        persistentFooterButtons:
            persistentFooterButtons ?? config.persistentFooterButtons,
        persistentFooterAlignment:
            persistentFooterAlignment ?? config.persistentFooterAlignment,
        backgroundColor: backgroundColor ?? config.backgroundColor,
        bottomSheet: bottomSheet ?? config.bottomSheet,
        resizeToAvoidBottomInset:
            resizeToAvoidBottomInset ?? config.resizeToAvoidBottomInset,
        primary: primary ?? config.primary,
        restorationId: restorationId ?? config.restorationId,
        bodyConfig: bodyConfig,
      );

  final GoRouterBodyConfig? _bodyConfig;

  @override
  GoRouterBodyConfig get bodyConfig =>
      _bodyConfig ?? _getSuperBodyConfig(super.bodyConfig);

  GoRouterBodyConfig _getSuperBodyConfig(final BodyConfig config) =>
      GoRouterBodyConfig(
        small: GoRouterBodyConfig._getSuperWidgetBuilder(config.small),
        body: GoRouterBodyConfig._getSuperWidgetBuilder(config.body),
        large: GoRouterBodyConfig._getSuperWidgetBuilder(config.large),
        smallSecondary: GoRouterBodyConfig._getSuperWidgetBuilder(
          config.smallSecondary,
        ),
        secondary: GoRouterBodyConfig._getSuperWidgetBuilder(config.secondary),
        largeSecondary: GoRouterBodyConfig._getSuperWidgetBuilder(
          config.largeSecondary,
        ),
        orientation: config.orientation,
        ratio: config.ratio,
      );
}

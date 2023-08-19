import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'widgets/widgets.dart';

// typedefs
/// Signature for a callback that creates a [Widget] being provided the current
/// [BuildContext] and an optional [GoRouterState].
///
/// Typically used build bodies of a scaffold that require a [WidgetBuilder] but
/// you need to also provide the current [GoRouterState] without breaking the
/// type signture of the [WidgetBuilder].
typedef WidgetBuilderWithGoRouterState = Widget Function(
  BuildContext context, [
  GoRouterState? state,
]);

typedef WidgetBuilderWithGoRouterStateWrapper = WidgetBuilderWithGoRouterState?
    Function(WidgetBuilder? body);

/// Signature for a callback that creates a [Screen] being provided the current
/// [BuildContext] and the current [GoRouterState].
///
/// Used by application routes to ensure that they return a screen that fulfills
/// the requirements of a [Screen].
///
/// See also:
///  * [Screen], which is the applications base type that defines a screen.
typedef RouteScreenBuilder = Screen Function(
  BuildContext context,
  GoRouterState state,
);

// interfaces
/// Used to enforce any implementer to have a [GoRouterState] `state` attribute.
///
/// This should be useful for creating custom screens that should have access
/// to the routing data provided by the [GoRouter], because [GoRouter] requires
/// that its defined screens are of type `T extends GoRouteData`.
///
/// See also:
///  * [GoRouteData], which is the type that [GoRouter] requires its routes to
///   be.
abstract class GoRouterStateData {
  abstract final GoRouterState state;
}

// mixins
/// Defines the base of a screen within the application.
///
/// Each [Screen] must be a [Widget] so that it can be returned from a `build`
/// method, and must have access to a [GoRouterState] to be able to handle
/// routing logic, if necessary.
mixin Screen on Widget implements GoRouterStateData {}

/// Attributes that [ScreenBuilder] implementers must provide.
mixin ScreenScaffoldAttributes {
  abstract final Scaffold? scaffold;
  abstract final GoRouterAdaptiveScaffoldConfig? adaptiveScaffoldConfig;
}

/// A [Screen] of type `T`, that implements [ScreenScaffoldAttributes] and
/// enforces its implementers to provide a [generate] function, that creates an
/// object `T` from an other instance of `T`.
abstract class ScreenWidget<T extends ScreenWidget<T>>
    implements Screen, ScreenScaffoldAttributes {
  /// Acts as a constructor from an instance, or a `copyWith` method.
  @factory
  T generate({
    final GoRouterState? state,
    final GoRouterAdaptiveScaffoldConfig? adaptiveScaffoldConfig,
    final Scaffold? scaffold,
    final Key? key,
  });
}

/// This is used to enforce a widget to return a [Screen] from its [build]
/// method.
mixin ScreenBuilder {
  Screen build(final BuildContext context);
}

/// Same as [ScreenBuilder], to be used with riverpod's widgets.
mixin ConsumerScreenBuilder {
  Screen build(final BuildContext context, final WidgetRef ref);
}

/// Defines a base route that enforces application screens to be of type
/// [Screen].
@immutable
abstract class ScreenRoute extends GoRouteData {
  const ScreenRoute() : super();

  /// The screen builder that returns a [Screen].
  abstract final RouteScreenBuilder builder;

  /// Screen's title.
  String title(final BuildContext context) => throw UnimplementedError();

  @override
  Screen build(final BuildContext context, final GoRouterState state) =>
      builder(context, state);
}

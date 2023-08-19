import 'package:adaptive_scaffold/adaptive_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';

import '../func.dart';
import '../typedefs.dart';
import 'widgets.dart';

/// A stateless [Screen] that implements [ScreenBuilder].
///
/// Either an [AdaptiveScaffoldConfig] or a custom [Scaffold] must be provided
/// to build the underlying screen.
///
/// This widget enforces its users to use a scaffold on their screen.
@immutable
final class StatelessScreen
    extends StatelessScreenWidgetBuilder<StatelessScreen> {
  const StatelessScreen({
    required this.state,
    this.adaptiveScaffoldConfig,
    this.scaffold,
    super.key,
  }) : assert(
          adaptiveScaffoldConfig != null || scaffold != null,
          'Either a scaffold or an adaptive scaffold '
          'configuration must be provided.',
        );

  @override
  final GoRouterState state;

  @override
  final Scaffold? scaffold;

  @override
  final GoRouterAdaptiveScaffoldConfig? adaptiveScaffoldConfig;

  @override
  StatelessScreen generate({
    final GoRouterState? state,
    final Scaffold? scaffold,
    final GoRouterAdaptiveScaffoldConfig? adaptiveScaffoldConfig,
    final Key? key,
  }) =>
      StatelessScreen(
        state: state ?? this.state,
        scaffold: scaffold ?? this.scaffold,
        adaptiveScaffoldConfig:
            adaptiveScaffoldConfig ?? this.adaptiveScaffoldConfig,
        key: key ?? this.key,
      );

  @override
  Screen build(final BuildContext context) {
    if (scaffold == null && adaptiveScaffoldConfig == null) {
      throw StateError(
        'Either a scaffold or an adaptive scaffold '
        'configuration must be provided.',
      );
    }
    return produceT1fromT2orNull<ScreenScaffold, Scaffold>(
          (final Scaffold scaffold) => ScreenScaffold.from(
            state: state,
            scaffold: scaffold,
          ),
          scaffold,
        ) ??
        ScreenAdaptiveScaffold(
          adaptiveScaffoldConfig: adaptiveScaffoldConfig!,
          state: state,
        );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<GoRouterAdaptiveScaffoldConfig?>(
          'adaptiveScaffoldConfig',
          adaptiveScaffoldConfig,
        ),
      )
      ..add(DiagnosticsProperty<GoRouterState>('state', state))
      ..add(DiagnosticsProperty<Scaffold?>('scaffold', scaffold));
  }
}

/// Defines a [StatelessWidget] that can be used as an application screen.
///
/// This widget does not enforce its build method to return a widget of type
/// [Screen], to enable handling difficult business logic situations.
///
/// For example, to have a widget at a fixed position on screen without being
/// restricted by a scaffold, you would need to have a [Stack] outside of that
/// scaffold. Since [Screen]s require to return a scaffold, that would not
/// be possible with a widget that implements [ScreenBuilder].
///
/// Prefer using [StatelessScreenWidgetBuilder] instead since it implements
/// [ScreenBuilder].
///
/// See also:
///  * [ScreenBuilder], the interface that requires the build method to
///   return a screen.
///  * [StatelessScreenWidgetBuilder], that is a stateless screen that
///   implements [ScreenBuilder].
///  * [ConsumerScreenWidgetBuilder], that is a stateless screen that
///   implements [ConsumerScreenBuilder] and has access to Riverpod's
///   [WidgetRef].
///  * [StatefulScreenWidgetBuilder], that is a stateful screen that
///   implements [ScreenBuilder].
///  * [ConsumerStatefulScreenWidgetBuilder], that is a stateful screen that
///   implements [ConsumerScreenBuilder] and has access to Riverpod's
///   [WidgetRef].
@immutable
abstract class StatelessScreenWidget extends StatelessWidget with Screen {
  const StatelessScreenWidget({super.key});
}

/// Defines a [StatelessWidget] that can be used as an application screen.
///
/// This widget enforces its build method to return a widget of type
/// [Screen], so that the application has a uniform base look and
/// attributes.
///
/// See also:
///  * [ScreenBuilder], the interface that requires the build method to
///   return a screen.
///  * [StatelessScreenWidgetBuilder], that is a stateless screen that
///   implements [ScreenBuilder].
///  * [ConsumerScreenWidgetBuilder], that is a stateless screen that
///   implements [ConsumerScreenBuilder] and has access to Riverpod's
///   [WidgetRef].
///  * [StatefulScreenWidgetBuilder], that is a stateful screen that
///   implements [ScreenBuilder].
///  * [ConsumerStatefulScreenWidgetBuilder], that is a stateful screen that
///   implements [ConsumerScreenBuilder] and has access to Riverpod's
///   [WidgetRef].
abstract class StatelessScreenWidgetBuilder<
        T extends StatelessScreenWidgetBuilder<T>> extends StatelessScreenWidget
    implements ScreenBuilder, ScreenWidget<T> {
  const StatelessScreenWidgetBuilder({super.key});

  @override
  Scaffold? get scaffold => null;

  @override
  GoRouterAdaptiveScaffoldConfig? get adaptiveScaffoldConfig => null;

  @mustBeOverridden
  @override
  T generate({
    final GoRouterState? state,
    final Scaffold? scaffold,
    final GoRouterAdaptiveScaffoldConfig? adaptiveScaffoldConfig,
    final Key? key,
  }) =>
      throw UnimplementedError();
}

import 'package:adaptive_scaffold/adaptive_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';

import '../func.dart';
import '../typedefs.dart';
import 'widgets.dart';

/// A stateless [Screen] that implements [ConsumerScreenBuilder].
///
/// Either an [AdaptiveScaffoldConfig] or a custom [Scaffold] must be provided
/// to build the underlying screen.
///
/// This widget enforces its users to use a scaffold on their screen.
@immutable
final class ConsumerScreen extends ConsumerScreenWidgetBuilder<ConsumerScreen> {
  const ConsumerScreen({
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
  ConsumerScreen generate({
    final GoRouterState? state,
    final Scaffold? scaffold,
    final GoRouterAdaptiveScaffoldConfig? adaptiveScaffoldConfig,
    final Key? key,
  }) =>
      ConsumerScreen(
        state: state ?? this.state,
        scaffold: scaffold ?? this.scaffold,
        adaptiveScaffoldConfig:
            adaptiveScaffoldConfig ?? this.adaptiveScaffoldConfig,
        key: key ?? this.key,
      );

  @override
  final GoRouterState state;

  @override
  final Scaffold? scaffold;

  @override
  final GoRouterAdaptiveScaffoldConfig? adaptiveScaffoldConfig;

  @override
  Screen build(final BuildContext context, final WidgetRef ref) {
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

/// Same as [StatelessScreenWidget], that can be used with Riverpod.
@immutable
abstract class ConsumerScreenWidget extends ConsumerWidget with Screen {
  const ConsumerScreenWidget({super.key});
}

/// Same as [StatelessScreenWidgetBuilder], that can be used with Riverpod.
@immutable
abstract class ConsumerScreenWidgetBuilder<
        T extends ConsumerScreenWidgetBuilder<T>> extends ConsumerScreenWidget
    implements ConsumerScreenBuilder, ScreenWidget<T> {
  const ConsumerScreenWidgetBuilder({super.key});

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

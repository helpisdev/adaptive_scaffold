import 'package:adaptive_scaffold/adaptive_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';

import '../func.dart';
import '../typedefs.dart';
import 'widgets.dart';

/// A stateful [Screen] that implements [ConsumerScreenBuilder].
///
/// Either an [AdaptiveScaffoldConfig] or a custom [Scaffold] must be provided
/// to build the underlying screen.
///
/// This widget enforces its users to use a scaffold on their screen.
@immutable
class ConsumerStatefulScreen
    extends ConsumerStatefulScreenWidgetBuilder<ConsumerStatefulScreen> {
  const ConsumerStatefulScreen({
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
  ConsumerStatefulScreen generate({
    final GoRouterState? state,
    final Scaffold? scaffold,
    final GoRouterAdaptiveScaffoldConfig? adaptiveScaffoldConfig,
    final Key? key,
  }) =>
      ConsumerStatefulScreen(
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
  ConsumerStatefulScreenWidgetBuilderState<ConsumerStatefulScreen>
      createState() => ConsumerStatefulScreenState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<GoRouterAdaptiveScaffoldConfig?>(
        'adaptiveScaffoldConfig',
        adaptiveScaffoldConfig,
      ),
    );
  }
}

class ConsumerStatefulScreenState
    extends ConsumerStatefulScreenWidgetBuilderState<ConsumerStatefulScreen> {
  @override
  @mustCallSuper
  @mustBeOverridden
  @useResult
  Screen build(final BuildContext context) {
    if (widget.scaffold == null && widget.adaptiveScaffoldConfig == null) {
      throw StateError(
        'Either a scaffold or an adaptive scaffold '
        'configuration must be provided.',
      );
    }
    return produceT1fromT2orNull<ScreenScaffold, Scaffold>(
          (final Scaffold scaffold) => ScreenScaffold.from(
            state: widget.state,
            scaffold: scaffold,
          ),
          widget.scaffold,
        ) ??
        ScreenAdaptiveScaffold(
          adaptiveScaffoldConfig: widget.adaptiveScaffoldConfig!,
          state: widget.state,
        );
  }
}

/// Same as [ConsumerStatefulScreenWidget], that can be used with Riverpod.
abstract class ConsumerStatefulScreenWidget extends ConsumerStatefulWidget
    with Screen {
  const ConsumerStatefulScreenWidget({super.key});
}

/// State object of [ConsumerStatefulScreenWidget].
abstract class ConsumerScreenState<T extends ConsumerStatefulScreenWidget>
    extends ConsumerState<T> {}

/// Same as [ConsumerStatefulScreenWidgetBuilder], that can be used with Riverpod.
abstract class ConsumerStatefulScreenWidgetBuilder<
        T extends ConsumerStatefulScreenWidgetBuilder<T>>
    extends ConsumerStatefulScreenWidget implements ScreenWidget<T> {
  const ConsumerStatefulScreenWidgetBuilder({super.key});

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

/// State object of [ConsumerStatefulScreenWidgetBuilder] that implements
/// [ScreenBuilder].
abstract class ConsumerStatefulScreenWidgetBuilderState<
        T extends ConsumerStatefulScreenWidgetBuilder<T>>
    extends ConsumerScreenState<T> implements ScreenBuilder {}

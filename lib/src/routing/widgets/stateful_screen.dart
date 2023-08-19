import 'package:adaptive_scaffold/adaptive_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';

import '../func.dart';
import '../typedefs.dart';
import 'widgets.dart';

/// A stateful [Screen] that implements [ScreenBuilder].
///
/// Either an [AdaptiveScaffoldConfig] or a custom [Scaffold] must be provided
/// to build the underlying screen.
///
/// This widget enforces its users to use a scaffold on their screen.
@immutable
class StatefulScreen extends StatefulScreenWidgetBuilder<StatefulScreen> {
  const StatefulScreen({
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
  StatefulScreen generate({
    final GoRouterState? state,
    final Scaffold? scaffold,
    final GoRouterAdaptiveScaffoldConfig? adaptiveScaffoldConfig,
    final Key? key,
  }) =>
      StatefulScreen(
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
  StatefulScreenWidgetBuilderState<StatefulScreen> createState() =>
      StatefulScreenState();

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

class StatefulScreenState
    extends StatefulScreenWidgetBuilderState<StatefulScreen> {
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

/// Defines a [StatefulWidget] that can be used as an application screen.
///
/// This widget does not enforce its state's build method to return a widget of
/// type [Screen], to enable handling difficult business logic situations.
///
/// For example, to have a widget at a fixed position on screen without being
/// restricted by a scaffold, you would need to have a [Stack] outside of that
/// scaffold. Since [Screen]s require to return a scaffold, that would not
/// be possible with a widget that implements [ScreenBuilder].
///
/// Prefer using [StatefulScreenWidgetBuilder] instead since its state
/// implements [ScreenBuilder].
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
abstract class StatefulScreenWidget extends StatefulWidget with Screen {
  const StatefulScreenWidget({super.key});
}

/// State object of [StatefulScreenWidget].
abstract class ScreenState<T extends StatefulScreenWidget> extends State<T> {}

/// Defines a [StatefulWidget] that can be used as an application screen.
///
/// This widget enforces its state's build method to return a widget of type
/// [Screen], so that the application has a uniform base look and
/// attributes.
///
/// See also:
///  * [ScreenBuilder], the interface that requires the build method to
///   return a screen,
///  * [StatelessScreenWidgetBuilder], that is a stateless screen that
///   implements [ScreenBuilder],
///  * [ConsumerScreenWidgetBuilder], that is a stateless screen that
///   implements [ConsumerScreenBuilder] and has access to Riverpod's
///   [WidgetRef],
///  * [StatefulScreenWidgetBuilder], that is a stateful screen that
///   implements [ScreenBuilder],
///  * [ConsumerStatefulScreenWidgetBuilder], that is a stateful screen that
///   implements [ConsumerScreenBuilder] and has access to Riverpod's
///   [WidgetRef].
@immutable
abstract class StatefulScreenWidgetBuilder<
        T extends StatefulScreenWidgetBuilder<T>> extends StatefulScreenWidget
    implements ScreenWidget<T> {
  const StatefulScreenWidgetBuilder({super.key});

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

/// State object of [StatefulScreenWidgetBuilder] that implements
/// [ScreenBuilder].
abstract class StatefulScreenWidgetBuilderState<
        T extends StatefulScreenWidgetBuilder<T>> extends ScreenState<T>
    implements ScreenBuilder {}

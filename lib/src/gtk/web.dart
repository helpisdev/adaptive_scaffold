import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef WindowResizeCallback = void Function(Size size);

class GTKHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const GTKHeaderBar({
    super.key,
    this.trailing = const <Widget>[],
    this.leading = const <Widget>[],
    this.middle,
    this.bottom,
    this.height = 2,
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
    this.onWillPopCallback,
    this.backButtonStyle,
    this.backButtonColor,
    this.onDrawerButtonPressedCallback,
    this.drawerButtonStyle,
  });
  final List<Widget> leading;
  final List<Widget> trailing;
  final Widget? middle;
  final PreferredSizeWidget? bottom;
  final double height;
  final double middleSpacing;
  final EdgeInsetsGeometry padding;
  final bool autoImplyLeading;
  final bool showLeading;
  final bool showTrailing;
  final bool showMaximizeButton;
  final bool showMinimizeButton;
  final bool showCloseButton;
  final bool showWindowControlsButtons;
  final WindowResizeCallback? onWindowResize;
  final VoidCallback? onWillPopCallback;
  final ButtonStyle? backButtonStyle;
  final Color? backButtonColor;
  final VoidCallback? onDrawerButtonPressedCallback;
  final ButtonStyle? drawerButtonStyle;

  @override
  Size get preferredSize => Size.zero;

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<WindowResizeCallback?>(
          'onWindowResize',
          onWindowResize,
        ),
      )
      ..add(DoubleProperty('height', height))
      ..add(DoubleProperty('middleSpacing', middleSpacing))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding))
      ..add(DiagnosticsProperty<bool>('showLeading', showLeading))
      ..add(DiagnosticsProperty<bool>('showTrailing', showTrailing))
      ..add(
        DiagnosticsProperty<bool>('showMaximizeButton', showMaximizeButton),
      )
      ..add(
        DiagnosticsProperty<bool>('showMinimizeButton', showMinimizeButton),
      )
      ..add(DiagnosticsProperty<bool>('showCloseButton', showCloseButton))
      ..add(
        DiagnosticsProperty<bool>(
          'showWindowControlsButtons',
          showWindowControlsButtons,
        ),
      )
      ..add(DiagnosticsProperty<bool>('autoImplyLeading', autoImplyLeading))
      ..add(
        ObjectFlagProperty<VoidCallback?>.has(
          'onWillPopCallback',
          onWillPopCallback,
        ),
      )
      ..add(
        DiagnosticsProperty<ButtonStyle?>('backButtonStyle', backButtonStyle),
      )
      ..add(ColorProperty('backButtonColor', backButtonColor))
      ..add(
        ObjectFlagProperty<VoidCallback?>.has(
          'onDrawerButtonPressedCallback',
          onDrawerButtonPressedCallback,
        ),
      )
      ..add(
        DiagnosticsProperty<ButtonStyle?>(
          'drawerButtonStyle',
          drawerButtonStyle,
        ),
      );
  }

  @override
  Widget build(final BuildContext context) => const SizedBox.shrink();
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'brick_layout_delegate.dart';

class BrickLayout extends StatelessWidget {
  const BrickLayout({
    required this.children,
    this.columns = 1,
    this.itemPadding = EdgeInsets.zero,
    this.columnSpacing = 0,
    super.key,
  });

  final int columns;
  final double columnSpacing;
  final EdgeInsetsGeometry itemPadding;
  final List<Widget> children;

  @override
  Widget build(final BuildContext context) {
    int i = -1;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: CustomMultiChildLayout(
            delegate: BrickLayoutDelegate(
              columns: columns,
              columnSpacing: columnSpacing,
              itemPadding: itemPadding,
            ),
            children: children
                .map<Widget>(
                  (final Widget child) => LayoutId(id: i += 1, child: child),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<EdgeInsetsGeometry>('itemPadding', itemPadding),
      )
      ..add(DoubleProperty('columnSpacing', columnSpacing))
      ..add(IntProperty('columns', columns));
  }
}

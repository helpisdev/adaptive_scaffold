import 'package:flutter/material.dart';

extension AnimationRunning on AnimationStatus {
  bool get running =>
      this == AnimationStatus.forward || this == AnimationStatus.reverse;

  bool get idle =>
      this == AnimationStatus.completed || this == AnimationStatus.dismissed;
}

extension Half on Size {
  Size get half => Size(width / 2, height / 2);
}

class SizeWithMargin extends Size {
  SizeWithMargin(final Size size) : super(size.width, size.height);

  final Margin margin = Margin();

  Size get remaining => Size(
        width - margin.right - margin.left,
        height - margin.bottom - margin.top,
      );
}

enum MarginSide {
  left,
  top,
  bottom,
  right;
}

class Margin {
  Margin({
    final double left = 0,
    final double top = 0,
    final double bottom = 0,
    final double right = 0,
  })  : _left = left,
        _right = right,
        _top = top,
        _bottom = bottom;

  double _left;
  double _top;
  double _right;
  double _bottom;

  double get left => _left;
  double get top => _top;
  double get right => _right;
  double get bottom => _bottom;

  double add(final double val, final MarginSide side) {
    switch (side) {
      case MarginSide.left:
        return _left += val;
      case MarginSide.top:
        return _top += val;
      case MarginSide.bottom:
        return _bottom += val;
      case MarginSide.right:
        return _right += val;
    }
  }

  double subtract(final double val, final MarginSide side) => add(-val, side);
}

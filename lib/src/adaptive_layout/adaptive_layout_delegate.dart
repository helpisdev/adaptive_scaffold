import 'package:flutter/material.dart';

import 'adaptive_layout.dart';
import 'slot_layout.dart';
import 'utils.dart';

/// The delegate responsible for laying out the slots in their correct
/// positions.
class AdaptiveLayoutDelegate extends MultiChildLayoutDelegate {
  AdaptiveLayoutDelegate({
    required this.bodyOrientation,
    required this.bodyRatio,
    required this.chosenWidgets,
    required this.controller,
    required this.useInternalAnimations,
    required this.isAnimating,
    required this.slotSizes,
    required this.slots,
    required this.isLTR,
    this.hinge,
  }) : super(relayout: controller);

  final AnimatingWidgetBucket isAnimating;
  final AnimationController controller;
  final Axis bodyOrientation;
  final ChosenWidgetRegistry chosenWidgets;
  final Rect? hinge;
  final SlotLayoutRegistry slots;
  final SlotSizeRegistry slotSizes;
  final bool useInternalAnimations;
  final bool isLTR;
  final double? bodyRatio;

  static const List<SlotID> _navigations = <SlotID>[
    SlotID.topNavigation,
    SlotID.bottomNavigation,
    SlotID.primaryNavigation,
    SlotID.secondaryNavigation,
  ];

  static const List<SlotID> _bodies = <SlotID>[
    SlotID.body,
    SlotID.secondaryBody,
  ];

  /// An animation that is used as either a width or height value on the
  /// [Size] for the body/secondaryBody.
  double computeAnimatedSize(final double begin, final double end) {
    final bool isSecBodyAnimating = isAnimating.contains(SlotID.secondaryBody);

    if (isSecBodyAnimating && useInternalAnimations) {
      return Tween<double>(begin: begin, end: end)
          .animate(
            CurvedAnimation(
              parent: controller,
              curve: Curves.easeInOutCubic,
            ),
          )
          .value;
    }
    return end;
  }

  Offset getLayoutOffset({
    required final SlotID type,
    required final SizeWithMargin size,
    required final Size currentSize,
  }) {
    switch (type) {
      case SlotID.topNavigation:
        return Offset.zero;
      case SlotID.bottomNavigation:
        return Offset(0, size.height - currentSize.height);
      case SlotID.primaryNavigation:
        if (isLTR) {
          return Offset(size.margin.left, size.margin.top);
        } else {
          return Offset(size.width - currentSize.width, size.margin.top);
        }
      case SlotID.secondaryNavigation:
        if (isLTR) {
          return Offset(size.width - currentSize.width, size.margin.top);
        } else {
          return Offset(0, size.margin.top);
        }
      case SlotID.body:
      case SlotID.secondaryBody:
        throw UnimplementedError();
    }
  }

  void computeMargin({
    required final SlotID type,
    required final Size currentSize,
    required final Margin margin,
  }) {
    late final double val;
    late final MarginSide side;
    switch (type) {
      case SlotID.topNavigation:
        val = currentSize.height;
        side = MarginSide.top;
        break;
      case SlotID.bottomNavigation:
        val = currentSize.height;
        side = MarginSide.bottom;
        break;
      case SlotID.primaryNavigation:
        if (isLTR) {
          val = currentSize.width;
          side = MarginSide.left;
        } else {
          val = currentSize.width;
          side = MarginSide.right;
        }
        break;
      case SlotID.secondaryNavigation:
        if (isLTR) {
          val = currentSize.width;
          side = MarginSide.right;
        } else {
          val = currentSize.width;
          side = MarginSide.left;
        }
        break;
      case SlotID.body:
      case SlotID.secondaryBody:
        throw UnimplementedError();
    }
    margin.add(val, side);
  }

  void layoutChildBasedOnNavigationType({
    required final SlotID type,
    required final SizeWithMargin size,
  }) {
    if (hasChild(type)) {
      final Size childSize = layoutChild(type, BoxConstraints.loose(size));
      // Trigger the animation if the new size is different from the old size.
      updateSize(type, childSize);
      // Tween not the actual size, but the size that is used in the margins so
      // the offsets can be animated.
      final Size currentSize = Tween<Size>(
        begin: slotSizes[type] ?? Size.zero,
        end: childSize,
      ).animate(controller).value;

      positionChild(
        type,
        getLayoutOffset(
          type: type,
          size: size,
          currentSize: currentSize,
        ),
      );

      computeMargin(type: type, currentSize: currentSize, margin: size.margin);
    }
  }

  Size computeSizeConstraints(
    final double beginWidth,
    final double endWidth,
    final double beginHeight,
    final double endHeight, {
    required final bool isPrimaryBody,
  }) {
    double width;
    double height;

    if (isPrimaryBody && isLTR) {
      if (bodyOrientation == Axis.horizontal) {
        width = computeAnimatedSize(beginWidth, endWidth);
        height = endHeight;
      } else {
        width = endWidth;
        height = computeAnimatedSize(beginHeight, endHeight);
      }
    } else {
      width = endWidth;
      height = endHeight;
    }

    return Size(width, height);
  }

  Size? sizeWithRatio(final SizeWithMargin size, {final bool primary = true}) {
    final double? ratio = bodyRatio;
    if (ratio == null) {
      return null;
    }
    final double reverseRatio = 1 - ratio;

    final double width = size.remaining.width * ratio;

    final double heightRatio = primary ? ratio : reverseRatio;

    final double height = size.remaining.height * heightRatio;
    return Size(width, height);
  }

  Size sizeWithMargin(final SizeWithMargin size, {final bool primary = true}) {
    final double width = size.half.width - size.margin.left;
    final double height =
        size.half.height - (primary ? size.margin.top : size.margin.bottom);
    return Size(width, height);
  }

  Size layoutPrimaryBodyHorizontally(final SizeWithMargin size) {
    // Take this path if the body and secondaryBody are laid out
    // horizontally.
    final bool hasHinge = hinge != null;
    final bool hasBodyRatio = bodyRatio != null;

    final double hingeWidth = hasHinge ? hinge!.right - hinge!.left : 0;

    double width;
    double height;
    if (hasHinge) {
      width = size.width - (hinge!.left + hingeWidth) - size.margin.right;
      height = hinge!.left - size.margin.left;
    } else if (hasBodyRatio) {
      width = size.remaining.width * (1 - bodyRatio!);
      height = size.remaining.width * bodyRatio!;
    } else {
      width = size.half.width - size.margin.right;
      height = size.half.width - size.margin.left;
    }
    SlotID body = isLTR ? SlotID.body : SlotID.secondaryBody;
    final Size layout = layoutChild(
      body,
      BoxConstraints.tight(
        Size(
          computeAnimatedSize(isLTR ? size.remaining.width : 0, height),
          size.remaining.height,
        ),
      ),
    );
    body = isLTR ? SlotID.secondaryBody : SlotID.body;
    layoutChild(
      body,
      BoxConstraints.tight(
        Size(width, size.remaining.height),
      ),
    );
    return layout;
  }

  Size layoutCurrentBody(
    final SizeWithMargin size, {
    final bool primary = true,
  }) {
    final bool isSecBodyChosen = chosenWidgets[SlotID.secondaryBody] != null;
    final bool laidOutHorizontically = bodyOrientation == Axis.horizontal;

    if (isSecBodyChosen && laidOutHorizontically) {
      return layoutPrimaryBodyHorizontally(size);
    }

    final Size begin = sizeWithRatio(size, primary: primary) ??
        sizeWithMargin(size, primary: primary);

    final double endWidth = size.remaining.width;
    final double endHeight =
        isSecBodyChosen ? begin.height : size.remaining.height;

    return layoutChild(
      primary ? SlotID.body : SlotID.secondaryBody,
      BoxConstraints.tight(
        computeSizeConstraints(
          begin.width,
          endWidth,
          isSecBodyChosen ? size.remaining.height : begin.height,
          endHeight,
          isPrimaryBody: primary,
        ),
      ),
    );
  }

  void positionBodies(
    final SizeWithMargin size,
    final Size currentBodySize,
    final Size secBodySize,
  ) {
    final bool isRTL = !isLTR;
    final bool hasHinge = hinge != null;
    final bool isSecBodyChosen = chosenWidgets[SlotID.secondaryBody] != null;
    final bool laidOutHorizontically = bodyOrientation == Axis.horizontal;

    final double hingeWidth = hasHinge ? hinge!.right - hinge!.left : 0;
    final Offset topLeft = Offset(size.margin.left, size.margin.top);
    // Handle positioning for the body and secondaryBody.
    if (laidOutHorizontically) {
      if (isRTL && isSecBodyChosen) {
        positionChild(
          SlotID.body,
          Offset(topLeft.dx + secBodySize.width + hingeWidth, topLeft.dy),
        );
        positionChild(SlotID.secondaryBody, topLeft);
      } else {
        positionChild(
          SlotID.secondaryBody,
          Offset(topLeft.dx + currentBodySize.width + hingeWidth, topLeft.dy),
        );
      }
    } else {
      positionChild(
        SlotID.secondaryBody,
        Offset(topLeft.dx, topLeft.dy + currentBodySize.height),
      );
    }
    if (!laidOutHorizontically || isLTR || !isSecBodyChosen) {
      positionChild(SlotID.body, topLeft);
    }
  }

  void layoutChildBasedOnBodyType(final SizeWithMargin size) {
    final bool isSecBodyChosen = chosenWidgets[SlotID.secondaryBody] != null;
    final bool laidOutHorizontically = bodyOrientation == Axis.horizontal;

    if (_bodies.every(hasChild)) {
      Size currentBodySize = Size.zero;
      Size secBodySize = Size.zero;

      if (!isSecBodyChosen) {
        currentBodySize = layoutCurrentBody(size);
        layoutChild(SlotID.secondaryBody, BoxConstraints.loose(size));
      } else if (laidOutHorizontically) {
        final Size layout = layoutCurrentBody(size);
        currentBodySize = isLTR ? layout : Size.zero;
        secBodySize = isLTR ? Size.zero : layout;
      } else {
        // Take this path if the body and secondaryBody are laid out
        // vertically.
        currentBodySize = layoutCurrentBody(size);
        layoutCurrentBody(size, primary: false);
      }

      positionBodies(size, currentBodySize, secBodySize);
    } else {
      final SlotID type = _bodies.singleWhere(hasChild);
      layoutChild(type, BoxConstraints.tight(size.remaining));
      if (type == SlotID.body) {
        positionChild(type, Offset(size.margin.left, size.margin.top));
      }
    }
  }

  void updateSize(final SlotID id, final Size childSize) {
    final bool hasChildSize = slotSizes[id] == childSize;
    if (!hasChildSize) {
      void listener(final AnimationStatus status) {
        if (status.idle) {
          slotSizes[id] = childSize;
        }
        controller.removeStatusListener(listener);
      }

      controller.addStatusListener(listener);
    }
  }

  @override
  void performLayout(final Size size) {
    final SizeWithMargin sizeWithMargin = SizeWithMargin(size);

    for (final SlotID navigationType in _navigations) {
      layoutChildBasedOnNavigationType(
        type: navigationType,
        size: sizeWithMargin,
      );
    }

    layoutChildBasedOnBodyType(sizeWithMargin);
  }

  @override
  bool shouldRelayout(final AdaptiveLayoutDelegate oldDelegate) =>
      oldDelegate.slots != slots;
}

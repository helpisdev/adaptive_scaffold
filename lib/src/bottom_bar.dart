// Copyright 2020 Luke Pighetti
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:utilities/typography.dart';

import 'adaptive_scaffold/scaffold_config.dart';

/// Opinionated design of bottom bar.
class SalomonBottomBar extends StatelessWidget {
  /// A bottom bar that faithfully follows the design by Aurélien Salomon
  ///
  /// https://dribbble.com/shots/5925052-Google-Bottom-Bar-Navigation-Pattern/
  const SalomonBottomBar({
    required this.items,
    this.onTap,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedColorOpacity,
    this.backgroundColor,
    this.currentIndex = 0,
    this.itemShape = const StadiumBorder(),
    this.margin = const EdgeInsets.all(8),
    this.itemPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOutQuint,
    this.iconSize = 24,
    super.key,
  });

  /// A list of tabs to display, ie `Home`, `Likes`, etc
  final List<SalomonBottomBarItem> items;

  /// The tab to display.
  final int currentIndex;

  /// Returns the index of the tab that was tapped.
  final OnIndexChangedCallback? onTap;

  /// The background color of the bar.
  final Color? backgroundColor;

  /// The color of the icon and text when the item is selected.
  final Color? selectedItemColor;

  /// The color of the icon and text when the item is not selected.
  final Color? unselectedItemColor;

  /// The opacity of color of the touchable background when the item is
  /// selected.
  final double? selectedColorOpacity;

  /// The icon size. Defaults to 24.
  final double iconSize;

  /// The border shape of each item.
  final ShapeBorder itemShape;

  /// A convenience field for the margin surrounding the entire widget.
  final EdgeInsets margin;

  /// The padding of each item.
  final EdgeInsets itemPadding;

  /// The transition duration
  final Duration duration;

  /// The transition curve
  final Curve curve;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      minimum: margin,
      child: Row(
        /// Using a different alignment when there are 2 items or less
        /// so it behaves the same as BottomNavigationBar.
        mainAxisAlignment: items.length <= 2
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.spaceBetween,
        children: <Widget>[
          for (final SalomonBottomBarItem item in items)
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                end: items.indexOf(item) == currentIndex ? 1.0 : 0.0,
              ),
              curve: curve,
              duration: duration,
              builder: (
                final BuildContext context,
                final double tweenVal,
                final Widget? child,
              ) {
                final Color selectedColor = item.selectedColor ??
                    selectedItemColor ??
                    theme.primaryColor;

                final Color? unselectedColor = item.unselectedColor ??
                    unselectedItemColor ??
                    theme.iconTheme.color;

                final bool ltr =
                    Directionality.of(context) == TextDirection.ltr;

                return Material(
                  color: Color.lerp(
                    selectedColor.withOpacity(0),
                    selectedColor.withOpacity(selectedColorOpacity ?? 0.1),
                    tweenVal,
                  ),
                  shape: itemShape,
                  child: InkWell(
                    onTap: () => onTap?.call(items.indexOf(item)),
                    customBorder: itemShape,
                    focusColor: selectedColor.withOpacity(0.1),
                    highlightColor: selectedColor.withOpacity(0.1),
                    splashColor: selectedColor.withOpacity(0.1),
                    hoverColor: selectedColor.withOpacity(0.1),
                    child: Padding(
                      padding: itemPadding -
                          EdgeInsets.only(
                            right: ltr ? itemPadding.right * tweenVal : 0,
                            left: ltr ? 0 : itemPadding.left * tweenVal,
                          ),
                      child: Row(
                        children: <Widget>[
                          IconTheme(
                            data: IconThemeData(
                              color: Color.lerp(
                                unselectedColor,
                                selectedColor,
                                tweenVal,
                              ),
                              size: iconSize,
                            ),
                            child: items.indexOf(item) == currentIndex
                                ? item.activeIcon ?? item.icon
                                : item.icon,
                          ),
                          ClipRect(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topCenter,
                                  widthFactor: tweenVal,
                                  child: Padding(
                                    padding: Directionality.of(context) ==
                                            TextDirection.ltr
                                        ? EdgeInsets.only(
                                            left: itemPadding.left / 2,
                                            right: itemPadding.right,
                                          )
                                        : EdgeInsets.only(
                                            left: itemPadding.left,
                                            right: itemPadding.right / 2,
                                          ),
                                    child: LabelNormal(
                                      item.title,
                                      maxLines: 2,
                                      style: ResizableTextStyle(
                                        color: Color.lerp(
                                          selectedColor.withOpacity(0),
                                          selectedColor,
                                          tweenVal,
                                        ),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<SalomonBottomBarItem>('items', items))
      ..add(IntProperty('currentIndex', currentIndex))
      ..add(ObjectFlagProperty<Function(int p1)?>.has('onTap', onTap))
      ..add(ColorProperty('selectedItemColor', selectedItemColor))
      ..add(ColorProperty('unselectedItemColor', unselectedItemColor))
      ..add(DoubleProperty('selectedColorOpacity', selectedColorOpacity))
      ..add(DiagnosticsProperty<ShapeBorder>('itemShape', itemShape))
      ..add(DiagnosticsProperty<EdgeInsets>('margin', margin))
      ..add(DiagnosticsProperty<EdgeInsets>('itemPadding', itemPadding))
      ..add(DiagnosticsProperty<Duration>('duration', duration))
      ..add(DiagnosticsProperty<Curve>('curve', curve))
      ..add(DoubleProperty('iconSize', iconSize))
      ..add(ColorProperty('backgroundColor', backgroundColor));
  }
}

/// A tab to display in a [SalomonBottomBar]
class SalomonBottomBarItem {
  /// Constructs a bottom bar item with an [icon] and [title].
  const SalomonBottomBarItem({
    required this.icon,
    required this.title,
    this.selectedColor,
    this.unselectedColor,
    this.activeIcon,
  });

  /// An icon to display.
  final Widget icon;

  /// An icon to display when this tab bar is active.
  final Widget? activeIcon;

  /// Text to display, ie `Home`
  final String title;

  /// A primary color to use for this tab.
  final Color? selectedColor;

  /// The color to display when this tab is not selected.
  final Color? unselectedColor;
}

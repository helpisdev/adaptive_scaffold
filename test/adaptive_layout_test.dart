// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:adaptive_scaffold/adaptive_scaffold.dart';
import 'package:breakpoints_utilities/breakpoints_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_breakpoints.dart';

void main() {
  testWidgets(
    'slot layout displays correct item of config based on screen width',
    (final WidgetTester tester) async {
      MediaQuery slot(final double width) => MediaQuery(
            data: MediaQueryData.fromView(
              // ignore: deprecated_member_use
              WidgetsBinding.instance.window,
            ).copyWith(size: Size(width, 800)),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: SlotLayout(
                config: <Breakpoint, SlotLayoutConfig>{
                  testBreakpoint0: SlotLayoutConfig.from(
                    key: const SlotKey('0'),
                    builder: (final _) => const SizedBox(),
                  ),
                  testBreakpoint401: SlotLayoutConfig.from(
                    key: const SlotKey('400'),
                    builder: (final _) => const SizedBox(),
                  ),
                  testBreakpoint801: SlotLayoutConfig.from(
                    key: const SlotKey('800'),
                    builder: (final _) => const SizedBox(),
                  ),
                },
              ),
            ),
          );

      await tester.pumpWidget(slot(300));
      expect(find.byKey(const SlotKey('0')), findsOneWidget);
      expect(find.byKey(const SlotKey('400')), findsNothing);
      expect(find.byKey(const SlotKey('800')), findsNothing);

      await tester.pumpWidget(slot(500));
      expect(find.byKey(const SlotKey('0')), findsNothing);
      expect(find.byKey(const SlotKey('400')), findsOneWidget);
      expect(find.byKey(const SlotKey('800')), findsNothing);

      await tester.pumpWidget(slot(1000));
      expect(find.byKey(const SlotKey('0')), findsNothing);
      expect(find.byKey(const SlotKey('400')), findsNothing);
      expect(find.byKey(const SlotKey('800')), findsOneWidget);
    },
  );

  testWidgets(
    'adaptive layout displays children in correct places',
    (final WidgetTester tester) async {
      await tester.pumpWidget(await layout(width: 400, tester: tester));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(topNavigation), Offset.zero);
      expect(tester.getTopLeft(secondaryNavigation), const Offset(390, 10));
      expect(tester.getTopLeft(primaryNavigation), const Offset(0, 10));
      expect(tester.getTopLeft(bottomNavigation), const Offset(0, 790));
      expect(tester.getTopLeft(testBreakpoint), const Offset(10, 10));
      expect(tester.getBottomRight(testBreakpoint), const Offset(200, 790));
      expect(tester.getTopLeft(secondaryTestBreakpoint), const Offset(200, 10));
      expect(
        tester.getBottomRight(secondaryTestBreakpoint),
        const Offset(390, 790),
      );
    },
  );

  testWidgets(
    'adaptive layout correct layout when body vertical',
    (final WidgetTester tester) async {
      await tester.pumpWidget(
        await layout(width: 400, tester: tester, orientation: Axis.vertical),
      );
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(topNavigation), Offset.zero);
      expect(tester.getTopLeft(secondaryNavigation), const Offset(390, 10));
      expect(tester.getTopLeft(primaryNavigation), const Offset(0, 10));
      expect(tester.getTopLeft(bottomNavigation), const Offset(0, 790));
      expect(tester.getTopLeft(testBreakpoint), const Offset(10, 10));
      expect(tester.getBottomRight(testBreakpoint), const Offset(390, 400));
      expect(tester.getTopLeft(secondaryTestBreakpoint), const Offset(10, 400));
      expect(
        tester.getBottomRight(secondaryTestBreakpoint),
        const Offset(390, 790),
      );
    },
  );

  testWidgets(
    'adaptive layout correct layout when rtl',
    (final WidgetTester tester) async {
      await tester.pumpWidget(
        await layout(
          width: 400,
          tester: tester,
          directionality: TextDirection.rtl,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(topNavigation), Offset.zero);
      expect(tester.getTopLeft(secondaryNavigation), const Offset(0, 10));
      expect(tester.getTopLeft(primaryNavigation), const Offset(390, 10));
      expect(tester.getTopLeft(bottomNavigation), const Offset(0, 790));
      expect(tester.getTopLeft(testBreakpoint), const Offset(200, 10));
      expect(tester.getBottomRight(testBreakpoint), const Offset(390, 790));
      expect(tester.getTopLeft(secondaryTestBreakpoint), const Offset(10, 10));
      expect(
        tester.getBottomRight(secondaryTestBreakpoint),
        const Offset(200, 790),
      );
    },
  );

  testWidgets(
    'adaptive layout correct layout when body ratio not default',
    (final WidgetTester tester) async {
      await tester.pumpWidget(
        await layout(width: 400, tester: tester, bodyRatio: 1 / 3),
      );
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(topNavigation), Offset.zero);
      expect(tester.getTopLeft(secondaryNavigation), const Offset(390, 10));
      expect(tester.getTopLeft(primaryNavigation), const Offset(0, 10));
      expect(tester.getTopLeft(bottomNavigation), const Offset(0, 790));
      expect(tester.getTopLeft(testBreakpoint), const Offset(10, 10));
      expect(
        tester.getBottomRight(testBreakpoint),
        offsetMoreOrLessEquals(const Offset(136.7, 790), epsilon: 1.0),
      );
      expect(
        tester.getTopLeft(secondaryTestBreakpoint),
        offsetMoreOrLessEquals(const Offset(136.7, 10), epsilon: 1.0),
      );
      expect(
        tester.getBottomRight(secondaryTestBreakpoint),
        const Offset(390, 790),
      );
    },
  );

  final Finder begin = find.byKey(const SlotKey('0'));
  final Finder end = find.byKey(const SlotKey('400'));
  Finder slideIn(final String key) => find.byKey(SlotKey('in-${SlotKey(key)}'));
  Finder slideOut(final String key) => find.byKey(
        SlotKey('out-${SlotKey(key)}'),
      );
  testWidgets(
    'slot layout properly switches between items '
    'with the appropriate animation',
    (final WidgetTester tester) async {
      await tester.pumpWidget(slot(300));
      expect(begin, findsOneWidget);
      expect(end, findsNothing);

      await tester.pumpWidget(slot(500));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(
        tester.widget<SlideTransition>(slideOut('0')).position.value,
        const Offset(-0.5, 0),
      );
      expect(
        tester.widget<SlideTransition>(slideIn('400')).position.value,
        const Offset(-0.5, 0),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(
        tester.widget<SlideTransition>(slideOut('0')).position.value,
        const Offset(-1.0, 0),
      );
      expect(
        tester.widget<SlideTransition>(slideIn('400')).position.value,
        Offset.zero,
      );

      await tester.pumpAndSettle();
      expect(begin, findsNothing);
      expect(end, findsOneWidget);
    },
  );

  testWidgets(
    'AnimatedSwitcher does not spawn duplicate keys on rapid resize',
    (final WidgetTester tester) async {
      // Populate the smaller slot layout and let the animation settle.
      await tester.pumpWidget(slot(300));
      await tester.pumpAndSettle();
      expect(begin, findsOneWidget);
      expect(end, findsNothing);

      // Jumping back between two layouts before allowing an animation to complete.
      // Produces a chain of widgets in AnimatedSwitcher that includes duplicate
      // widgets with the same global key.
      for (int i = 0; i < 2; i++) {
        // Resize between the two slot layouts, but do not pump the animation
        // until completion.
        await tester.pumpWidget(slot(500));
        await tester.pump(const Duration(milliseconds: 100));
        expect(begin, findsOneWidget);
        expect(end, findsOneWidget);

        await tester.pumpWidget(slot(300));
        await tester.pump(const Duration(milliseconds: 100));
        expect(begin, findsOneWidget);
        expect(end, findsOneWidget);
      }
      // TODO(gspencergoog): Remove skip when AnimatedSwitcher fix rolls into stable.
      // https://github.com/flutter/flutter/pull/107476
    },
    skip: true,
  );

  testWidgets(
    'slot layout can tolerate rapid changes in breakpoints',
    (final WidgetTester tester) async {
      await tester.pumpWidget(slot(300));
      expect(begin, findsOneWidget);
      expect(end, findsNothing);

      await tester.pumpWidget(slot(500));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        tester.widget<SlideTransition>(slideOut('0')).position.value,
        offsetMoreOrLessEquals(const Offset(-0.1, 0), epsilon: 0.05),
      );
      expect(
        tester.widget<SlideTransition>(slideIn('400')).position.value,
        offsetMoreOrLessEquals(const Offset(-0.9, 0), epsilon: 0.05),
      );
      await tester.pumpWidget(slot(300));
      await tester.pumpAndSettle();
      expect(begin, findsOneWidget);
      expect(end, findsNothing);
      // TODO(a-wallen): Remove skip when AnimatedSwitcher fix rolls into stable.
      // https://github.com/flutter/flutter/pull/107476
    },
    skip: true,
  );

  // This test reflects the behavior of the internal animations of both the body
  // and secondary body and also the navigational items. This is reflected in
  // the changes in LTRB offsets from all sides instead of just LR for the body
  // animations.
  testWidgets(
    'adaptive layout handles internal animations correctly',
    (final WidgetTester tester) async {
      final Finder testBreakpoint =
          find.byKey(const SlotKey('Test Breakpoint'));
      final Finder secondaryTestBreakpoint = find.byKey(
        const SlotKey('Secondary Test Breakpoint'),
      );

      await tester.pumpWidget(await layout(width: 400, tester: tester));

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.getTopLeft(testBreakpoint), const Offset(1, 1));
      expect(
        tester.getBottomRight(testBreakpoint),
        offsetMoreOrLessEquals(const Offset(395.8, 799), epsilon: 1.0),
      );
      expect(
        tester.getTopLeft(secondaryTestBreakpoint),
        offsetMoreOrLessEquals(const Offset(395.8, 1.0), epsilon: 1.0),
      );
      expect(
        tester.getBottomRight(secondaryTestBreakpoint),
        offsetMoreOrLessEquals(const Offset(594.8, 799.0), epsilon: 1.0),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(tester.getTopLeft(testBreakpoint), const Offset(5, 5));
      expect(
        tester.getBottomRight(testBreakpoint),
        offsetMoreOrLessEquals(const Offset(294.2, 795), epsilon: 1.0),
      );
      expect(
        tester.getTopLeft(secondaryTestBreakpoint),
        offsetMoreOrLessEquals(const Offset(294.2, 5.0), epsilon: 1.0),
      );
      expect(
        tester.getBottomRight(secondaryTestBreakpoint),
        offsetMoreOrLessEquals(const Offset(489.2, 795.0), epsilon: 1.0),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(tester.getTopLeft(testBreakpoint), const Offset(9, 9));
      expect(
        tester.getBottomRight(testBreakpoint),
        offsetMoreOrLessEquals(const Offset(201.7, 791), epsilon: 1.0),
      );
      expect(
        tester.getTopLeft(secondaryTestBreakpoint),
        offsetMoreOrLessEquals(const Offset(201.7, 9.0), epsilon: 1.0),
      );
      expect(
        tester.getBottomRight(secondaryTestBreakpoint),
        offsetMoreOrLessEquals(const Offset(392.7, 791), epsilon: 1.0),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.getTopLeft(testBreakpoint), const Offset(10, 10));
      expect(tester.getBottomRight(testBreakpoint), const Offset(200, 790));
      expect(tester.getTopLeft(secondaryTestBreakpoint), const Offset(200, 10));
      expect(
        tester.getBottomRight(secondaryTestBreakpoint),
        const Offset(390, 790),
      );
      // TODO(a-wallen): Remove skip when AnimatedSwitcher fix rolls into stable.
      // https://github.com/flutter/flutter/pull/107476
    },
    skip: true,
  );

  testWidgets(
    'adaptive layout does not animate when animations off',
    (final WidgetTester tester) async {
      final Finder testBreakpoint = find.byKey(
        const SlotKey('Test Breakpoint'),
      );
      final Finder secondaryTestBreakpoint = find.byKey(
        const SlotKey('Secondary Test Breakpoint'),
      );

      await tester.pumpWidget(
        await layout(width: 400, tester: tester, animations: false),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.getTopLeft(testBreakpoint), const Offset(10, 10));
      expect(tester.getBottomRight(testBreakpoint), const Offset(200, 790));
      expect(tester.getTopLeft(secondaryTestBreakpoint), const Offset(200, 10));
      expect(
        tester.getBottomRight(secondaryTestBreakpoint),
        const Offset(390, 790),
      );
      // TODO(a-wallen): Remove skip when AnimatedSwitcher fix rolls into stable.
      // https://github.com/flutter/flutter/pull/107476
    },
    skip: true,
  );
}

final Finder topNavigation = find.byKey(const SlotKey('Top Navigation'));
final Finder secondaryNavigation = find.byKey(
  const SlotKey('Secondary Navigation Small'),
);
final Finder primaryNavigation = find.byKey(
  const SlotKey('Primary Navigation Small'),
);
final Finder bottomNavigation = find.byKey(
  const SlotKey('Bottom Navigation Small'),
);
final Finder testBreakpoint = find.byKey(const SlotKey('Test Breakpoint'));
final Finder secondaryTestBreakpoint = find.byKey(
  const SlotKey('Secondary Test Breakpoint'),
);

Widget on(final BuildContext _) => const SizedBox(width: 10, height: 10);

Future<MediaQuery> layout({
  required final double width,
  required final WidgetTester tester,
  final Axis orientation = Axis.horizontal,
  final TextDirection directionality = TextDirection.ltr,
  final double? bodyRatio,
  final bool animations = true,
}) async {
  await tester.binding.setSurfaceSize(Size(width, 800));
  return MediaQuery(
    data: MediaQueryData(size: Size(width, 800)),
    child: Directionality(
      textDirection: directionality,
      child: AdaptiveLayout(
        bodyOrientation: orientation,
        bodyRatio: bodyRatio,
        useInternalAnimations: animations,
        primaryNavigation: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            testBreakpoint0: SlotLayoutConfig.from(
              key: const SlotKey('Primary Navigation Small'),
              builder: on,
            ),
            testBreakpoint401: SlotLayoutConfig.from(
              key: const SlotKey('Primary Navigation Medium'),
              builder: on,
            ),
            testBreakpoint801: SlotLayoutConfig.from(
              key: const SlotKey('Primary Navigation Large'),
              builder: on,
            ),
          },
        ),
        secondaryNavigation: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            testBreakpoint0: SlotLayoutConfig.from(
              key: const SlotKey('Secondary Navigation Small'),
              builder: on,
            ),
            testBreakpoint401: SlotLayoutConfig.from(
              key: const SlotKey('Secondary Navigation Medium'),
              builder: on,
            ),
            testBreakpoint801: SlotLayoutConfig.from(
              key: const SlotKey('Secondary Navigation Large'),
              builder: on,
            ),
          },
        ),
        topNavigation: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            testBreakpoint0: SlotLayoutConfig.from(
              key: const SlotKey('Top Navigation'),
              builder: on,
            ),
            testBreakpoint401: SlotLayoutConfig.from(
              key: const SlotKey('Top Navigation1'),
              builder: on,
            ),
            testBreakpoint801: SlotLayoutConfig.from(
              key: const SlotKey('Top Navigation2'),
              builder: on,
            ),
          },
        ),
        bottomNavigation: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            testBreakpoint0: SlotLayoutConfig.from(
              key: const SlotKey('Bottom Navigation Small'),
              builder: on,
            ),
            testBreakpoint401: SlotLayoutConfig.from(
              key: const SlotKey('bnav1'),
              builder: on,
            ),
            testBreakpoint801: SlotLayoutConfig.from(
              key: const SlotKey('bnav2'),
              builder: on,
            ),
          },
        ),
        body: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            testBreakpoint0: SlotLayoutConfig.from(
              key: const SlotKey('Test Breakpoint'),
              builder: (final _) => Container(color: Colors.red),
            ),
            testBreakpoint401: SlotLayoutConfig.from(
              key: const SlotKey('Test Breakpoint 1'),
              builder: (final _) => Container(color: Colors.red),
            ),
            testBreakpoint801: SlotLayoutConfig.from(
              key: const SlotKey('Test Breakpoint 2'),
              builder: (final _) => Container(color: Colors.red),
            ),
          },
        ),
        secondaryBody: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            testBreakpoint0: SlotLayoutConfig.from(
              key: const SlotKey('Secondary Test Breakpoint'),
              builder: (final _) => Container(color: Colors.blue),
            ),
            testBreakpoint401: SlotLayoutConfig.from(
              key: const SlotKey('Secondary Test Breakpoint 1'),
              builder: (final _) => Container(color: Colors.blue),
            ),
            testBreakpoint801: SlotLayoutConfig.from(
              key: const SlotKey('Secondary Test Breakpoint 2'),
              builder: (final _) => Container(color: Colors.blue),
            ),
          },
        ),
      ),
    ),
  );
}

AnimatedWidget leftOutIn(
  final Widget child,
  final Animation<double> animation,
) =>
    SlideTransition(
      key: SlotKey('in-${child.key}'),
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );

AnimatedWidget leftInOut(
  final Widget child,
  final Animation<double> animation,
) =>
    SlideTransition(
      key: SlotKey('out-${child.key}'),
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1, 0),
      ).animate(animation),
      child: child,
    );

MediaQuery slot(final double width) => MediaQuery(
      // ignore: deprecated_member_use
      data: MediaQueryData.fromView(WidgetsBinding.instance.window).copyWith(
        size: Size(width, 800),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            testBreakpoint0: SlotLayoutConfig.from(
              inAnimation: leftOutIn,
              outAnimation: leftInOut,
              key: const SlotKey('0'),
              builder: (final _) => const SizedBox(width: 10, height: 10),
            ),
            testBreakpoint401: SlotLayoutConfig.from(
              inAnimation: leftOutIn,
              outAnimation: leftInOut,
              key: const SlotKey('400'),
              builder: (final _) => const SizedBox(width: 10, height: 10),
            ),
          },
        ),
      ),
    );

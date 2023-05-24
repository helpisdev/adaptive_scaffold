// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:adaptive_scaffold/src/adaptive_layout/slot_layout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'simulated_layout.dart';

void main() {
  testWidgets(
    'Desktop breakpoints do not show on mobile device',
    (final WidgetTester tester) async {
      // Pump a small layout on a mobile device. The small slot
      // should give the mobile slot layout, not the desktop layout.
      await tester.pumpWidget(SimulatedLayout.medium.slot);
      await tester.pumpAndSettle();
      expect(
        find.byKey(const SlotKey('mediumMobile')),
        findsOneWidget,
      );
      expect(
        find.byKey(const SlotKey('mediumDesktop')),
        findsNothing,
      );

      // Do the same with a medium layout on a mobile
      await tester.pumpWidget(SimulatedLayout.medium.slot);
      await tester.pumpAndSettle();
      expect(
        find.byKey(const SlotKey('mediumMobile')),
        findsOneWidget,
      );
      expect(
        find.byKey(const SlotKey('mediumDesktop')),
        findsNothing,
      );

      // Large layout on mobile
      await tester.pumpWidget(SimulatedLayout.large.slot);
      await tester.pumpAndSettle();
      expect(
        find.byKey(const SlotKey('largeMobile')),
        findsOneWidget,
      );
      expect(
        find.byKey(const SlotKey('largeDesktop')),
        findsNothing,
      );
    },
    variant: TargetPlatformVariant.mobile(),
  );

  testWidgets(
    'Mobile breakpoints do not show on desktop device',
    (final WidgetTester tester) async {
      // Pump a small layout on a desktop device. The small slot
      // should give the mobile slot layout, not the desktop layout.
      await tester.pumpWidget(SimulatedLayout.medium.slot);
      await tester.pumpAndSettle();
      expect(
        find.byKey(const SlotKey('mediumDesktop')),
        findsOneWidget,
      );
      expect(
        find.byKey(const SlotKey('mediumMobile')),
        findsNothing,
      );

      // Do the same with a medium layout on a desktop
      await tester.pumpWidget(SimulatedLayout.medium.slot);
      await tester.pumpAndSettle();
      expect(
        find.byKey(const SlotKey('mediumDesktop')),
        findsOneWidget,
      );
      expect(
        find.byKey(const SlotKey('mediumMobile')),
        findsNothing,
      );

      // Large layout on desktop
      await tester.pumpWidget(SimulatedLayout.large.slot);
      await tester.pumpAndSettle();
      expect(
        find.byKey(const SlotKey('largeDesktop')),
        findsOneWidget,
      );
      expect(
        find.byKey(const SlotKey('largeMobile')),
        findsNothing,
      );
    },
    variant: TargetPlatformVariant.desktop(),
  );
}

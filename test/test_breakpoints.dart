// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:adaptive_scaffold/src/breakpoints/breakpoint.dart';

const Breakpoint testBreakpoint0 = BreakpointGenerator.generate(
  begin: 0,
);

const Breakpoint testBreakpoint401 = BreakpointGenerator.generate(
  begin: 401,
);

const Breakpoint testBreakpoint801 = BreakpointGenerator.generate(
  begin: 801,
);

const Breakpoint testBreakpoint0_800 = BreakpointGenerator.generate(
  begin: 0,
  end: 800,
);

const Breakpoint testBreakpoint400 = BreakpointGenerator.generate(
  begin: 400,
);

const Breakpoint testBreakpoint800_1000 = BreakpointGenerator.generate(
  begin: 800,
  end: 1000,
);

const Breakpoint testBreakpoint1000 = BreakpointGenerator.generate(
  begin: 1000,
);

const PredefinedBreakpoint neverOnBreakpoint = PredefinedBreakpoint.none;

const Breakpoint testBreakpoint400_800 = BreakpointGenerator.generate(
  begin: 400,
  end: 800,
);

const Breakpoint testBreakpoint800_1100 = BreakpointGenerator.generate(
  begin: 800,
  end: 1100,
);

const Breakpoint testBreakpoint1100 = BreakpointGenerator.generate(
  begin: 1100,
);

const Breakpoint testBreakpoint0_600 = BreakpointGenerator.generate(
  begin: 0,
  end: 600,
);

const Breakpoint testBreakpoint0_600Mobile = BreakpointGenerator.generate(
  begin: 0,
  end: 600,
  type: DeviceType.mobile,
);

const Breakpoint testBreakpoint0_600Desktop = BreakpointGenerator.generate(
  begin: 0,
  end: 600,
  type: DeviceType.desktop,
);

const Breakpoint testBreakpoint600_840 = BreakpointGenerator.generate(
  begin: 600,
  end: 840,
);

const Breakpoint testBreakpoint600_840Mobile = BreakpointGenerator.generate(
  begin: 600,
  end: 840,
  type: DeviceType.mobile,
);

const Breakpoint testBreakpoint600_840Desktop = BreakpointGenerator.generate(
  begin: 600,
  end: 840,
  type: DeviceType.desktop,
);

const Breakpoint testBreakpoint840 = BreakpointGenerator.generate(
  begin: 840,
);

const Breakpoint testBreakpoint840Mobile = BreakpointGenerator.generate(
  begin: 840,
  type: DeviceType.mobile,
);

const Breakpoint testBreakpoint840Desktop = BreakpointGenerator.generate(
  begin: 840,
  type: DeviceType.desktop,
);

import 'package:flutter/foundation.dart';

/// Counts actual builder calls. Disabled in release builds.
class BuildProbe {
  static final counts = <String, int>{};
  static void reset() => counts.clear();
  static void hit(String widget) {
    assert(() {
      counts.update(widget, (n) => n + 1, ifAbsent: () => 1);
      debugPrint('build: $widget');
      return true;
    }());
  }
}

import 'package:flutter_native_splash/flutter_native_splash.dart';

/// Keeps the native launch screen visible until [remove] is called.
abstract final class NativeSplash {
  static DateTime? _shownAt;
  static bool _removed = false;

  /// Short minimum so the branded screen does not flash; not a forced 3s wait.
  static const Duration minDisplay = Duration(milliseconds: 800);

  /// Safety cap if home data never resolves.
  static const Duration maxDisplay = Duration(seconds: 4);

  static void preserve() {
    _shownAt = DateTime.now();
    Future<void>.delayed(maxDisplay, remove);
  }

  static Future<void> remove() async {
    if (_removed) return;
    _removed = true;
    final DateTime shown = _shownAt ?? DateTime.now();
    final Duration elapsed = DateTime.now().difference(shown);
    if (elapsed < minDisplay) {
      await Future<void>.delayed(minDisplay - elapsed);
    }
    FlutterNativeSplash.remove();
  }
}

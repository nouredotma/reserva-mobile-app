import 'package:flutter_native_splash/flutter_native_splash.dart';

/// Removes the white native launch screen as soon as Flutter paints the custom preloader.
abstract final class NativeSplash {
  static bool _removed = false;

  static void remove() {
    if (_removed) return;
    _removed = true;
    FlutterNativeSplash.remove();
  }
}

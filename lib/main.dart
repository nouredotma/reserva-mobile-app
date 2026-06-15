import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/app/app.dart';
import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    UncontrolledProviderScope(
      container: ProviderContainer(
        overrides: <Override>[
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      ),
      child: const ReservaMobileApp(),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/app/app.dart';
import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:reservamobile/core/providers/reserva_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final ProviderContainer container = ProviderContainer(
    overrides: <Override>[
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );

  // Preload home tab data while the white native splash / branded preloader is visible.
  await Future.wait(<Future<Object?>>[
    container.read(categoriesProvider.future),
    container.read(citiesProvider.future),
    container.read(featuredEstablishmentsProvider.future),
  ]);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ReservaMobileApp(),
    ),
  );
}

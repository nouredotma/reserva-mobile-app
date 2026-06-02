import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/app/theme/app_theme.dart';
import 'package:reservamobile/core/bootstrap/native_splash.dart';
import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:reservamobile/core/providers/home_bootstrap_provider.dart';

class ReservaMobileApp extends ConsumerStatefulWidget {
  const ReservaMobileApp({super.key});

  @override
  ConsumerState<ReservaMobileApp> createState() => _ReservaMobileAppState();
}

class _ReservaMobileAppState extends ConsumerState<ReservaMobileApp> {
  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(homeDataReadyProvider, (_, bool ready) {
      if (ready) {
        NativeSplash.remove();
      }
    });

    final language = ref.watch(languageProvider);
    return MaterialApp.router(
      title: 'Reserva',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: Locale(language.code),
      routerConfig: appRouter,
    );
  }
}

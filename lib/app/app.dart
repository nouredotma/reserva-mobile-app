import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/app/theme/app_theme.dart';
import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:reservamobile/core/i18n/localized_value.dart';
import 'package:reservamobile/features/splash/presentation/splash_preloader.dart';

class ReservaMobileApp extends ConsumerStatefulWidget {
  const ReservaMobileApp({super.key});

  @override
  ConsumerState<ReservaMobileApp> createState() => _ReservaMobileAppState();
}

class _ReservaMobileAppState extends ConsumerState<ReservaMobileApp> {
  bool _showPreloader = true;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    return MaterialApp.router(
      title: 'Reserva',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: Locale(language.code),
      routerConfig: appRouter,
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: language.textDirection,
          child: Stack(
            children: <Widget>[
              ?child,
              if (_showPreloader)
                Positioned.fill(
                  child: SplashPreloader(
                    onComplete: () => setState(() => _showPreloader = false),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/app/theme/app_theme.dart';
import 'package:reservamobile/core/i18n/app_language.dart';

class ReservaMobileApp extends ConsumerWidget {
  const ReservaMobileApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

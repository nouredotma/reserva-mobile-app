import 'package:flutter/material.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/app/theme/app_theme.dart';

class ReservaMobileApp extends StatelessWidget {
  const ReservaMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Reserva',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
    );
  }
}

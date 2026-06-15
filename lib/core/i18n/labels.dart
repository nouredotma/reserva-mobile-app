import 'package:flutter/material.dart';
import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:reservamobile/core/i18n/localized_value.dart';
import 'package:reservamobile/core/models/app_models.dart';

/// Short label for each category, used on chips/cards.
String categoryLabel(EstablishmentCategory category, AppLanguage language) {
  switch (category) {
    case EstablishmentCategory.restaurants:
      return localizedPick(
        language,
        en: 'Restaurants',
        fr: 'Restaurants',
        es: 'Restaurantes',
        ar: 'مطاعم',
      );
    case EstablishmentCategory.wellness:
      return localizedPick(
        language,
        en: 'Wellness',
        fr: 'Bien-être',
        es: 'Bienestar',
        ar: 'العافية',
      );
    case EstablishmentCategory.dayPasses:
      return localizedPick(
        language,
        en: 'Day pass',
        fr: 'Pass journée',
        es: 'Pase de día',
        ar: 'تذكرة يومية',
      );
    case EstablishmentCategory.spectacles:
      return localizedPick(
        language,
        en: 'Spectacles',
        fr: 'Spectacles',
        es: 'Espectáculos',
        ar: 'عروض',
      );
    case EstablishmentCategory.services:
      return localizedPick(
        language,
        en: 'Services',
        fr: 'Services',
        es: 'Servicios',
        ar: 'خدمات',
      );
    case EstablishmentCategory.conciergerie:
      return localizedPick(
        language,
        en: 'Concierge',
        fr: 'Conciergerie',
        es: 'Conserjería',
        ar: 'كونسيرج',
      );
    case EstablishmentCategory.voyage:
      return localizedPick(
        language,
        en: 'Travel',
        fr: 'Voyage',
        es: 'Viajes',
        ar: 'سفر',
      );
    case EstablishmentCategory.corporate:
      return localizedPick(
        language,
        en: 'Corporate',
        fr: 'Entreprises',
        es: 'Empresas',
        ar: 'شركات',
      );
  }
}

/// Turns a snake_case token like `valet_parking` into `Valet Parking`.
String prettyToken(String token) {
  return token
      .split(RegExp(r'[_\s]+'))
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');
}

const List<String> _dayOrder = <String>[
  'mon',
  'tue',
  'wed',
  'thu',
  'fri',
  'sat',
  'sun',
];

List<String> orderedDays(Iterable<String> keys) {
  final List<String> present = keys.toList();
  return _dayOrder.where(present.contains).toList();
}

String dayName(String key, AppLanguage language) {
  const Map<String, List<String>> names = <String, List<String>>{
    'mon': <String>['Monday', 'Lundi', 'Lunes', 'الاثنين'],
    'tue': <String>['Tuesday', 'Mardi', 'Martes', 'الثلاثاء'],
    'wed': <String>['Wednesday', 'Mercredi', 'Miércoles', 'الأربعاء'],
    'thu': <String>['Thursday', 'Jeudi', 'Jueves', 'الخميس'],
    'fri': <String>['Friday', 'Vendredi', 'Viernes', 'الجمعة'],
    'sat': <String>['Saturday', 'Samedi', 'Sábado', 'السبت'],
    'sun': <String>['Sunday', 'Dimanche', 'Domingo', 'الأحد'],
  };
  final List<String>? row = names[key];
  if (row == null) return key;
  return switch (language) {
    AppLanguage.fr => row[1],
    AppLanguage.es => row[2],
    AppLanguage.ar => row[3],
    AppLanguage.en => row[0],
  };
}

/// Formats a MAD price, e.g. `1,500 MAD`.
String formatMad(double amount, {String currency = 'MAD'}) {
  final int value = amount.round();
  final String digits = value.toString();
  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return '$buffer $currency';
}

IconData categoryIcon(EstablishmentCategory category) {
  switch (category) {
    case EstablishmentCategory.restaurants:
      return Icons.restaurant_outlined;
    case EstablishmentCategory.wellness:
      return Icons.spa_outlined;
    case EstablishmentCategory.dayPasses:
      return Icons.pool_outlined;
    case EstablishmentCategory.spectacles:
      return Icons.theater_comedy_outlined;
    case EstablishmentCategory.services:
      return Icons.home_repair_service_outlined;
    case EstablishmentCategory.conciergerie:
      return Icons.room_service_outlined;
    case EstablishmentCategory.voyage:
      return Icons.flight_takeoff_outlined;
    case EstablishmentCategory.corporate:
      return Icons.business_center_outlined;
  }
}

import 'package:flutter/material.dart';
import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:reservamobile/core/models/app_models.dart';

/// Bilingual short label for each category, used on chips/cards.
String categoryLabel(EstablishmentCategory category, AppLanguage language) {
  final bool fr = language.isFrench;
  switch (category) {
    case EstablishmentCategory.restaurants:
      return 'Restaurants';
    case EstablishmentCategory.wellness:
      return fr ? 'Bien-être' : 'Wellness';
    case EstablishmentCategory.dayPasses:
      return fr ? 'Pass journée' : 'Day pass';
    case EstablishmentCategory.spectacles:
      return fr ? 'Spectacles' : 'Spectacles';
    case EstablishmentCategory.services:
      return 'Services';
    case EstablishmentCategory.conciergerie:
      return fr ? 'Conciergerie' : 'Concierge';
    case EstablishmentCategory.voyage:
      return fr ? 'Voyage' : 'Travel';
    case EstablishmentCategory.corporate:
      return 'Corporate';
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

const List<String> _dayOrder = <String>['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

List<String> orderedDays(Iterable<String> keys) {
  final List<String> present = keys.toList();
  return _dayOrder.where(present.contains).toList();
}

String dayName(String key, AppLanguage language) {
  const Map<String, List<String>> names = <String, List<String>>{
    'mon': <String>['Monday', 'Lundi'],
    'tue': <String>['Tuesday', 'Mardi'],
    'wed': <String>['Wednesday', 'Mercredi'],
    'thu': <String>['Thursday', 'Jeudi'],
    'fri': <String>['Friday', 'Vendredi'],
    'sat': <String>['Saturday', 'Samedi'],
    'sun': <String>['Sunday', 'Dimanche'],
  };
  final List<String>? pair = names[key];
  if (pair == null) return key;
  return language.isFrench ? pair[1] : pair[0];
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

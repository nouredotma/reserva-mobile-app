import 'package:flutter/material.dart';
import 'package:reservamobile/core/data/mock/mock_content_registry.dart';
import 'package:reservamobile/core/i18n/app_language.dart';

/// Picks the localized string for [language], falling back to [en] when a locale is missing.
String localizedPick(
  AppLanguage language, {
  required String en,
  required String es,
  String? ar,
  String? fr,
}) {
  return switch (language) {
    AppLanguage.en => en,
    AppLanguage.fr => fr ?? en,
    AppLanguage.es => es,
    AppLanguage.ar => ar ?? en,
  };
}

/// Resolves content using [registryKey] when present, otherwise inline fields.
String resolveLocalized(
  AppLanguage language, {
  required String en,
  required String es,
  String? ar,
  String? fr,
  String? registryKey,
}) {
  if (registryKey != null) {
    final String? fromRegistry = MockContentRegistry.resolve(registryKey, language);
    if (fromRegistry != null) return fromRegistry;
  }
  return localizedPick(language, en: en, es: es, ar: ar, fr: fr);
}

extension AppLanguageLayout on AppLanguage {
  bool get isArabic => this == AppLanguage.ar;

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;
}

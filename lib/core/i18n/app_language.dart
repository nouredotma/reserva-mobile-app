import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported UI languages: English, French, Spanish, and Arabic.
enum AppLanguage {
  en,
  fr,
  es,
  ar;

  String get code => switch (this) {
    AppLanguage.en => 'en',
    AppLanguage.fr => 'fr',
    AppLanguage.es => 'es',
    AppLanguage.ar => 'ar',
  };

  String get label => switch (this) {
    AppLanguage.en => 'English',
    AppLanguage.fr => 'Français',
    AppLanguage.es => 'Español',
    AppLanguage.ar => 'العربية',
  };

  static AppLanguage fromCode(String? code) => switch (code) {
    'fr' => AppLanguage.fr,
    'es' => AppLanguage.es,
    'ar' => AppLanguage.ar,
    _ => AppLanguage.en,
  };
}

class LanguageController extends StateNotifier<AppLanguage> {
  LanguageController(this._prefs)
    : super(AppLanguage.fromCode(_prefs?.getString(_storageKey)));

  static const String _storageKey = 'reserva_language';
  final SharedPreferences? _prefs;

  void setLanguage(AppLanguage language) {
    state = language;
    _prefs?.setString(_storageKey, language.code);
  }
}

/// Overridden in `main.dart` once SharedPreferences is ready.
final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) => null);

final languageProvider = StateNotifierProvider<LanguageController, AppLanguage>((
  ref,
) {
  return LanguageController(ref.watch(sharedPreferencesProvider));
});

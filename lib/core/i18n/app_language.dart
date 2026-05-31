import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported UI languages, mirroring the web app's `en` / `fr` switcher.
enum AppLanguage {
  en,
  fr;

  bool get isFrench => this == AppLanguage.fr;

  String get code => isFrench ? 'fr' : 'en';

  String get label => isFrench ? 'Français' : 'English';

  static AppLanguage fromCode(String? code) =>
      code == 'fr' ? AppLanguage.fr : AppLanguage.en;
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

  void toggle() {
    setLanguage(state.isFrench ? AppLanguage.en : AppLanguage.fr);
  }
}

/// Overridden in `main.dart` once SharedPreferences is ready.
final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) => null);

final languageProvider = StateNotifierProvider<LanguageController, AppLanguage>((
  ref,
) {
  return LanguageController(ref.watch(sharedPreferencesProvider));
});

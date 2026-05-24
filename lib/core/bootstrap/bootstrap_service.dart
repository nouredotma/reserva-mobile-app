import 'package:shared_preferences/shared_preferences.dart';

class BootstrapResult {
  const BootstrapResult({required this.hasSession, required this.languageCode});

  final bool hasSession;
  final String languageCode;
}

class BootstrapService {
  static const String _tokenKey = 'auth_token';
  static const String _languageKey = 'language_code';

  Future<BootstrapResult> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final languageCode = prefs.getString(_languageKey) ?? 'fr';

    return BootstrapResult(
      hasSession: token != null && token.isNotEmpty,
      languageCode: languageCode,
    );
  }
}

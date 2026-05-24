abstract final class MapboxConfig {
  // Set with --dart-define=MAPBOX_ACCESS_TOKEN=...
  static const String accessToken = String.fromEnvironment(
    'MAPBOX_ACCESS_TOKEN',
    defaultValue: '',
  );

  static bool get isConfigured => accessToken.isNotEmpty;
}

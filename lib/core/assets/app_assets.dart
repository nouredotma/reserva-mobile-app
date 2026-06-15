abstract final class AppAssets {
  static const String logo = 'assets/images/logo.png';
  static const String logoWebp = 'assets/images/logo.webp';
  static const String logoWhite = 'assets/images/logo-white.png';
  static const String icon = 'assets/images/icon.png';
  static const String login = 'assets/images/login.png';
  static const String tile = 'assets/images/tile.webp';
  static const String tileJpg = 'assets/images/tile.jpg';

  /// City cover images copied from the web app's `public/cities` folder.
  static const Map<String, String> cityImages = <String, String>{
    'casablanca': 'assets/images/cities/casablanca.webp',
    'marrakesh': 'assets/images/cities/marrakesh.webp',
  };

  static String cityImage(String cityId) =>
      cityImages[cityId] ?? 'assets/images/cities/casablanca.webp';
}

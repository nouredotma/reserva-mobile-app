abstract final class AppAssets {
  static const String logo = 'assets/images/logo.png';
  static const String icon = 'assets/images/icon.png';
  static const String tileJpg = 'assets/images/tile.jpg';

  /// City cover images copied from the web app's `public/cities` folder.
  static const Map<String, String> cityImages = <String, String>{
    'casablanca': 'assets/images/cities/casablanca.webp',
    'marrakesh': 'assets/images/cities/marrakesh.webp',
  };

  static String cityImage(String cityId) =>
      cityImages[cityId] ?? 'assets/images/cities/casablanca.webp';
}

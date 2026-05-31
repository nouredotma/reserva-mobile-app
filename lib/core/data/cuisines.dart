import 'package:reservamobile/core/i18n/app_language.dart';

class CuisineLabel {
  const CuisineLabel(this.en, this.fr);
  final String en;
  final String fr;
}

/// Localized cuisine labels, mirroring the web app's `CUISINES_LOCALIZED`.
const Map<String, CuisineLabel> cuisinesLocalized = <String, CuisineLabel>{
  'moroccan': CuisineLabel('Moroccan', 'Marocain'),
  'mediterranean': CuisineLabel('Mediterranean', 'Méditerranéen'),
  'traditional': CuisineLabel('Traditional', 'Traditionnel'),
  'modern': CuisineLabel('Modern Moroccan', 'Marocain Moderne'),
  'french': CuisineLabel('French', 'Français'),
  'fusion': CuisineLabel('Fusion', 'Fusion'),
  'seafood': CuisineLabel('Seafood', 'Fruits de Mer'),
  'fine_dining': CuisineLabel('Fine Dining', 'Haute Gastronomie'),
  'italian': CuisineLabel('Italian', 'Italien'),
  'japanese': CuisineLabel('Japanese', 'Japonais'),
  'sushi': CuisineLabel('Sushi', 'Sushi'),
  'american': CuisineLabel('American', 'Américain'),
  'asian': CuisineLabel('Asian', 'Asiatique'),
  'bbq': CuisineLabel('BBQ', 'Barbecue'),
  'bakery': CuisineLabel('Bakery', 'Boulangerie'),
  'breakfast': CuisineLabel('Breakfast', 'Petit-déjeuner'),
  'brunch': CuisineLabel('Brunch', 'Brunch'),
  'burgers': CuisineLabel('Burgers', 'Burgers'),
  'cafe': CuisineLabel('Cafe', 'Café'),
  'chinese': CuisineLabel('Chinese', 'Chinois'),
  'dessert': CuisineLabel('Desserts', 'Desserts'),
  'fast_food': CuisineLabel('Fast Food', 'Restauration Rapide'),
  'grill': CuisineLabel('Grill', 'Grillades'),
  'healthy': CuisineLabel('Healthy', 'Sain'),
  'indian': CuisineLabel('Indian', 'Indien'),
  'international': CuisineLabel('International', 'International'),
  'kebab': CuisineLabel('Kebab', 'Kebab'),
  'lebanese': CuisineLabel('Lebanese', 'Libanais'),
  'mexican': CuisineLabel('Mexican', 'Mexicain'),
  'pizza': CuisineLabel('Pizza', 'Pizza'),
  'steakhouse': CuisineLabel('Steakhouse', 'Steakhouse'),
  'street_food': CuisineLabel('Street Food', 'Cuisine de Rue'),
  'thai': CuisineLabel('Thai', 'Thaïlandais'),
  'turkish': CuisineLabel('Turkish', 'Turc'),
  'vegan': CuisineLabel('Vegan', 'Végan'),
  'vegetarian': CuisineLabel('Vegetarian', 'Végétarien'),
  'pastries': CuisineLabel('Pastries', 'Pâtisseries'),
  'tea_room': CuisineLabel('Tea Room', 'Salon de Thé'),
};

String cuisineLabel(String key, AppLanguage language) {
  final label = cuisinesLocalized[key];
  if (label == null) return key.replaceAll('_', ' ');
  return language.isFrench ? label.fr : label.en;
}

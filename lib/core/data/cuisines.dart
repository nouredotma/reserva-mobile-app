import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:reservamobile/core/i18n/localized_value.dart';

class CuisineLabel {
  const CuisineLabel(this.en, this.fr, this.es, this.ar);
  final String en;
  final String fr;
  final String es;
  final String ar;
}

const Map<String, CuisineLabel> cuisinesLocalized = <String, CuisineLabel>{
  'moroccan': CuisineLabel('Moroccan', 'Marocain', 'Marroquí', 'مغربي'),
  'mediterranean': CuisineLabel('Mediterranean', 'Méditerranéen', 'Mediterráneo', 'متوسطي'),
  'traditional': CuisineLabel('Traditional', 'Traditionnel', 'Tradicional', 'تقليدي'),
  'modern': CuisineLabel('Modern Moroccan', 'Marocain moderne', 'Marroquí moderno', 'مغربي حديث'),
  'french': CuisineLabel('French', 'Français', 'Francés', 'فرنسي'),
  'fusion': CuisineLabel('Fusion', 'Fusion', 'Fusión', 'فيوجن'),
  'seafood': CuisineLabel('Seafood', 'Fruits de mer', 'Mariscos', 'مأكولات بحرية'),
  'fine_dining': CuisineLabel('Fine Dining', 'Gastronomie', 'Alta cocina', 'مطبخ راقٍ'),
  'italian': CuisineLabel('Italian', 'Italien', 'Italiano', 'إيطالي'),
  'japanese': CuisineLabel('Japanese', 'Japonais', 'Japonés', 'ياباني'),
  'sushi': CuisineLabel('Sushi', 'Sushi', 'Sushi', 'سوشي'),
  'american': CuisineLabel('American', 'Américain', 'Americano', 'أمريكي'),
  'asian': CuisineLabel('Asian', 'Asiatique', 'Asiático', 'آسيوي'),
  'bbq': CuisineLabel('BBQ', 'Barbecue', 'Barbacoa', 'شواء'),
  'bakery': CuisineLabel('Bakery', 'Boulangerie', 'Panadería', 'مخبز'),
  'breakfast': CuisineLabel('Breakfast', 'Petit-déjeuner', 'Desayuno', 'فطور'),
  'brunch': CuisineLabel('Brunch', 'Brunch', 'Brunch', 'برانش'),
  'burgers': CuisineLabel('Burgers', 'Burgers', 'Hamburguesas', 'برغر'),
  'cafe': CuisineLabel('Cafe', 'Café', 'Café', 'مقهى'),
  'chinese': CuisineLabel('Chinese', 'Chinois', 'Chino', 'صيني'),
  'dessert': CuisineLabel('Desserts', 'Desserts', 'Postres', 'حلويات'),
  'fast_food': CuisineLabel('Fast Food', 'Restauration rapide', 'Comida rápida', 'وجبات سريعة'),
  'grill': CuisineLabel('Grill', 'Grill', 'Parrilla', 'مشاوي'),
  'healthy': CuisineLabel('Healthy', 'Sain', 'Saludable', 'صحي'),
  'indian': CuisineLabel('Indian', 'Indien', 'Indio', 'هندي'),
  'international': CuisineLabel('International', 'International', 'Internacional', 'عالمي'),
  'kebab': CuisineLabel('Kebab', 'Kebab', 'Kebab', 'كباب'),
  'lebanese': CuisineLabel('Lebanese', 'Libanais', 'Libanés', 'لبناني'),
  'mexican': CuisineLabel('Mexican', 'Mexicain', 'Mexicano', 'مكسيكي'),
  'pizza': CuisineLabel('Pizza', 'Pizza', 'Pizza', 'بيتزا'),
  'steakhouse': CuisineLabel('Steakhouse', 'Grill', 'Asador', 'ستيك هاوس'),
  'street_food': CuisineLabel('Street Food', 'Street food', 'Comida callejera', 'طعام الشارع'),
  'thai': CuisineLabel('Thai', 'Thaï', 'Tailandés', 'تايلاندي'),
  'turkish': CuisineLabel('Turkish', 'Turc', 'Turco', 'تركي'),
  'vegan': CuisineLabel('Vegan', 'Végan', 'Vegano', 'نباتي'),
  'vegetarian': CuisineLabel('Vegetarian', 'Végétarien', 'Vegetariano', 'نباتي'),
  'pastries': CuisineLabel('Pastries', 'Pâtisseries', 'Pastelería', 'معجنات'),
  'tea_room': CuisineLabel('Tea Room', 'Salon de thé', 'Salón de té', 'صالون شاي'),
};

String cuisineLabel(String key, AppLanguage language) {
  final label = cuisinesLocalized[key];
  if (label == null) return key.replaceAll('_', ' ');
  return localizedPick(
    language,
    en: label.en,
    fr: label.fr,
    es: label.es,
    ar: label.ar,
  );
}

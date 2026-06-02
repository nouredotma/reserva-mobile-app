import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/core/providers/reserva_providers.dart';

/// True when categories, cities, and featured listings are ready for the home tab.
final homeDataReadyProvider = Provider<bool>((ref) {
  final categories = ref.watch(categoriesProvider);
  final cities = ref.watch(citiesProvider);
  final featured = ref.watch(featuredEstablishmentsProvider);
  return categories.hasValue && cities.hasValue && featured.hasValue;
});

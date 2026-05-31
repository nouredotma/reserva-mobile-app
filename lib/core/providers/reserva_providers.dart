import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/repositories/mock_reserva_repository.dart';
import 'package:reservamobile/core/repositories/reserva_repository.dart';

final reservaRepositoryProvider = Provider<ReservaRepository>((ref) {
  return MockReservaRepository();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return ref.watch(reservaRepositoryProvider).getCategories();
});

final citiesProvider = FutureProvider<List<City>>((ref) async {
  return ref.watch(reservaRepositoryProvider).getCities();
});

final featuredEstablishmentsProvider =
    FutureProvider<List<Establishment>>((ref) async {
  return ref.watch(reservaRepositoryProvider).getFeaturedEstablishments();
});

final subcategoriesProvider =
    FutureProvider.family<List<Subcategory>, EstablishmentCategory>(
        (ref, category) async {
  return ref.watch(reservaRepositoryProvider).getSubcategories(category);
});

class SearchFilters {
  const SearchFilters({
    this.cityId,
    this.category,
    this.subcategory,
    this.cuisine,
    this.minRating,
    this.query = '',
    this.sort = SortOption.recommended,
  });

  final String? cityId;
  final EstablishmentCategory? category;
  final String? subcategory;
  final String? cuisine;
  final double? minRating;
  final String query;
  final SortOption sort;

  SearchFilters copyWith({
    String? cityId,
    EstablishmentCategory? category,
    String? subcategory,
    String? cuisine,
    double? minRating,
    String? query,
    SortOption? sort,
    bool clearCity = false,
    bool clearCategory = false,
    bool clearSubcategory = false,
    bool clearCuisine = false,
    bool clearRating = false,
  }) {
    return SearchFilters(
      cityId: clearCity ? null : (cityId ?? this.cityId),
      category: clearCategory ? null : (category ?? this.category),
      subcategory: clearSubcategory ? null : (subcategory ?? this.subcategory),
      cuisine: clearCuisine ? null : (cuisine ?? this.cuisine),
      minRating: clearRating ? null : (minRating ?? this.minRating),
      query: query ?? this.query,
      sort: sort ?? this.sort,
    );
  }

  bool get hasActiveFilters =>
      cityId != null ||
      category != null ||
      subcategory != null ||
      cuisine != null ||
      minRating != null ||
      query.isNotEmpty;
}

class SearchFiltersNotifier extends StateNotifier<SearchFilters> {
  SearchFiltersNotifier() : super(const SearchFilters());

  void setCity(String? cityId) {
    state = state.copyWith(
      cityId: cityId,
      clearCity: cityId == null || cityId.isEmpty,
    );
  }

  void setCategory(EstablishmentCategory? category) {
    state = state.copyWith(
      category: category,
      clearCategory: category == null,
      clearSubcategory: true,
    );
  }

  void setSubcategory(String? subcategory) {
    state = state.copyWith(
      subcategory: subcategory,
      clearSubcategory: subcategory == null || subcategory.isEmpty,
    );
  }

  void setCuisine(String? cuisine) {
    state = state.copyWith(
      cuisine: cuisine,
      clearCuisine: cuisine == null || cuisine.isEmpty,
    );
  }

  void setMinRating(double? rating) {
    state = state.copyWith(minRating: rating, clearRating: rating == null);
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setSort(SortOption sort) {
    state = state.copyWith(sort: sort);
  }

  void clear() {
    state = const SearchFilters();
  }
}

final searchFiltersProvider =
    StateNotifierProvider<SearchFiltersNotifier, SearchFilters>(
  (ref) => SearchFiltersNotifier(),
);

final searchedEstablishmentsProvider =
    FutureProvider<List<Establishment>>((ref) async {
  final filters = ref.watch(searchFiltersProvider);
  return ref.watch(reservaRepositoryProvider).searchEstablishments(
        cityId: filters.cityId,
        category: filters.category,
        subcategory: filters.subcategory,
        cuisine: filters.cuisine,
        minRating: filters.minRating,
        query: filters.query,
        sort: filters.sort,
      );
});

final establishmentByIdProvider =
    FutureProvider.family<Establishment?, String>((ref, id) async {
  return ref.watch(reservaRepositoryProvider).getEstablishmentById(id);
});

final servicesProvider =
    FutureProvider.family<List<ServiceItem>, String>((ref, establishmentId) async {
  return ref
      .watch(reservaRepositoryProvider)
      .getServicesForEstablishment(establishmentId);
});

final reviewsProvider =
    FutureProvider.family<List<ReviewItem>, String>((ref, establishmentId) async {
  return ref
      .watch(reservaRepositoryProvider)
      .getReviewsForEstablishment(establishmentId);
});

/// Bundles all category-specific detail tables for a given establishment.
class EstablishmentDetails {
  const EstablishmentDetails({
    this.voyage,
    this.restaurant,
    this.wellness,
    this.dayPass,
    this.spectacles,
    this.experience,
  });

  final VoyageDetails? voyage;
  final RestaurantDetails? restaurant;
  final WellnessDetails? wellness;
  final DayPassDetails? dayPass;
  final SpectaclesDetails? spectacles;
  final ExperienceDetails? experience;
}

final establishmentDetailsProvider =
    FutureProvider.family<EstablishmentDetails, Establishment>(
        (ref, est) async {
  final repo = ref.watch(reservaRepositoryProvider);
  switch (est.category) {
    case EstablishmentCategory.voyage:
      return EstablishmentDetails(voyage: await repo.getVoyageDetails(est.id));
    case EstablishmentCategory.restaurants:
      return EstablishmentDetails(
          restaurant: await repo.getRestaurantDetails(est.id));
    case EstablishmentCategory.wellness:
      return EstablishmentDetails(
          wellness: await repo.getWellnessDetails(est.id));
    case EstablishmentCategory.dayPasses:
      return EstablishmentDetails(
          dayPass: await repo.getDayPassDetails(est.id));
    case EstablishmentCategory.spectacles:
      return EstablishmentDetails(
          spectacles: await repo.getSpectaclesDetails(est.id));
    case EstablishmentCategory.conciergerie:
    case EstablishmentCategory.corporate:
    case EstablishmentCategory.services:
      return EstablishmentDetails(
          experience: await repo.getExperienceDetails(est.id));
  }
});

final userBookingsProvider = FutureProvider<List<BookingItem>>((ref) async {
  return ref.watch(reservaRepositoryProvider).getUserBookings();
});

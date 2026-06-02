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
    this.subcategories = const <String>[],
    this.cuisines = const <String>[],
    this.minRating,
    this.query = '',
    this.sort = SortOption.recommended,
    this.date,
    this.time,
    this.adults = 0,
    this.children = 0,
  });

  final String? cityId;
  final EstablishmentCategory? category;
  final List<String> subcategories;
  final List<String> cuisines;
  final double? minRating;
  final String query;
  final SortOption sort;
  final DateTime? date;
  final String? time;
  final int adults;
  final int children;

  SearchFilters copyWith({
    String? cityId,
    EstablishmentCategory? category,
    List<String>? subcategories,
    List<String>? cuisines,
    double? minRating,
    String? query,
    SortOption? sort,
    DateTime? date,
    String? time,
    int? adults,
    int? children,
    bool clearCity = false,
    bool clearCategory = false,
    bool clearSubcategory = false,
    bool clearCuisine = false,
    bool clearRating = false,
    bool clearDate = false,
    bool clearTime = false,
  }) {
    return SearchFilters(
      cityId: clearCity ? null : (cityId ?? this.cityId),
      category: clearCategory ? null : (category ?? this.category),
      subcategories: clearSubcategory
          ? const <String>[]
          : (subcategories ?? this.subcategories),
      cuisines: clearCuisine ? const <String>[] : (cuisines ?? this.cuisines),
      minRating: clearRating ? null : (minRating ?? this.minRating),
      query: query ?? this.query,
      sort: sort ?? this.sort,
      date: clearDate ? null : (date ?? this.date),
      time: clearTime ? null : (time ?? this.time),
      adults: adults ?? this.adults,
      children: children ?? this.children,
    );
  }

  bool get hasActiveFilters =>
      cityId != null ||
      category != null ||
      subcategories.isNotEmpty ||
      cuisines.isNotEmpty ||
      minRating != null ||
      query.isNotEmpty ||
      date != null ||
      time != null ||
      adults > 0 ||
      children > 0;
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

  void setSubcategories(List<String> subcategories) {
    state = state.copyWith(
      subcategories: subcategories,
      clearSubcategory: subcategories.isEmpty,
    );
  }

  void toggleSubcategory(String key) {
    final current = List<String>.of(state.subcategories);
    if (current.contains(key)) {
      current.remove(key);
    } else {
      current.add(key);
    }
    setSubcategories(current);
  }

  void setCuisines(List<String> cuisines) {
    state = state.copyWith(
      cuisines: cuisines,
      clearCuisine: cuisines.isEmpty,
    );
  }

  void toggleCuisine(String key) {
    final current = List<String>.of(state.cuisines);
    if (current.contains(key)) {
      current.remove(key);
    } else {
      current.add(key);
    }
    setCuisines(current);
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

  void setDate(DateTime? date) {
    state = state.copyWith(date: date, clearDate: date == null);
  }

  void setTime(String? time) {
    state = state.copyWith(
      time: time,
      clearTime: time == null || time.isEmpty,
    );
  }

  void setGuests({int? adults, int? children}) {
    state = state.copyWith(
      adults: adults ?? state.adults,
      children: children ?? state.children,
    );
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
        subcategories: filters.subcategories,
        cuisines: filters.cuisines,
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

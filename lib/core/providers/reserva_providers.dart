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

final featuredEstablishmentsProvider = FutureProvider<List<Establishment>>((
  ref,
) async {
  return ref.watch(reservaRepositoryProvider).getFeaturedEstablishments();
});

class SearchFilters {
  const SearchFilters({this.cityId, this.category, this.query = ''});

  final String? cityId;
  final EstablishmentCategory? category;
  final String query;

  SearchFilters copyWith({
    String? cityId,
    EstablishmentCategory? category,
    String? query,
    bool clearCity = false,
    bool clearCategory = false,
  }) {
    return SearchFilters(
      cityId: clearCity ? null : (cityId ?? this.cityId),
      category: clearCategory ? null : (category ?? this.category),
      query: query ?? this.query,
    );
  }
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
    state = state.copyWith(category: category, clearCategory: category == null);
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }
}

final searchFiltersProvider =
    StateNotifierProvider<SearchFiltersNotifier, SearchFilters>(
      (ref) => SearchFiltersNotifier(),
    );

final searchedEstablishmentsProvider = FutureProvider<List<Establishment>>((
  ref,
) async {
  final filters = ref.watch(searchFiltersProvider);
  return ref
      .watch(reservaRepositoryProvider)
      .searchEstablishments(
        cityId: filters.cityId,
        category: filters.category,
        query: filters.query,
      );
});

final userBookingsProvider = FutureProvider<List<BookingItem>>((ref) async {
  return ref.watch(reservaRepositoryProvider).getUserBookings();
});

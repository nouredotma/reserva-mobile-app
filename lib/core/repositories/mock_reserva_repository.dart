import 'package:reservamobile/core/data/mock/mock_data.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/repositories/reserva_repository.dart';

class MockReservaRepository implements ReservaRepository {
  final List<City> _cities = List<City>.of(mockCities);
  final List<Category> _categories = List<Category>.of(mockCategories);
  final List<Subcategory> _subcategories = List<Subcategory>.of(mockSubcategories);
  final List<Establishment> _establishments = List<Establishment>.of(mockEstablishments);
  final List<ServiceItem> _services = List<ServiceItem>.of(mockServices);
  final List<ReviewItem> _reviews = List<ReviewItem>.of(mockReviews);
  final List<BookingItem> _bookings = List<BookingItem>.of(mockBookings);

  @override
  Future<List<Category>> getCategories() async => _categories;

  @override
  Future<List<City>> getCities() async => _cities;

  @override
  Future<List<Subcategory>> getSubcategories(
    EstablishmentCategory category,
  ) async {
    return _subcategories
        .where((s) => s.categoryKey == category)
        .toList(growable: false);
  }

  @override
  Future<List<Establishment>> getAllEstablishments() async => _establishments;

  @override
  Future<List<Establishment>> getFeaturedEstablishments() async {
    return _establishments.where((e) => e.isFeatured).toList(growable: false);
  }

  int _priceWeight(String level) => level.length;

  @override
  Future<List<Establishment>> searchEstablishments({
    String? cityId,
    EstablishmentCategory? category,
    String? subcategory,
    String? cuisine,
    double? minRating,
    String? query,
    SortOption sort = SortOption.recommended,
  }) async {
    final normalized = query?.trim().toLowerCase();
    final results = _establishments.where((e) {
      final cityOk = cityId == null || cityId.isEmpty || e.cityId == cityId;
      final categoryOk = category == null || e.category == category;
      final subOk =
          subcategory == null || subcategory.isEmpty || e.subcategory == subcategory;
      final cuisineOk = cuisine == null ||
          cuisine.isEmpty ||
          (_restaurantDetailsFor(e.id)?.cuisineType.contains(cuisine) ?? false);
      final ratingOk = minRating == null || e.rating >= minRating;
      final queryOk = normalized == null ||
          normalized.isEmpty ||
          e.name.toLowerCase().contains(normalized) ||
          e.nameFr.toLowerCase().contains(normalized) ||
          e.tags.any((t) => t.toLowerCase().contains(normalized)) ||
          e.address.toLowerCase().contains(normalized);
      return cityOk && categoryOk && subOk && cuisineOk && ratingOk && queryOk;
    }).toList();

    switch (sort) {
      case SortOption.rating:
        results.sort((a, b) => b.rating.compareTo(a.rating));
      case SortOption.priceLowHigh:
        results.sort((a, b) => _priceWeight(a.priceLevel).compareTo(_priceWeight(b.priceLevel)));
      case SortOption.priceHighLow:
        results.sort((a, b) => _priceWeight(b.priceLevel).compareTo(_priceWeight(a.priceLevel)));
      case SortOption.recommended:
        results.sort((a, b) {
          if (a.isFeatured != b.isFeatured) return a.isFeatured ? -1 : 1;
          return b.rating.compareTo(a.rating);
        });
    }
    return results;
  }

  @override
  Future<Establishment?> getEstablishmentById(String id) async {
    for (final item in _establishments) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  Future<Establishment?> getEstablishmentBySlug(String slug) async {
    for (final item in _establishments) {
      if (item.slug == slug) return item;
    }
    return null;
  }

  @override
  Future<List<ServiceItem>> getServicesForEstablishment(
    String establishmentId,
  ) async {
    return _services
        .where((service) => service.establishmentId == establishmentId)
        .toList(growable: false);
  }

  @override
  Future<List<ReviewItem>> getReviewsForEstablishment(
    String establishmentId,
  ) async {
    return _reviews
        .where((review) => review.establishmentId == establishmentId)
        .toList(growable: false);
  }

  RestaurantDetails? _restaurantDetailsFor(String id) {
    for (final d in mockRestaurantDetails) {
      if (d.establishmentId == id) return d;
    }
    return null;
  }

  @override
  Future<VoyageDetails?> getVoyageDetails(String establishmentId) async {
    for (final d in mockVoyageDetails) {
      if (d.establishmentId == establishmentId) return d;
    }
    return null;
  }

  @override
  Future<RestaurantDetails?> getRestaurantDetails(String establishmentId) async =>
      _restaurantDetailsFor(establishmentId);

  @override
  Future<WellnessDetails?> getWellnessDetails(String establishmentId) async {
    for (final d in mockWellnessDetails) {
      if (d.establishmentId == establishmentId) return d;
    }
    return null;
  }

  @override
  Future<DayPassDetails?> getDayPassDetails(String establishmentId) async {
    for (final d in mockDayPassDetails) {
      if (d.establishmentId == establishmentId) return d;
    }
    return null;
  }

  @override
  Future<SpectaclesDetails?> getSpectaclesDetails(String establishmentId) async {
    for (final d in mockSpectaclesDetails) {
      if (d.establishmentId == establishmentId) return d;
    }
    return null;
  }

  @override
  Future<ExperienceDetails?> getExperienceDetails(String establishmentId) async {
    for (final d in mockExperienceDetails) {
      if (d.establishmentId == establishmentId) return d;
    }
    return null;
  }

  @override
  Future<List<BookingItem>> getUserBookings() async => _bookings;

  @override
  Future<BookingItem> createBooking({
    required Establishment establishment,
    required ServiceItem service,
    required DateTime bookingDate,
    required String startTime,
    required int guestCount,
    required double totalPriceMad,
    required String notes,
  }) async {
    City? city;
    for (final c in _cities) {
      if (c.id == establishment.cityId) {
        city = c;
        break;
      }
    }
    final booking = BookingItem(
      id: 'bk-${DateTime.now().millisecondsSinceEpoch}',
      establishmentId: establishment.id,
      establishmentName: establishment.name,
      establishmentNameFr: establishment.nameFr,
      category: establishment.category,
      slug: establishment.slug,
      serviceName: service.name,
      serviceNameFr: service.nameFr,
      cityName: city?.name ?? '',
      cityNameFr: city?.nameFr ?? '',
      address: establishment.address,
      coverImage: establishment.coverImage,
      bookingDate: bookingDate,
      startTime: startTime,
      guestCount: guestCount,
      totalPriceMad: totalPriceMad,
      status: service.requiresConfirmation
          ? BookingStatus.pending
          : BookingStatus.confirmed,
      notes: notes,
      notesFr: notes,
    );
    _bookings.insert(0, booking);
    return booking;
  }

  @override
  Future<ReviewItem> addReview({
    required String establishmentId,
    required double rating,
    required String title,
    required String content,
  }) async {
    final review = ReviewItem(
      id: 'rev-local-${DateTime.now().millisecondsSinceEpoch}',
      establishmentId: establishmentId,
      userName: 'You',
      userAvatar:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&h=150&fit=crop&crop=face&q=80',
      rating: rating,
      title: title,
      titleFr: title,
      content: content,
      contentFr: content,
      isVerified: false,
      createdAt: DateTime.now(),
    );
    _reviews.insert(0, review);
    return review;
  }
}

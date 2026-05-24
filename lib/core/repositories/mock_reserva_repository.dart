import 'package:reservamobile/core/data/mock/mock_data.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/repositories/reserva_repository.dart';

class MockReservaRepository implements ReservaRepository {
  final List<City> _cities = List<City>.of(mockCities);
  final List<Category> _categories = List<Category>.of(mockCategories);
  final List<Establishment> _establishments = List<Establishment>.of(
    mockEstablishments,
  );
  final List<ServiceItem> _services = List<ServiceItem>.of(mockServices);
  final List<ReviewItem> _reviews = List<ReviewItem>.of(mockReviews);
  final List<BookingItem> _bookings = List<BookingItem>.of(mockBookings);

  @override
  Future<List<Category>> getCategories() async => _categories;

  @override
  Future<List<City>> getCities() async => _cities;

  @override
  Future<List<Establishment>> getFeaturedEstablishments() async {
    return _establishments.where((e) => e.isFeatured).toList(growable: false);
  }

  @override
  Future<List<Establishment>> searchEstablishments({
    String? cityId,
    EstablishmentCategory? category,
    String? query,
  }) async {
    final normalized = query?.trim().toLowerCase();
    return _establishments
        .where((e) {
          final cityOk = cityId == null || cityId.isEmpty || e.cityId == cityId;
          final categoryOk = category == null || e.category == category;
          final queryOk =
              normalized == null ||
              normalized.isEmpty ||
              e.name.toLowerCase().contains(normalized) ||
              e.subcategory.toLowerCase().contains(normalized) ||
              e.cityName.toLowerCase().contains(normalized);
          return cityOk && categoryOk && queryOk;
        })
        .toList(growable: false);
  }

  @override
  Future<Establishment?> getEstablishmentById(String id) async {
    for (final item in _establishments) {
      if (item.id == id) {
        return item;
      }
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

  @override
  Future<List<BookingItem>> getUserBookings() async => _bookings;

  @override
  Future<BookingItem> createBooking({
    required String establishmentId,
    required String serviceId,
    required DateTime bookingDate,
    required String startTime,
    required int guestCount,
    required String notes,
  }) async {
    final establishment = await getEstablishmentById(establishmentId);
    final service = _services.firstWhere((s) => s.id == serviceId);

    final booking = BookingItem(
      id: 'bk-${DateTime.now().millisecondsSinceEpoch}',
      establishmentId: establishmentId,
      establishmentName: establishment?.name ?? 'Unknown',
      category: establishment?.category ?? EstablishmentCategory.services,
      serviceName: service.name,
      cityName: establishment?.cityName ?? 'Unknown',
      bookingDate: bookingDate,
      startTime: startTime,
      guestCount: guestCount,
      totalPriceMad: service.priceMad * guestCount,
      status: BookingStatus.pending,
      notes: notes,
    );
    _bookings.insert(0, booking);
    return booking;
  }

  @override
  Future<ReviewItem> addReview({
    required String establishmentId,
    required double rating,
    required String content,
  }) async {
    final review = ReviewItem(
      id: 'rev-${DateTime.now().millisecondsSinceEpoch}',
      establishmentId: establishmentId,
      userName: 'You',
      rating: rating,
      content: content,
      createdAt: DateTime.now(),
    );
    _reviews.insert(0, review);
    return review;
  }
}

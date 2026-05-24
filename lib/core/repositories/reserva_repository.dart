import 'package:reservamobile/core/models/app_models.dart';

abstract class ReservaRepository {
  Future<List<Category>> getCategories();
  Future<List<City>> getCities();
  Future<List<Establishment>> getFeaturedEstablishments();
  Future<List<Establishment>> searchEstablishments({
    String? cityId,
    EstablishmentCategory? category,
    String? query,
  });
  Future<Establishment?> getEstablishmentById(String id);
  Future<List<ServiceItem>> getServicesForEstablishment(String establishmentId);
  Future<List<ReviewItem>> getReviewsForEstablishment(String establishmentId);
  Future<List<BookingItem>> getUserBookings();
  Future<BookingItem> createBooking({
    required String establishmentId,
    required String serviceId,
    required DateTime bookingDate,
    required String startTime,
    required int guestCount,
    required String notes,
  });
  Future<ReviewItem> addReview({
    required String establishmentId,
    required double rating,
    required String content,
  });
}

import 'package:reservamobile/core/models/app_models.dart';

/// Sort options for search results, mirroring the web search page.
enum SortOption { recommended, rating, priceLowHigh, priceHighLow }

abstract class ReservaRepository {
  Future<List<Category>> getCategories();
  Future<List<City>> getCities();
  Future<List<Subcategory>> getSubcategories(EstablishmentCategory category);
  Future<List<Establishment>> getAllEstablishments();
  Future<List<Establishment>> getFeaturedEstablishments();
  Future<List<Establishment>> searchEstablishments({
    String? cityId,
    EstablishmentCategory? category,
    List<String>? subcategories,
    List<String>? cuisines,
    double? minRating,
    String? query,
    SortOption sort,
  });
  Future<Establishment?> getEstablishmentById(String id);
  Future<Establishment?> getEstablishmentBySlug(String slug);
  Future<List<ServiceItem>> getServicesForEstablishment(String establishmentId);
  Future<List<ReviewItem>> getReviewsForEstablishment(String establishmentId);

  Future<VoyageDetails?> getVoyageDetails(String establishmentId);
  Future<RestaurantDetails?> getRestaurantDetails(String establishmentId);
  Future<WellnessDetails?> getWellnessDetails(String establishmentId);
  Future<DayPassDetails?> getDayPassDetails(String establishmentId);
  Future<SpectaclesDetails?> getSpectaclesDetails(String establishmentId);
  Future<ExperienceDetails?> getExperienceDetails(String establishmentId);

  Future<List<BookingItem>> getUserBookings();
  Future<BookingItem> createBooking({
    required Establishment establishment,
    required ServiceItem service,
    required DateTime bookingDate,
    required String startTime,
    required int guestCount,
    required double totalPriceMad,
    required String notes,
  });
  Future<ReviewItem> addReview({
    required String establishmentId,
    required double rating,
    required String title,
    required String content,
  });
}

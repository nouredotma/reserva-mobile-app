enum EstablishmentCategory {
  wellness,
  dayPasses,
  conciergerie,
  spectacles,
  voyage,
  corporate,
  services,
  restaurants,
}

class City {
  const City({required this.id, required this.name, required this.nameFr});

  final String id;
  final String name;
  final String nameFr;
}

class Category {
  const Category({
    required this.key,
    required this.label,
    required this.labelFr,
  });

  final EstablishmentCategory key;
  final String label;
  final String labelFr;
}

class Establishment {
  const Establishment({
    required this.id,
    required this.name,
    required this.nameFr,
    required this.category,
    required this.subcategory,
    required this.cityId,
    required this.cityName,
    required this.cityNameFr,
    required this.shortDescription,
    required this.shortDescriptionFr,
    required this.rating,
    required this.reviewCount,
    required this.priceLevel,
    required this.address,
    required this.isFeatured,
    required this.coverImage,
  });

  final String id;
  final String name;
  final String nameFr;
  final EstablishmentCategory category;
  final String subcategory;
  final String cityId;
  final String cityName;
  final String cityNameFr;
  final String shortDescription;
  final String shortDescriptionFr;
  final double rating;
  final int reviewCount;
  final String priceLevel;
  final String address;
  final bool isFeatured;
  final String coverImage;
}

class ServiceItem {
  const ServiceItem({
    required this.id,
    required this.establishmentId,
    required this.name,
    required this.nameFr,
    required this.priceMad,
    required this.durationMinutes,
    required this.minPeople,
    required this.maxPeople,
  });

  final String id;
  final String establishmentId;
  final String name;
  final String nameFr;
  final double priceMad;
  final int durationMinutes;
  final int minPeople;
  final int maxPeople;
}

class ReviewItem {
  const ReviewItem({
    required this.id,
    required this.establishmentId,
    required this.userName,
    required this.rating,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String establishmentId;
  final String userName;
  final double rating;
  final String content;
  final DateTime createdAt;
}

enum BookingStatus { pending, confirmed, cancelled, completed }

class BookingItem {
  const BookingItem({
    required this.id,
    required this.establishmentId,
    required this.establishmentName,
    required this.category,
    required this.serviceName,
    required this.cityName,
    required this.bookingDate,
    required this.startTime,
    required this.guestCount,
    required this.totalPriceMad,
    required this.status,
    required this.notes,
  });

  final String id;
  final String establishmentId;
  final String establishmentName;
  final EstablishmentCategory category;
  final String serviceName;
  final String cityName;
  final DateTime bookingDate;
  final String startTime;
  final int guestCount;
  final double totalPriceMad;
  final BookingStatus status;
  final String notes;
}

class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
}

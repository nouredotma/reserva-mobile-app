import 'package:reservamobile/core/i18n/app_language.dart';

/// Establishment categories, mirroring the web app's `EstablishmentCategory`.
enum EstablishmentCategory {
  wellness('wellness'),
  dayPasses('day-passes'),
  conciergerie('conciergerie'),
  spectacles('spectacles'),
  voyage('voyage'),
  corporate('corporate'),
  services('services'),
  restaurants('restaurants');

  const EstablishmentCategory(this.slug);

  /// The URL/key slug used by the web app (e.g. `day-passes`).
  final String slug;

  static EstablishmentCategory? fromSlug(String? slug) {
    if (slug == null) return null;
    for (final value in EstablishmentCategory.values) {
      if (value.slug == slug) return value;
    }
    return null;
  }
}

class Coordinates {
  const Coordinates({required this.lat, required this.lng});

  final double lat;
  final double lng;
}

class City {
  const City({
    required this.id,
    required this.name,
    required this.nameFr,
    required this.slug,
    required this.region,
    required this.regionFr,
    required this.image,
    required this.coordinates,
    required this.description,
    required this.descriptionFr,
  });

  final String id;
  final String name;
  final String nameFr;
  final String slug;
  final String region;
  final String regionFr;

  /// Local asset path for the city cover image.
  final String image;
  final Coordinates coordinates;
  final String description;
  final String descriptionFr;

  String localizedName(AppLanguage language) =>
      language.isFrench ? nameFr : name;
  String localizedRegion(AppLanguage language) =>
      language.isFrench ? regionFr : region;
  String localizedDescription(AppLanguage language) =>
      language.isFrench ? descriptionFr : description;
}

class Category {
  const Category({
    required this.key,
    required this.label,
    required this.labelFr,
    required this.image,
    required this.description,
    required this.descriptionFr,
  });

  final EstablishmentCategory key;
  final String label;
  final String labelFr;

  /// Remote image URL (Unsplash) — loaded via network.
  final String image;
  final String description;
  final String descriptionFr;

  String localizedLabel(AppLanguage language) =>
      language.isFrench ? labelFr : label;
  String localizedDescription(AppLanguage language) =>
      language.isFrench ? descriptionFr : description;
}

class Subcategory {
  const Subcategory({
    required this.key,
    required this.label,
    required this.labelFr,
    required this.categoryKey,
  });

  final String key;
  final String label;
  final String labelFr;
  final EstablishmentCategory categoryKey;

  String localizedLabel(AppLanguage language) =>
      language.isFrench ? labelFr : label;
}

class Establishment {
  const Establishment({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.nameFr,
    required this.slug,
    required this.category,
    required this.subcategory,
    required this.shortDescription,
    required this.shortDescriptionFr,
    required this.fullDescription,
    required this.fullDescriptionFr,
    required this.cityId,
    required this.address,
    required this.coordinates,
    required this.phone,
    required this.email,
    required this.website,
    required this.coverImage,
    required this.galleryImages,
    required this.rating,
    required this.reviewCount,
    required this.priceLevel,
    required this.tags,
    required this.isFeatured,
    required this.sortOrder,
  });

  final String id;
  final String ownerId;
  final String name;
  final String nameFr;
  final String slug;
  final EstablishmentCategory category;
  final String? subcategory;
  final String shortDescription;
  final String shortDescriptionFr;
  final String fullDescription;
  final String fullDescriptionFr;
  final String cityId;
  final String address;
  final Coordinates coordinates;
  final String phone;
  final String email;
  final String? website;

  /// Remote image URL.
  final String coverImage;
  final List<String> galleryImages;
  final double rating;
  final int reviewCount;
  final String priceLevel;
  final List<String> tags;
  final bool isFeatured;
  final int sortOrder;

  List<String> get allImages => <String>[coverImage, ...galleryImages];

  String localizedName(AppLanguage language) =>
      language.isFrench ? nameFr : name;
  String localizedShortDescription(AppLanguage language) =>
      language.isFrench ? shortDescriptionFr : shortDescription;
  String localizedFullDescription(AppLanguage language) =>
      language.isFrench ? fullDescriptionFr : fullDescription;
}

class AddOn {
  const AddOn({
    required this.name,
    required this.nameFr,
    required this.price,
    this.description,
  });

  final String name;
  final String nameFr;
  final double price;
  final String? description;
}

class ServiceItem {
  const ServiceItem({
    required this.id,
    required this.establishmentId,
    required this.name,
    required this.nameFr,
    required this.slug,
    required this.shortDescription,
    this.shortDescriptionFr,
    required this.serviceType,
    required this.price,
    this.currency = 'MAD',
    this.requiresDeposit = false,
    this.depositAmount,
    this.depositType,
    this.durationMinutes,
    this.minPeople = 1,
    this.maxPeople = 2,
    this.capacityPerSlot = 5,
    this.isAvailable = true,
    this.availableDays = const <int>[0, 1, 2, 3, 4, 5, 6],
    this.startTime,
    this.endTime,
    this.blackoutDates = const <String>[],
    this.advanceBookingHours = 24,
    this.requiresConfirmation = false,
    this.instantBooking = true,
    this.includedItems = const <String>[],
    this.coverImage = '',
    this.isFeatured = false,
    this.sortOrder = 1,
  });

  final String id;
  final String establishmentId;
  final String name;
  final String nameFr;
  final String slug;
  final String shortDescription;
  final String? shortDescriptionFr;
  final String serviceType;
  final double price;
  final String currency;
  final bool requiresDeposit;
  final double? depositAmount;
  final String? depositType;
  final int? durationMinutes;
  final int minPeople;
  final int maxPeople;
  final int capacityPerSlot;
  final bool isAvailable;
  final List<int> availableDays;
  final String? startTime;
  final String? endTime;
  final List<String> blackoutDates;
  final int advanceBookingHours;
  final bool requiresConfirmation;
  final bool instantBooking;
  final List<String> includedItems;
  final String coverImage;
  final bool isFeatured;
  final int sortOrder;

  String localizedName(AppLanguage language) =>
      language.isFrench ? nameFr : name;
  String localizedShortDescription(AppLanguage language) =>
      language.isFrench && shortDescriptionFr != null
      ? shortDescriptionFr!
      : shortDescription;
}

class ReviewItem {
  const ReviewItem({
    required this.id,
    required this.establishmentId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.title,
    required this.titleFr,
    required this.content,
    required this.contentFr,
    required this.isVerified,
    required this.createdAt,
  });

  final String id;
  final String establishmentId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String title;
  final String titleFr;
  final String content;
  final String contentFr;
  final bool isVerified;
  final DateTime createdAt;

  String localizedTitle(AppLanguage language) =>
      language.isFrench ? titleFr : title;
  String localizedContent(AppLanguage language) =>
      language.isFrench ? contentFr : content;
}

/// Opening hour entry for a single day.
class OpeningHours {
  const OpeningHours({required this.open, required this.close});

  final String open;
  final String close;
}

// ─── Category-specific detail tables ─────────────────────────────────────────

class VoyageDetails {
  const VoyageDetails({
    required this.establishmentId,
    required this.starRating,
    required this.propertyType,
    required this.checkInTime,
    required this.checkOutTime,
    required this.totalRooms,
    required this.amenities,
    required this.houseRules,
    required this.languagesSpoken,
    required this.cancellationPolicy,
  });

  final String establishmentId;
  final int starRating;
  final String propertyType;
  final String checkInTime;
  final String checkOutTime;
  final int totalRooms;
  final List<String> amenities;
  final Map<String, bool> houseRules;
  final List<String> languagesSpoken;
  final String cancellationPolicy;
}

class RestaurantDetails {
  const RestaurantDetails({
    required this.establishmentId,
    required this.cuisineType,
    required this.openingHours,
    required this.dressCode,
    required this.seatingOptions,
    required this.totalSeats,
    required this.averageMealDuration,
    required this.acceptsWalkins,
    required this.alcoholServed,
    required this.dietaryOptions,
    this.menuUrl,
    required this.cancellationPolicy,
  });

  final String establishmentId;
  final List<String> cuisineType;
  final Map<String, OpeningHours> openingHours;
  final String dressCode;
  final List<String> seatingOptions;
  final int totalSeats;
  final int averageMealDuration;
  final bool acceptsWalkins;
  final bool alcoholServed;
  final List<String> dietaryOptions;
  final String? menuUrl;
  final String cancellationPolicy;
}

class WellnessDetails {
  const WellnessDetails({
    required this.establishmentId,
    required this.spaType,
    required this.facilities,
    required this.openingHours,
    required this.therapistGenderAvailable,
    required this.coupleTreatments,
    required this.productsUsed,
    this.generalContraindications,
    required this.preparationTimeMinutes,
    required this.cancellationPolicy,
  });

  final String establishmentId;
  final String spaType;
  final List<String> facilities;
  final Map<String, OpeningHours> openingHours;
  final List<String> therapistGenderAvailable;
  final bool coupleTreatments;
  final List<String> productsUsed;
  final String? generalContraindications;
  final int preparationTimeMinutes;
  final String cancellationPolicy;
}

class DayPassDetails {
  const DayPassDetails({
    required this.establishmentId,
    required this.facilitiesIncluded,
    required this.openingHours,
    required this.kidsAllowed,
    required this.towelsProvided,
    required this.cancellationPolicy,
  });

  final String establishmentId;
  final List<String> facilitiesIncluded;
  final Map<String, OpeningHours> openingHours;
  final bool kidsAllowed;
  final bool towelsProvided;
  final String cancellationPolicy;
}

class SpectaclesDetails {
  const SpectaclesDetails({
    required this.establishmentId,
    required this.eventType,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.ageRestriction,
    required this.cancellationPolicy,
  });

  final String establishmentId;
  final String eventType;
  final String date;
  final String startTime;
  final String endTime;
  final String? ageRestriction;
  final String cancellationPolicy;
}

/// Shared shape for conciergerie / corporate / services experiences.
class ExperienceDetails {
  const ExperienceDetails({
    required this.establishmentId,
    required this.highlights,
    required this.highlightsFr,
    required this.bookingMode,
    this.openingHours,
    required this.availabilityNote,
    required this.availabilityNoteFr,
    required this.cancellationPolicy,
    this.minGroupSize,
    this.maxGroupSize,
    this.serviceArea,
  });

  final String establishmentId;
  final List<String> highlights;
  final List<String> highlightsFr;
  final String bookingMode;
  final Map<String, OpeningHours>? openingHours;
  final String availabilityNote;
  final String availabilityNoteFr;
  final String cancellationPolicy;
  final int? minGroupSize;
  final int? maxGroupSize;
  final List<String>? serviceArea;

  List<String> localizedHighlights(AppLanguage language) =>
      language.isFrench ? highlightsFr : highlights;
  String localizedAvailabilityNote(AppLanguage language) =>
      language.isFrench ? availabilityNoteFr : availabilityNote;
}

enum BookingStatus { pending, confirmed, cancelled, completed }

class BookingItem {
  const BookingItem({
    required this.id,
    required this.establishmentId,
    required this.establishmentName,
    required this.establishmentNameFr,
    required this.category,
    required this.slug,
    required this.serviceName,
    required this.serviceNameFr,
    required this.cityName,
    required this.cityNameFr,
    required this.address,
    required this.coverImage,
    required this.bookingDate,
    required this.startTime,
    required this.guestCount,
    required this.totalPriceMad,
    required this.status,
    required this.notes,
    required this.notesFr,
  });

  final String id;
  final String establishmentId;
  final String establishmentName;
  final String establishmentNameFr;
  final EstablishmentCategory category;
  final String slug;
  final String serviceName;
  final String serviceNameFr;
  final String cityName;
  final String cityNameFr;
  final String address;
  final String coverImage;
  final DateTime bookingDate;
  final String startTime;
  final int guestCount;
  final double totalPriceMad;
  final BookingStatus status;
  final String notes;
  final String notesFr;

  String localizedEstablishmentName(AppLanguage language) =>
      language.isFrench ? establishmentNameFr : establishmentName;
  String localizedServiceName(AppLanguage language) =>
      language.isFrench ? serviceNameFr : serviceName;
  String localizedCityName(AppLanguage language) =>
      language.isFrench ? cityNameFr : cityName;
  String localizedNotes(AppLanguage language) =>
      language.isFrench ? notesFr : notes;
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

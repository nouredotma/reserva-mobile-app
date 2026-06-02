import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/core/i18n/app_language.dart';

/// UI strings for the mobile app, mirroring the web app's bilingual copy.
class AppStrings {
  const AppStrings({
    // Navigation
    required this.navHome,
    required this.navSearch,
    required this.navBookings,
    required this.navAccount,
    // Home
    required this.homeCategoriesTitle,
    required this.homeCitiesTitle,
    required this.homeCitiesSubtitle,
    required this.homeFeaturedTitle,
    required this.homeHeroTagline,
    required this.homeSearchHint,
    required this.seeAll,
    required this.listings,
    // Search
    required this.searchTitle,
    required this.searchPlaceholder,
    required this.filters,
    required this.allCities,
    required this.allCategories,
    required this.allTypes,
    required this.allCuisines,
    required this.cuisine,
    required this.anyRating,
    required this.sortBy,
    required this.recommended,
    required this.highestRating,
    required this.priceLowHigh,
    required this.priceHighLow,
    required this.results,
    required this.result,
    required this.noResults,
    required this.noResultsHint,
    required this.clearFilters,
    required this.apply,
    required this.reset,
    required this.minimumRating,
    required this.category,
    required this.city,
    // Listing / detail
    required this.details,
    required this.reviewsLabel,
    required this.viewAllPhotos,
    required this.contact,
    required this.website,
    required this.startingFrom,
    required this.freeReservation,
    required this.cancellationPolicy,
    required this.location,
    required this.openInGoogleMaps,
    required this.roomTypes,
    required this.reservationOptions,
    required this.treatments,
    required this.amenities,
    required this.languages,
    required this.houseRules,
    required this.checkIn,
    required this.checkOut,
    required this.seats,
    required this.avgDuration,
    required this.walkIns,
    required this.seating,
    required this.dietaryOptions,
    required this.alcohol,
    required this.facilities,
    required this.productsUsed,
    required this.therapists,
    required this.couplesAvailable,
    required this.kidsAllowed,
    required this.adultsOnly,
    required this.towelsProvided,
    required this.facilitiesIncluded,
    required this.availability,
    required this.healthNotice,
    required this.yes,
    required this.no,
    required this.min,
    required this.free,
    required this.featured,
    required this.customerReviews,
    required this.verified,
    required this.noReviews,
    // Booking
    required this.bookNow,
    required this.requestBooking,
    required this.reserve,
    required this.total,
    required this.specialRequests,
    required this.optional,
    required this.onRequest,
    required this.bookingConfirmedTitle,
    required this.bookingConfirmedBody,
    // Account
    required this.account,
    required this.myBookings,
    required this.notifications,
    required this.language,
    required this.logIn,
    required this.logOut,
    required this.upcoming,
    required this.past,
    required this.guests,
    required this.date,
    required this.time,
    // Status
    required this.statusPending,
    required this.statusConfirmed,
    required this.statusCompleted,
    required this.statusCancelled,
    required this.loadError,
    required this.retry,
  });

  final String navHome;
  final String navSearch;
  final String navBookings;
  final String navAccount;

  final String homeCategoriesTitle;
  final String homeCitiesTitle;
  final String homeCitiesSubtitle;
  final String homeFeaturedTitle;
  final String homeHeroTagline;
  final String homeSearchHint;
  final String seeAll;
  final String listings;

  final String searchTitle;
  final String searchPlaceholder;
  final String filters;
  final String allCities;
  final String allCategories;
  final String allTypes;
  final String allCuisines;
  final String cuisine;
  final String anyRating;
  final String sortBy;
  final String recommended;
  final String highestRating;
  final String priceLowHigh;
  final String priceHighLow;
  final String results;
  final String result;
  final String noResults;
  final String noResultsHint;
  final String clearFilters;
  final String apply;
  final String reset;
  final String minimumRating;
  final String category;
  final String city;

  final String details;
  final String reviewsLabel;
  final String viewAllPhotos;
  final String contact;
  final String website;
  final String startingFrom;
  final String freeReservation;
  final String cancellationPolicy;
  final String location;
  final String openInGoogleMaps;
  final String roomTypes;
  final String reservationOptions;
  final String treatments;
  final String amenities;
  final String languages;
  final String houseRules;
  final String checkIn;
  final String checkOut;
  final String seats;
  final String avgDuration;
  final String walkIns;
  final String seating;
  final String dietaryOptions;
  final String alcohol;
  final String facilities;
  final String productsUsed;
  final String therapists;
  final String couplesAvailable;
  final String kidsAllowed;
  final String adultsOnly;
  final String towelsProvided;
  final String facilitiesIncluded;
  final String availability;
  final String healthNotice;
  final String yes;
  final String no;
  final String min;
  final String free;
  final String featured;
  final String customerReviews;
  final String verified;
  final String noReviews;

  final String bookNow;
  final String requestBooking;
  final String reserve;
  final String total;
  final String specialRequests;
  final String optional;
  final String onRequest;
  final String bookingConfirmedTitle;
  final String bookingConfirmedBody;

  final String account;
  final String myBookings;
  final String notifications;
  final String language;
  final String logIn;
  final String logOut;
  final String upcoming;
  final String past;
  final String guests;
  final String date;
  final String time;

  final String statusPending;
  final String statusConfirmed;
  final String statusCompleted;
  final String statusCancelled;
  final String loadError;
  final String retry;

  static const AppStrings en = AppStrings(
    navHome: 'Home',
    navSearch: 'Search',
    navBookings: 'Bookings',
    navAccount: 'Account',
    homeCategoriesTitle: 'Explore categories',
    homeCitiesTitle: 'Top destinations',
    homeCitiesSubtitle: 'Discover the best of Morocco',
    homeFeaturedTitle: 'Trending Destinations',
    homeHeroTagline: 'Reserva - One App, Endless Experiences',
    homeSearchHint: 'Search experiences, places...',
    seeAll: 'See all',
    listings: 'listings',
    searchTitle: 'Search',
    searchPlaceholder: 'Search by name or tag...',
    filters: 'Filters',
    allCities: 'All Cities',
    allCategories: 'All Categories',
    allTypes: 'All Types',
    allCuisines: 'All Cuisines',
    cuisine: 'Cuisine',
    anyRating: 'Any Rating',
    sortBy: 'Sort By',
    recommended: 'Recommended',
    highestRating: 'Highest Rating',
    priceLowHigh: 'Price: Low → High',
    priceHighLow: 'Price: High → Low',
    results: 'results',
    result: 'result',
    noResults: 'No results found',
    noResultsHint: 'Try adjusting your filters or search terms',
    clearFilters: 'Clear All Filters',
    apply: 'Apply',
    reset: 'Reset',
    minimumRating: 'Minimum Rating',
    category: 'Category',
    city: 'City',
    details: 'Details',
    reviewsLabel: 'reviews',
    viewAllPhotos: 'View all photos',
    contact: 'Contact',
    website: 'Website',
    startingFrom: 'Starting from',
    freeReservation: 'Free reservation',
    cancellationPolicy: 'Cancellation Policy',
    location: 'Location',
    openInGoogleMaps: 'Open in Google Maps',
    roomTypes: 'Room Types',
    reservationOptions: 'Reservation Options',
    treatments: 'Treatments',
    amenities: 'Amenities',
    languages: 'Languages',
    houseRules: 'House Rules',
    checkIn: 'Check-in',
    checkOut: 'Check-out',
    seats: 'Seats',
    avgDuration: 'Avg. Duration',
    walkIns: 'Walk-ins',
    seating: 'Seating',
    dietaryOptions: 'Dietary Options',
    alcohol: 'Alcohol Served',
    facilities: 'Facilities',
    productsUsed: 'Products Used',
    therapists: 'Therapists',
    couplesAvailable: 'Couples treatments available',
    kidsAllowed: 'Kids Allowed',
    adultsOnly: 'Adults Only',
    towelsProvided: 'Towels Provided',
    facilitiesIncluded: 'Facilities Included',
    availability: 'Availability',
    healthNotice: 'Health Notice',
    yes: 'Yes',
    no: 'No',
    min: 'min',
    free: 'Free',
    featured: 'Featured',
    customerReviews: 'Customer Reviews',
    verified: 'Verified',
    noReviews: 'No reviews yet. Be the first to share your experience!',
    bookNow: 'Book now',
    requestBooking: 'Request booking',
    reserve: 'Reserve',
    total: 'Total',
    specialRequests: 'Special requests',
    optional: 'Optional',
    onRequest: 'On request',
    bookingConfirmedTitle: 'Booking requested',
    bookingConfirmedBody: 'Your request has been sent. We will confirm shortly.',
    account: 'Account',
    myBookings: 'My Bookings',
    notifications: 'Notifications',
    language: 'Language',
    logIn: 'Log in',
    logOut: 'Log out',
    upcoming: 'Upcoming',
    past: 'Past',
    guests: 'Guests',
    date: 'Date',
    time: 'Time',
    statusPending: 'Pending',
    statusConfirmed: 'Confirmed',
    statusCompleted: 'Completed',
    statusCancelled: 'Cancelled',
    loadError: 'Something went wrong',
    retry: 'Retry',
  );

  static const AppStrings fr = AppStrings(
    navHome: 'Accueil',
    navSearch: 'Recherche',
    navBookings: 'Réservations',
    navAccount: 'Compte',
    homeCategoriesTitle: 'Explorer les catégories',
    homeCitiesTitle: 'Destinations phares',
    homeCitiesSubtitle: 'Découvrez le meilleur du Maroc',
    homeFeaturedTitle: 'Destinations Tendances',
    homeHeroTagline: 'Reserva - Une App, Experiences Sans Fin',
    homeSearchHint: 'Rechercher expériences, lieux...',
    seeAll: 'Voir tout',
    listings: 'établissements',
    searchTitle: 'Recherche',
    searchPlaceholder: 'Rechercher par nom ou tag...',
    filters: 'Filtres',
    allCities: 'Toutes les villes',
    allCategories: 'Toutes les catégories',
    allTypes: 'Tous les types',
    allCuisines: 'Toutes les cuisines',
    cuisine: 'Cuisine',
    anyRating: 'Toutes les notes',
    sortBy: 'Trier par',
    recommended: 'Recommandé',
    highestRating: 'Meilleures notes',
    priceLowHigh: 'Prix : Bas → Élevé',
    priceHighLow: 'Prix : Élevé → Bas',
    results: 'résultats',
    result: 'résultat',
    noResults: 'Aucun résultat trouvé',
    noResultsHint: 'Essayez d\'ajuster vos filtres ou termes de recherche',
    clearFilters: 'Effacer les filtres',
    apply: 'Appliquer',
    reset: 'Réinitialiser',
    minimumRating: 'Note minimale',
    category: 'Catégorie',
    city: 'Ville',
    details: 'Détails',
    reviewsLabel: 'avis',
    viewAllPhotos: 'Voir toutes les photos',
    contact: 'Contact',
    website: 'Site web',
    startingFrom: 'À partir de',
    freeReservation: 'Réservation gratuite',
    cancellationPolicy: 'Politique d\'annulation',
    location: 'Emplacement',
    openInGoogleMaps: 'Ouvrir dans Google Maps',
    roomTypes: 'Types de chambres',
    reservationOptions: 'Options de réservation',
    treatments: 'Soins',
    amenities: 'Équipements',
    languages: 'Langues',
    houseRules: 'Règlement intérieur',
    checkIn: 'Arrivée',
    checkOut: 'Départ',
    seats: 'Places',
    avgDuration: 'Durée moy.',
    walkIns: 'Sans réservation',
    seating: 'Installation',
    dietaryOptions: 'Options alimentaires',
    alcohol: 'Alcool servi',
    facilities: 'Installations',
    productsUsed: 'Produits utilisés',
    therapists: 'Thérapeutes',
    couplesAvailable: 'Soins en duo disponibles',
    kidsAllowed: 'Enfants autorisés',
    adultsOnly: 'Adultes uniquement',
    towelsProvided: 'Serviettes fournies',
    facilitiesIncluded: 'Installations incluses',
    availability: 'Disponibilité',
    healthNotice: 'Avis de santé',
    yes: 'Oui',
    no: 'Non',
    min: 'min',
    free: 'Gratuit',
    featured: 'À la une',
    customerReviews: 'Avis clients',
    verified: 'Vérifié',
    noReviews:
        'Aucun avis pour le moment. Soyez le premier à partager votre expérience !',
    bookNow: 'Réserver',
    requestBooking: 'Demander une réservation',
    reserve: 'Réserver',
    total: 'Total',
    specialRequests: 'Demandes spéciales',
    optional: 'Optionnel',
    onRequest: 'Sur demande',
    bookingConfirmedTitle: 'Réservation demandée',
    bookingConfirmedBody:
        'Votre demande a été envoyée. Nous confirmerons bientôt.',
    account: 'Compte',
    myBookings: 'Mes réservations',
    notifications: 'Notifications',
    language: 'Langue',
    logIn: 'Se connecter',
    logOut: 'Se déconnecter',
    upcoming: 'À venir',
    past: 'Passées',
    guests: 'Personnes',
    date: 'Date',
    time: 'Heure',
    statusPending: 'En attente',
    statusConfirmed: 'Confirmée',
    statusCompleted: 'Terminée',
    statusCancelled: 'Annulée',
    loadError: 'Une erreur est survenue',
    retry: 'Réessayer',
  );

  static AppStrings of(AppLanguage language) =>
      language.isFrench ? fr : en;
}

/// Convenience provider that exposes the active string table.
final stringsProvider = Provider<AppStrings>((ref) {
  return AppStrings.of(ref.watch(languageProvider));
});

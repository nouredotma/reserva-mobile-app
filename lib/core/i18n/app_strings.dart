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
    // Profile & misc
    required this.guest,
    required this.guestPrompt,
    required this.contactSupport,
    required this.openingHours,
    required this.noBookings,
    required this.loginToSeeBookings,
    required this.myProfile,
    required this.profilePageTitle,
    required this.profilePageDescription,
    required this.personalInfo,
    required this.updateDetails,
    required this.editProfile,
    required this.cancel,
    required this.saveChanges,
    required this.memberSince,
    required this.fullName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.namePlaceholder,
    required this.emailPlaceholder,
    required this.phonePlaceholder,
    required this.profileUpdated,
    required this.totalBookings,
    required this.reviewsWritten,
    required this.completedExperiences,
    required this.reviewTitle,
    required this.reviewContent,
    required this.submitReview,
    required this.loginToReview,
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

  final String guest;
  final String guestPrompt;
  final String contactSupport;
  final String openingHours;
  final String noBookings;
  final String loginToSeeBookings;
  final String myProfile;
  final String profilePageTitle;
  final String profilePageDescription;
  final String personalInfo;
  final String updateDetails;
  final String editProfile;
  final String cancel;
  final String saveChanges;
  final String memberSince;
  final String fullName;
  final String emailAddress;
  final String phoneNumber;
  final String namePlaceholder;
  final String emailPlaceholder;
  final String phonePlaceholder;
  final String profileUpdated;
  final String totalBookings;
  final String reviewsWritten;
  final String completedExperiences;
  final String reviewTitle;
  final String reviewContent;
  final String submitReview;
  final String loginToReview;

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
    guest: 'Guest',
    guestPrompt: 'Log in to manage your bookings',
    contactSupport: 'Contact Support',
    openingHours: 'Opening hours',
    noBookings: 'No bookings yet.',
    loginToSeeBookings: 'Log in to see your bookings.',
    myProfile: 'My Profile',
    profilePageTitle: 'My Profile',
    profilePageDescription:
        'Manage your personal information and account settings.',
    personalInfo: 'Personal Information',
    updateDetails: 'Update your name, email and contact details.',
    editProfile: 'Edit Profile',
    cancel: 'Cancel',
    saveChanges: 'Save Changes',
    memberSince: 'Member since May 2024',
    fullName: 'Full Name',
    emailAddress: 'Email Address',
    phoneNumber: 'Phone Number',
    namePlaceholder: 'Enter your full name',
    emailPlaceholder: 'Enter your email',
    phonePlaceholder: 'Enter your phone number',
    profileUpdated: 'Profile updated successfully',
    totalBookings: 'Total Bookings',
    reviewsWritten: 'Reviews Written',
    completedExperiences: 'Completed Experiences',
    reviewTitle: 'Title',
    reviewContent: 'Share your experience',
    submitReview: 'Submit',
    loginToReview: 'Log in to leave a review',
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
    homeFeaturedTitle: 'Destinations tendances',
    homeHeroTagline: 'Reserva - Une app, des expériences sans fin',
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
    guest: 'Invité',
    guestPrompt: 'Connectez-vous pour gérer vos réservations',
    contactSupport: 'Contacter le support',
    openingHours: 'Horaires',
    noBookings: 'Aucune réservation pour le moment.',
    loginToSeeBookings: 'Connectez-vous pour voir vos réservations.',
    myProfile: 'Mon profil',
    profilePageTitle: 'Mon profil',
    profilePageDescription:
        'Gérez vos informations personnelles et les paramètres de votre compte.',
    personalInfo: 'Informations personnelles',
    updateDetails: 'Mettez à jour votre nom, e-mail et coordonnées.',
    editProfile: 'Modifier le profil',
    cancel: 'Annuler',
    saveChanges: 'Enregistrer',
    memberSince: 'Membre depuis mai 2024',
    fullName: 'Nom complet',
    emailAddress: 'Adresse e-mail',
    phoneNumber: 'Numéro de téléphone',
    namePlaceholder: 'Entrez votre nom complet',
    emailPlaceholder: 'Entrez votre e-mail',
    phonePlaceholder: 'Entrez votre numéro de téléphone',
    profileUpdated: 'Profil mis à jour avec succès',
    totalBookings: 'Réservations totales',
    reviewsWritten: 'Avis rédigés',
    completedExperiences: 'Expériences terminées',
    reviewTitle: 'Titre',
    reviewContent: 'Partagez votre expérience',
    submitReview: 'Envoyer',
    loginToReview: 'Connectez-vous pour laisser un avis',
    statusPending: 'En attente',
    statusConfirmed: 'Confirmée',
    statusCompleted: 'Terminée',
    statusCancelled: 'Annulée',
    loadError: 'Une erreur est survenue',
    retry: 'Réessayer',
  );

  static const AppStrings es = AppStrings(
    navHome: 'Inicio',
    navSearch: 'Buscar',
    navBookings: 'Reservas',
    navAccount: 'Cuenta',
    homeCategoriesTitle: 'Explorar categorías',
    homeCitiesTitle: 'Destinos destacados',
    homeCitiesSubtitle: 'Descubre lo mejor de Marruecos',
    homeFeaturedTitle: 'Destinos en tendencia',
    homeHeroTagline: 'Reserva - Una app, experiencias infinitas',
    homeSearchHint: 'Buscar experiencias, lugares...',
    seeAll: 'Ver todo',
    listings: 'establecimientos',
    searchTitle: 'Buscar',
    searchPlaceholder: 'Buscar por nombre o etiqueta...',
    filters: 'Filtros',
    allCities: 'Todas las ciudades',
    allCategories: 'Todas las categorías',
    allTypes: 'Todos los tipos',
    allCuisines: 'Todas las cocinas',
    cuisine: 'Cocina',
    anyRating: 'Cualquier valoración',
    sortBy: 'Ordenar por',
    recommended: 'Recomendado',
    highestRating: 'Mejor valoración',
    priceLowHigh: 'Precio: Bajo → Alto',
    priceHighLow: 'Precio: Alto → Bajo',
    results: 'resultados',
    result: 'resultado',
    noResults: 'No se encontraron resultados',
    noResultsHint: 'Prueba ajustar tus filtros o términos de búsqueda',
    clearFilters: 'Borrar filtros',
    apply: 'Aplicar',
    reset: 'Restablecer',
    minimumRating: 'Valoración mínima',
    category: 'Categoría',
    city: 'Ciudad',
    details: 'Detalles',
    reviewsLabel: 'reseñas',
    viewAllPhotos: 'Ver todas las fotos',
    contact: 'Contacto',
    website: 'Sitio web',
    startingFrom: 'Desde',
    freeReservation: 'Reserva gratuita',
    cancellationPolicy: 'Política de cancelación',
    location: 'Ubicación',
    openInGoogleMaps: 'Abrir en Google Maps',
    roomTypes: 'Tipos de habitación',
    reservationOptions: 'Opciones de reserva',
    treatments: 'Tratamientos',
    amenities: 'Comodidades',
    languages: 'Idiomas',
    houseRules: 'Normas de la casa',
    checkIn: 'Entrada',
    checkOut: 'Salida',
    seats: 'Plazas',
    avgDuration: 'Duración media',
    walkIns: 'Sin reserva',
    seating: 'Asientos',
    dietaryOptions: 'Opciones dietéticas',
    alcohol: 'Se sirve alcohol',
    facilities: 'Instalaciones',
    productsUsed: 'Productos utilizados',
    therapists: 'Terapeutas',
    couplesAvailable: 'Tratamientos en pareja disponibles',
    kidsAllowed: 'Niños permitidos',
    adultsOnly: 'Solo adultos',
    towelsProvided: 'Toallas incluidas',
    facilitiesIncluded: 'Instalaciones incluidas',
    availability: 'Disponibilidad',
    healthNotice: 'Aviso de salud',
    yes: 'Sí',
    no: 'No',
    min: 'min',
    free: 'Gratis',
    featured: 'Destacado',
    customerReviews: 'Opiniones de clientes',
    verified: 'Verificado',
    noReviews:
        'Aún no hay reseñas. ¡Sé el primero en compartir tu experiencia!',
    bookNow: 'Reservar',
    requestBooking: 'Solicitar reserva',
    reserve: 'Reservar',
    total: 'Total',
    specialRequests: 'Peticiones especiales',
    optional: 'Opcional',
    onRequest: 'Bajo petición',
    bookingConfirmedTitle: 'Reserva solicitada',
    bookingConfirmedBody:
        'Tu solicitud ha sido enviada. Confirmaremos pronto.',
    account: 'Cuenta',
    myBookings: 'Mis reservas',
    notifications: 'Notificaciones',
    language: 'Idioma',
    logIn: 'Iniciar sesión',
    logOut: 'Cerrar sesión',
    upcoming: 'Próximas',
    past: 'Pasadas',
    guests: 'Personas',
    date: 'Fecha',
    time: 'Hora',
    guest: 'Invitado',
    guestPrompt: 'Inicia sesión para gestionar tus reservas',
    contactSupport: 'Contactar soporte',
    openingHours: 'Horario',
    noBookings: 'Aún no hay reservas.',
    loginToSeeBookings: 'Inicia sesión para ver tus reservas.',
    myProfile: 'Mi perfil',
    profilePageTitle: 'Mi perfil',
    profilePageDescription:
        'Gestiona tu información personal y la configuración de tu cuenta.',
    personalInfo: 'Información personal',
    updateDetails: 'Actualiza tu nombre, email y datos de contacto.',
    editProfile: 'Editar perfil',
    cancel: 'Cancelar',
    saveChanges: 'Guardar cambios',
    memberSince: 'Miembro desde mayo de 2024',
    fullName: 'Nombre completo',
    emailAddress: 'Correo electrónico',
    phoneNumber: 'Número de teléfono',
    namePlaceholder: 'Introduce tu nombre completo',
    emailPlaceholder: 'Introduce tu email',
    phonePlaceholder: 'Introduce tu número de teléfono',
    profileUpdated: 'Perfil actualizado correctamente',
    totalBookings: 'Reservas totales',
    reviewsWritten: 'Reseñas escritas',
    completedExperiences: 'Experiencias completadas',
    reviewTitle: 'Título',
    reviewContent: 'Comparte tu experiencia',
    submitReview: 'Enviar',
    loginToReview: 'Inicia sesión para dejar una reseña',
    statusPending: 'Pendiente',
    statusConfirmed: 'Confirmada',
    statusCompleted: 'Completada',
    statusCancelled: 'Cancelada',
    loadError: 'Algo salió mal',
    retry: 'Reintentar',
  );

  static const AppStrings ar = AppStrings(
    navHome: 'الرئيسية',
    navSearch: 'بحث',
    navBookings: 'الحجوزات',
    navAccount: 'الحساب',
    homeCategoriesTitle: 'استكشف الفئات',
    homeCitiesTitle: 'أفضل الوجهات',
    homeCitiesSubtitle: 'اكتشف أفضل ما في المغرب',
    homeFeaturedTitle: 'وجهات رائجة',
    homeHeroTagline: 'ريزيرفا - تطبيق واحد، تجارب لا حصر لها',
    homeSearchHint: 'ابحث عن تجارب وأماكن...',
    seeAll: 'عرض الكل',
    listings: 'منشآت',
    searchTitle: 'بحث',
    searchPlaceholder: 'ابحث بالاسم أو الوسم...',
    filters: 'فلاتر',
    allCities: 'جميع المدن',
    allCategories: 'جميع الفئات',
    allTypes: 'جميع الأنواع',
    allCuisines: 'جميع المطابخ',
    cuisine: 'المطبخ',
    anyRating: 'أي تقييم',
    sortBy: 'ترتيب حسب',
    recommended: 'موصى به',
    highestRating: 'أعلى تقييم',
    priceLowHigh: 'السعر: من الأقل إلى الأعلى',
    priceHighLow: 'السعر: من الأعلى إلى الأقل',
    results: 'نتائج',
    result: 'نتيجة',
    noResults: 'لم يتم العثور على نتائج',
    noResultsHint: 'جرّب تعديل الفلاتر أو كلمات البحث',
    clearFilters: 'مسح جميع الفلاتر',
    apply: 'تطبيق',
    reset: 'إعادة تعيين',
    minimumRating: 'الحد الأدنى للتقييم',
    category: 'الفئة',
    city: 'المدينة',
    details: 'التفاصيل',
    reviewsLabel: 'تقييمات',
    viewAllPhotos: 'عرض جميع الصور',
    contact: 'اتصال',
    website: 'الموقع',
    startingFrom: 'يبدأ من',
    freeReservation: 'حجز مجاني',
    cancellationPolicy: 'سياسة الإلغاء',
    location: 'الموقع',
    openInGoogleMaps: 'فتح في خرائط Google',
    roomTypes: 'أنواع الغرف',
    reservationOptions: 'خيارات الحجز',
    treatments: 'علاجات',
    amenities: 'وسائل الراحة',
    languages: 'اللغات',
    houseRules: 'قواعد المنزل',
    checkIn: 'تسجيل الوصول',
    checkOut: 'تسجيل المغادرة',
    seats: 'مقاعد',
    avgDuration: 'المدة المتوسطة',
    walkIns: 'بدون حجز',
    seating: 'جلوس',
    dietaryOptions: 'خيارات غذائية',
    alcohol: 'يُقدَّم الكحول',
    facilities: 'مرافق',
    productsUsed: 'المنتجات المستخدمة',
    therapists: 'معالجون',
    couplesAvailable: 'علاجات للأزواج متاحة',
    kidsAllowed: 'يُسمح بالأطفال',
    adultsOnly: 'للبالغين فقط',
    towelsProvided: 'مناشف متوفرة',
    facilitiesIncluded: 'المرافق مشمولة',
    availability: 'التوفر',
    healthNotice: 'تنبيه صحي',
    yes: 'نعم',
    no: 'لا',
    min: 'د',
    free: 'مجاني',
    featured: 'مميز',
    customerReviews: 'آراء العملاء',
    verified: 'موثّق',
    noReviews: 'لا توجد تقييمات بعد. كن أول من يشارك تجربته!',
    bookNow: 'احجز الآن',
    requestBooking: 'طلب حجز',
    reserve: 'احجز',
    total: 'الإجمالي',
    specialRequests: 'طلبات خاصة',
    optional: 'اختياري',
    onRequest: 'عند الطلب',
    bookingConfirmedTitle: 'تم طلب الحجز',
    bookingConfirmedBody: 'تم إرسال طلبك. سنؤكد قريباً.',
    account: 'الحساب',
    myBookings: 'حجوزاتي',
    notifications: 'الإشعارات',
    language: 'اللغة',
    logIn: 'تسجيل الدخول',
    logOut: 'تسجيل الخروج',
    upcoming: 'القادمة',
    past: 'السابقة',
    guests: 'الضيوف',
    date: 'التاريخ',
    time: 'الوقت',
    guest: 'زائر',
    guestPrompt: 'سجّل الدخول لإدارة حجوزاتك',
    contactSupport: 'اتصل بالدعم',
    openingHours: 'ساعات العمل',
    noBookings: 'لا توجد حجوزات بعد.',
    loginToSeeBookings: 'سجّل الدخول لعرض حجوزاتك.',
    myProfile: 'ملفي الشخصي',
    profilePageTitle: 'ملفي الشخصي',
    profilePageDescription: 'أدر معلوماتك الشخصية وإعدادات حسابك.',
    personalInfo: 'المعلومات الشخصية',
    updateDetails: 'حدّث اسمك وبريدك الإلكتروني وبيانات الاتصال.',
    editProfile: 'تعديل الملف',
    cancel: 'إلغاء',
    saveChanges: 'حفظ التغييرات',
    memberSince: 'عضو منذ مايو 2024',
    fullName: 'الاسم الكامل',
    emailAddress: 'البريد الإلكتروني',
    phoneNumber: 'رقم الهاتف',
    namePlaceholder: 'أدخل اسمك الكامل',
    emailPlaceholder: 'أدخل بريدك الإلكتروني',
    phonePlaceholder: 'أدخل رقم هاتفك',
    profileUpdated: 'تم تحديث الملف بنجاح',
    totalBookings: 'إجمالي الحجوزات',
    reviewsWritten: 'التقييمات المكتوبة',
    completedExperiences: 'التجارب المكتملة',
    reviewTitle: 'العنوان',
    reviewContent: 'شارك تجربتك',
    submitReview: 'إرسال',
    loginToReview: 'سجّل الدخول لكتابة تقييم',
    statusPending: 'قيد الانتظار',
    statusConfirmed: 'مؤكد',
    statusCompleted: 'مكتمل',
    statusCancelled: 'ملغى',
    loadError: 'حدث خطأ ما',
    retry: 'إعادة المحاولة',
  );

  static AppStrings of(AppLanguage language) => switch (language) {
    AppLanguage.fr => fr,
    AppLanguage.es => es,
    AppLanguage.ar => ar,
    AppLanguage.en => en,
  };
}

/// Convenience provider that exposes the active string table.
final stringsProvider = Provider<AppStrings>((ref) {
  return AppStrings.of(ref.watch(languageProvider));
});

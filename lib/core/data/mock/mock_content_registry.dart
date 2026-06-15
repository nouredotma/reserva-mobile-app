import 'package:reservamobile/core/data/mock/mock_content_registry_fr.dart';
import 'package:reservamobile/core/i18n/app_language.dart';

class LocalePair {
  const LocalePair({required this.es, required this.ar});
  final String es;
  final String ar;
}

abstract final class MockContentRegistry {
  static const Map<String, LocalePair> _strings = {
    // ─── Categories ──────────────────────────────────────────────────────────
    'cat.restaurants.label': LocalePair(
      es: 'Restaurantes',
      ar: 'مطاعم',
    ),
    'cat.restaurants.desc': LocalePair(
      es: 'Gastronomía, terrazas y mesas exclusivas',
      ar: 'تناول الطعام والأسطح والطاولات الحصرية',
    ),
    'cat.wellness.label': LocalePair(
      es: 'Bienestar y fitness',
      ar: 'العافية واللياقة',
    ),
    'cat.wellness.desc': LocalePair(
      es: 'Bienestar, belleza y coaching privado',
      ar: 'العافية والجمال والتدريب الخاص',
    ),
    'cat.day-passes.label': LocalePair(
      es: 'Pase de día',
      ar: 'تذكرة يومية',
    ),
    'cat.day-passes.desc': LocalePair(
      es: 'Piscinas, clubs y acceso de ocio',
      ar: 'المسابح والنوادي والوصول الترفيهي',
    ),
    'cat.spectacles.label': LocalePair(
      es: 'Entradas y espectáculos',
      ar: 'تذاكر وعروض',
    ),
    'cat.spectacles.desc': LocalePair(
      es: 'Teatro, conciertos, festivales y espectáculos culturales',
      ar: 'المسرح والحفلات والمهرجانات والعروض الثقافية',
    ),
    'cat.services.label': LocalePair(
      es: 'Servicios',
      ar: 'خدمات',
    ),
    'cat.services.desc': LocalePair(
      es: 'Hogar, estilo de vida y experiencias privadas',
      ar: 'المنزل ونمط الحياة والتجارب الخاصة',
    ),
    'cat.conciergerie.label': LocalePair(
      es: 'VIP y conserjería',
      ar: 'كبار الشخصيات والكونسيرج',
    ),
    'cat.conciergerie.desc': LocalePair(
      es: 'Acceso VIP y asistencia privada',
      ar: 'الوصول VIP والمساعدة الخاصة',
    ),
    'cat.voyage.label': LocalePair(
      es: 'Viajes',
      ar: 'سفر',
    ),
    'cat.voyage.desc': LocalePair(
      es: 'Vuelos, estancias y escapadas a medida',
      ar: 'الرحلات والإقامات والرحلات المخصصة',
    ),
    'cat.corporate.label': LocalePair(
      es: 'Empresas y B2B',
      ar: 'الشركات وB2B',
    ),
    'cat.corporate.desc': LocalePair(
      es: 'Comidas de equipo, eventos y beneficios para empleados',
      ar: 'وجبات الفريق والفعاليات ومزايا الموظفين',
    ),

    // ─── Subcategories ─────────────────────────────────────────────────────
    'sub.hair-salon.label': LocalePair(
      es: 'Peluquerías y barberías',
      ar: 'صالونات الحلاقة والحلاقين',
    ),
    'sub.manicure-pedicure.label': LocalePair(
      es: 'Manicura y pedicura',
      ar: 'العناية بالأظافر والقدمين',
    ),
    'sub.hammam-wellness.label': LocalePair(
      es: 'Hammam y rituales de bienestar',
      ar: 'الحمام وطقوس العافية',
    ),
    'sub.aesthetic-clinic.label': LocalePair(
      es: 'Clínicas estéticas y cuidado de la piel',
      ar: 'العيادات التجميلية والعناية بالبشرة',
    ),
    'sub.home-massage.label': LocalePair(
      es: 'Masaje a domicilio',
      ar: 'تدليك منزلي',
    ),
    'sub.personal-coach.label': LocalePair(
      es: 'Entrenadores personales y coaching privado',
      ar: 'المدربون الشخصيون والتدريب الخاص',
    ),
    'sub.gym.label': LocalePair(
      es: 'Gimnasio',
      ar: 'صالة رياضية',
    ),
    'sub.nutritionist.label': LocalePair(
      es: 'Consultas con nutricionistas',
      ar: 'استشارات التغذية',
    ),
    'sub.golf.label': LocalePair(
      es: 'Reserva de campos de golf',
      ar: 'حجز ملاعب الغولف',
    ),
    'sub.tennis-padel.label': LocalePair(
      es: 'Pistas de tenis y pádel',
      ar: 'ملاعب التنس والبادل',
    ),
    'sub.beach-club.label': LocalePair(
      es: 'Beach clubs',
      ar: 'نوادي الشاطئ',
    ),
    'sub.pool-day-pass.label': LocalePair(
      es: 'Pase de día en piscina',
      ar: 'تذكرة يومية للمسبح',
    ),
    'sub.kids-club.label': LocalePair(
      es: 'Club infantil y actividades familiares',
      ar: 'نادي الأطفال والأنشطة العائلية',
    ),
    'sub.private-villa.label': LocalePair(
      es: 'Experiencias en villas privadas',
      ar: 'تجارب الفيلات الخاصة',
    ),
    'sub.yacht-boat.label': LocalePair(
      es: 'Alquiler de yates y embarcaciones',
      ar: 'تأجير اليخوت والقوارب',
    ),
    'sub.bike-moto-quad.label': LocalePair(
      es: 'Alquiler de bicicletas, motos y quads',
      ar: 'تأجير الدراجات والدراجات النارية والكواد',
    ),
    'sub.desert-camp.label': LocalePair(
      es: 'Campamentos y excursiones en el desierto',
      ar: 'مخيمات ورحلات الصحراء',
    ),
    'sub.city-tour.label': LocalePair(
      es: 'Visitas guiadas por la ciudad',
      ar: 'جولات سياحية مرشدة',
    ),
    'sub.airport-fast-track.label': LocalePair(
      es: 'Fast-track en el aeropuerto',
      ar: 'المسار السريع في المطار',
    ),
    'sub.luxury-chauffeur.label': LocalePair(
      es: 'Chófer y vehículo de lujo',
      ar: 'سائق ومركبة فاخرة',
    ),
    'sub.private-jet.label': LocalePair(
      es: 'Jets privados y helicópteros',
      ar: 'الطائرات الخاصة والمروحيات',
    ),
    'sub.bodyguard.label': LocalePair(
      es: 'Guardaespaldas',
      ar: 'حارس شخصي',
    ),
    'sub.vip-nightlife.label': LocalePair(
      es: 'Mesas VIP en vida nocturna',
      ar: 'طاولات VIP في الحياة الليلية',
    ),
    'sub.chat-concierge.label': LocalePair(
      es: 'Servicio de conserjería por chat',
      ar: 'خدمة الكونسيرج عبر الدردشة',
    ),
    'sub.personal-shopper.label': LocalePair(
      es: 'Personal shopper',
      ar: 'مساعد تسوق شخصي',
    ),
    'sub.last-minute.label': LocalePair(
      es: 'Reservas de última hora',
      ar: 'حجوزات اللحظة الأخيرة',
    ),
    'sub.cinema.label': LocalePair(
      es: 'Entradas de cine',
      ar: 'تذاكر السينما',
    ),
    'sub.theatre-comedy.label': LocalePair(
      es: 'Teatro y espectáculos de comedia',
      ar: 'المسرح وعروض الكوميديا',
    ),
    'sub.festival-pass.label': LocalePair(
      es: 'Pases de festival',
      ar: 'تذاكر المهرجانات',
    ),
    'sub.museum-exhibition.label': LocalePair(
      es: 'Museos y exposiciones',
      ar: 'المتاحف والمعارض',
    ),
    'sub.escape-game.label': LocalePair(
      es: 'Escape rooms',
      ar: 'ألعاب الهروب',
    ),
    'sub.gaming-lounge.label': LocalePair(
      es: 'Salas de gaming',
      ar: 'صالات الألعاب',
    ),
    'sub.flights.label': LocalePair(
      es: 'Vuelos',
      ar: 'رحلات طيران',
    ),
    'sub.train.label': LocalePair(
      es: 'Billetes de tren',
      ar: 'تذاكر القطار',
    ),
    'sub.car-rental.label': LocalePair(
      es: 'Alquiler de coches',
      ar: 'تأجير السيارات',
    ),
    'sub.travel-insurance.label': LocalePair(
      es: 'Seguro de viaje',
      ar: 'تأمين السفر',
    ),
    'sub.weekend-getaway.label': LocalePair(
      es: 'Escapadas y estancias a medida',
      ar: 'عطلات نهاية الأسبوع والإقامات المخصصة',
    ),
    'sub.team-lunch.label': LocalePair(
      es: 'Reserva de almuerzos de equipo',
      ar: 'حجز غداء الفريق',
    ),
    'sub.corporate-wellness.label': LocalePair(
      es: 'Paquetes de bienestar corporativo',
      ar: 'باقات العافية للشركات',
    ),
    'sub.meeting-room.label': LocalePair(
      es: 'Reserva de salas de reuniones',
      ar: 'حجز قاعات الاجتماعات',
    ),
    'sub.corporate-event.label': LocalePair(
      es: 'Eventos corporativos',
      ar: 'الفعاليات المؤسسية',
    ),
    'sub.employee-perks.label': LocalePair(
      es: 'Marketplace de beneficios para empleados',
      ar: 'سوق مزايا الموظفين',
    ),
    'sub.cleaning.label': LocalePair(
      es: 'Servicios de limpieza',
      ar: 'خدمات التنظيف',
    ),
    'sub.pressing.label': LocalePair(
      es: 'Recogida y entrega de tintorería',
      ar: 'استلام وتسليم المكواة',
    ),
    'sub.private-chef.label': LocalePair(
      es: 'Experiencias con chef privado',
      ar: 'تجارب الطاهي الخاص',
    ),
    'sub.babysitting.label': LocalePair(
      es: 'Cuidado de niños',
      ar: 'رعاية الأطفال',
    ),
    'sub.pet-care.label': LocalePair(
      es: 'Peluquería y cuidado de mascotas',
      ar: 'العناية بالحيوانات الأليفة',
    ),
    'sub.chefs-table.label': LocalePair(
      es: 'Experiencias Chef\'s Table',
      ar: 'تجارب طاولة الشيف',
    ),
    'sub.exclusive-tasting.label': LocalePair(
      es: 'Menús degustación exclusivos',
      ar: 'قوائم تذوق حصرية',
    ),
    'sub.private-event.label': LocalePair(
      es: 'Eventos privados',
      ar: 'فعاليات خاصة',
    ),
    'sub.art-workshop.label': LocalePair(
      es: 'Talleres de arte',
      ar: 'ورش فنية',
    ),
    'sub.sunset-rooftop.label': LocalePair(
      es: 'Experiencias en azotea al atardecer',
      ar: 'تجارب الأسطح عند الغروب',
    ),
    'sub.brunch-cafe.label': LocalePair(
      es: 'Brunch y cafés',
      ar: 'البرانش والمقاهي',
    ),
    'sub.buffet.label': LocalePair(
      es: 'Buffets y todo lo que puedas comer',
      ar: 'البوفيهات وكل ما تشاء',
    ),
    'sub.fine-dining.label': LocalePair(
      es: 'Alta gastronomía',
      ar: 'المطاعم الفاخرة',
    ),
    'sub.rooftop-lounge.label': LocalePair(
      es: 'Azoteas y lounges',
      ar: 'الأسطح والصالات',
    ),
    'sub.chefs-table-dining.label': LocalePair(
      es: 'Chef\'s Table y cenas privadas',
      ar: 'طاولة الشيف والعشاء الخاص',
    ),
    'sub.tea-time.label': LocalePair(
      es: 'Hora del té y pastelería',
      ar: 'وقت الشاي والحلويات',
    ),
    'sub.family-restaurant.label': LocalePair(
      es: 'Restaurantes familiares',
      ar: 'مطاعم عائلية',
    ),
    'sub.romantic-restaurant.label': LocalePair(
      es: 'Restaurantes románticos',
      ar: 'مطاعم رومانسية',
    ),
    'sub.live-music-dining.label': LocalePair(
      es: 'Restaurantes con música en vivo',
      ar: 'مطاعم بموسيقى حية',
    ),
    'sub.karaoke.label': LocalePair(
      es: 'Salas de karaoke',
      ar: 'غرف الكاريوكي',
    ),
    'sub.tasting-menu.label': LocalePair(
      es: 'Menús degustación',
      ar: 'قوائم التذوق',
    ),
    'sub.event-dinner.label': LocalePair(
      es: 'Cenas de evento',
      ar: 'عشاء الفعاليات',
    ),
    'sub.vip-table.label': LocalePair(
      es: 'Mesas VIP',
      ar: 'طاولات VIP',
    ),
    'sub.exclusive-offers.label': LocalePair(
      es: 'Ofertas y experiencias exclusivas',
      ar: 'عروض وتجارب حصرية',
    ),

    // ─── Establishments: Hotels (h1–h5) ────────────────────────────────────
    'est.h1.short': LocalePair(
      es: 'Un icónico hotel palacio con riads privados, gastronomía de clase mundial y un spa suntuoso.',
      ar: 'فندق قصر أيقوني مع رياض خاصة ومطاعم عالمية وسبا فاخر.',
    ),
    'est.h1.full': LocalePair(
      es: 'En el corazón de Marrakech, Royal Mansour ofrece una experiencia de lujo sin igual con riads diseñados individualmente, restaurantes con estrellas Michelin y un amplio spa subterráneo.',
      ar: 'في قلب مراكش، يقدم رويال منصور تجربة فاخرة لا مثيل لها مع رياض مصممة بشكل فردي ومطاعم حاصلة على نجوم ميشلان وسبا واسع تحت الأرض.',
    ),
    'est.h2.short': LocalePair(
      es: 'Legendario hotel de lujo en amplios jardines en el corazón de Marrakech.',
      ar: 'فندق فاخر أسطوري في حدائق واسعة في قلب مراكش.',
    ),
    'est.h2.full': LocalePair(
      es: 'La Mamounia acoge a la realeza y las celebridades desde 1923. Con jardines exuberantes, múltiples restaurantes y un spa de renombre mundial, sigue siendo uno de los mejores hoteles de África.',
      ar: 'تستقبل لا مامونيا الملوك والمشاهير منذ عام 1923. بحدائقها الخضراء ومطاعمها المتعددة وسباها العالمي، تبقى من أرقى فنادق أفريقيا.',
    ),
    'est.h3.short': LocalePair(
      es: 'Lujo frente al océano con impresionantes vistas al Atlántico y un servicio impecable.',
      ar: 'فخامة على الواجهة البحرية مع إطلالات خلابة على الأطلسي وخدمة لا تشوبها شائبة.',
    ),
    'est.h3.full': LocalePair(
      es: 'Sobre la costa atlántica, Four Seasons Casablanca combina diseño contemporáneo y elegancia marroquí, con suites con vistas al océano y una impresionante piscina infinita.',
      ar: 'على ساحل المحيط الأطلسي، يمزج فور سيزونز الدار البيضاء بين التصميم المعاصر والأناقة المغربية، مع أجنحة بإطلالة على البحر ومسبح لا متناهي مذهل.',
    ),
    'est.h4.short': LocalePair(
      es: 'Refinado hotel de lujo francés en el corazón del distrito financiero de Casablanca.',
      ar: 'فندق فاخر فرنسي راقٍ في قلب الحي التجاري بالدار البيضاء.',
    ),
    'est.h4.full': LocalePair(
      es: 'Sofitel Casablanca Tour Blanche combina el arte de vivir francés con la hospitalidad marroquí, con un bar en la azotea y vistas panorámicas de la ciudad.',
      ar: 'يجمع سوفيتيل الدار البيضاء تور بلانش بين فن العيش الفرنسي والضيافة المغربية، مع بار على السطح وإطلالات بانورامية على المدينة.',
    ),
    'est.h5.short': LocalePair(
      es: 'Encantador riad boutique con una piscina espectacular y terraza en la azotea en la Medina.',
      ar: 'رياض بوتيك ساحر مع مسبح مذهل وتراس على السطح في المدينة القديمة.',
    ),
    'est.h5.full': LocalePair(
      es: 'Riad Yasmine es un riad boutique famoso en Instagram, escondido en los callejones de la Medina de Marrakech, conocido por su icónica piscina de azulejos.',
      ar: 'رياض ياسمين هو رياض بوتيك مشهور على إنستغرام، مخفي في أزقة المدينة القديمة بمراكش، معروف بمسبحه الأيقوني المزين بالبلاط.',
    ),

    // ─── Establishments: Restaurants (r1–r7) ───────────────────────────────
    'est.r1.short': LocalePair(
      es: 'Un oasis jardín escondido en la Medina con cocina marroquí e internacional refinada.',
      ar: 'واحة حديقة مخفية في المدينة القديمة تقدم مطبخاً مغربياً ودولياً راقياً.',
    ),
    'est.r1.full': LocalePair(
      es: 'Le Jardin está escondido en el corazón de la Medina, con un jardín tranquilo, platos marroquíes creativos y zumos frescos bajo plátanos.',
      ar: 'يقع لو جاردان في قلب المدينة القديمة، ويقدم إطاراً هادئاً في الحديقة مع أطباق مغربية إبداعية وعصائر طازجة تحت أشجار الموز.',
    ),
    'est.r2.short': LocalePair(
      es: 'Encantador restaurante en una fortificación histórica con desayuno marroquí tradicional y tagines.',
      ar: 'مطعم ساحر في تحصين تاريخي يقدم فطوراً مغربياً تقليدياً وطواجن.',
    ),
    'est.r2.full': LocalePair(
      es: 'Ubicado en los muros de una fortificación del siglo XVIII, La Sqala es famoso por su desayuno marroquí tradicional, tagines y patio ajardinado.',
      ar: 'يقع داخل أسوار تحصين من القرن الثامن عشر، ويشتهر لا سقالة بفطوره المغربي التقليدي وطواجنه وفناءه المزروع.',
    ),
    'est.r3.short': LocalePair(
      es: 'Cocina marroquí moderna con vistas panorámicas desde la azotea sobre la Medina.',
      ar: 'مطبخ مغربي عصري مع إطلالات بانورامية من السطح على المدينة القديمة.',
    ),
    'est.r3.full': LocalePair(
      es: 'Nomad redefine la cocina marroquí con un toque contemporáneo, servida en una impresionante terraza con vistas a los zocos de especias y el Atlas.',
      ar: 'يعيد نوماد تعريف المطبخ المغربي بلمسة معاصرة، يُقدَّم على تراس مذهل يطل على أسواق التوابل وجبال الأطلس.',
    ),
    'est.r4.short': LocalePair(
      es: 'Restaurante icónico inspirado en la película clásica, con fusión franco-marroquí en un entorno Art Déco.',
      ar: 'مطعم أيقوني مستوحى من الفيلم الكلاسيكي، يقدم مزيجاً فرنسياً مغربياً في إطار آرت ديكو.',
    ),
    'est.r4.full': LocalePair(
      es: 'Inspirado en la película Casablanca de 1942, Rick\'s Café es una joya Art Déco con piano en vivo, patio ajardinado y elegante cocina franco-marroquí.',
      ar: 'مستوحى من فيلم كازابلانكا عام 1942، ريكز كافيه جوهرة آرت ديكو مع بيانو حي وحديقة داخلية ومطبخ فرنسي مغربي أنيق.',
    ),
    'est.r5.short': LocalePair(
      es: 'Alta gastronomía contemporánea junto al mar con menús degustación creativos y amplia carta de vinos.',
      ar: 'مطعم فاخر معاصر على البحر مع قوائم تذوق مبتكرة وقائمة نبيذ واسعة.',
    ),
    'est.r5.full': LocalePair(
      es: 'Basmane ofrece una experiencia gastronómica refinada en la costa de Casablanca, con menús degustación de temporada que fusionan sabores marroquíes y técnicas internacionales.',
      ar: 'يقدم باسمان تجربة طعام راقية على ساحل الدار البيضاء، مع قوائم تذوق موسمية تمزج النكهات المغربية بالتقنيات العالمية.',
    ),
    'est.r6.short': LocalePair(
      es: 'Elegante experiencia gastronómica italiana en un oasis ajardinado en Marrakech.',
      ar: 'تجربة طعام إيطالية أنيقة في واحة حديقة بمراكش.',
    ),
    'est.r6.full': LocalePair(
      es: 'La Trattoria sirve auténtica cocina italiana en un entorno romántico impresionante, con mesas a la luz de las velas alrededor de una piscina encantadora en un patio elegante.',
      ar: 'تقدم لا تراتوريا مطبخاً إيطالياً أصيلاً في إطار رومانسي مذهل، مع طاولات مضاءة بالشموع حول مسبح ساحر في فناء أنيق.',
    ),
    'est.r7.short': LocalePair(
      es: 'Gastronomía japonesa premium y sushi a medida en el corazón de Casablanca.',
      ar: 'مطبخ ياباني فاخر وسوشي مخصص في قلب الدار البيضاء.',
    ),
    'est.r7.full': LocalePair(
      es: 'Le Comptoir du Sushi ofrece un viaje culinario inmersivo a Japón con sashimi fresco, rolls exclusivos y platos calientes preparados por maestros.',
      ar: 'يقدم لو كونتوار دو سوشي رحلة طهي غامرة إلى اليابان مع ساشيمي طازج ولفائف مميزة وأطباق ساخنة يعدها خبراء.',
    ),

    // ─── Establishments: Wellness (s1–s5) ────────────────────────────────────
    'est.s1.short': LocalePair(
      es: 'Auténtica experiencia de hammam en un edificio histórico restaurado en la Medina.',
      ar: 'تجربة حمام أصيلة في مبنى تاريخي مُرمَّم في المدينة القديمة.',
    ),
    'est.s1.full': LocalePair(
      es: 'Heritage Spa ofrece un recorrido por los rituales de baño marroquíes tradicionales en un riad del siglo XIV, con terapeutas expertos y productos orgánicos de argán.',
      ar: 'يقدم هيريتاج سبا رحلة عبر طقوس الاستحمام المغربية التقليدية في رياض من القرن الرابع عشر، مع معالجين خبراء ومنتجات أركان عضوية.',
    ),
    'est.s2.name': LocalePair(
      es: 'So Spa by Sofitel',
      ar: 'سو سبا باي سوفيتيل',
    ),
    'est.s2.short': LocalePair(
      es: 'Refugio urbano de lujo con tratamientos exclusivos y zona de relajación en la azotea.',
      ar: 'ملاذ حضري فاخر يقدم علاجات مميزة ومنطقة استرخاء على السطح.',
    ),
    'est.s2.full': LocalePair(
      es: 'So Spa by Sofitel combina la experiencia francesa en belleza con las tradiciones de bienestar marroquíes, con piscina climatizada, hammam y rituales de tratamiento a medida.',
      ar: 'يجمع سو سبا باي سوفيتيل بين خبرة الجمال الفرنسية وتقاليد العافية المغربية، مع مسبح مدفأ وحمام وطقوس علاج مخصصة.',
    ),
    'est.s3.short': LocalePair(
      es: 'Spa premium con rituales de hammam tradicionales y tratamientos de bienestar modernos.',
      ar: 'سبا فاخر يقدم طقوس الحمام التقليدية وعلاجات العافية الحديثة.',
    ),
    'est.s3.full': LocalePair(
      es: 'Les Bains de Marrakech es un santuario de bienestar en el barrio de la Kasbah, que fusiona tradiciones ancestrales del hammam con terapias de spa contemporáneas.',
      ar: 'لي بان دو مراكش هو ملاذ للعافية في حي القصبة، يمزج تقاليد الحمام العريقة بعلاجات السبا المعاصرة.',
    ),
    'est.s4.short': LocalePair(
      es: 'Centro de bienestar moderno con amplia gama de tratamientos faciales y corporales cerca de la Corniche.',
      ar: 'مركز عافية حديث مع مجموعة واسعة من علاجات الوجه والجسم قرب الكورنيش.',
    ),
    'est.s4.full': LocalePair(
      es: 'Nausikaa Spa es el destino de bienestar urbano de referencia en Casablanca, con tratamientos de vanguardia en un entorno contemporáneo a pocos pasos del océano.',
      ar: 'ناوسيكا سبا هو وجهة العافية الحضرية المرجعية في الدار البيضاء، مع علاجات متطورة في إطار عصري على خطوات من المحيط.',
    ),
    'est.s5.short': LocalePair(
      es: 'Spa de inspiración oriental con viajes multisensoriales únicos y tratamientos tradicionales.',
      ar: 'سبا مستوحى من الشرق يقدم رحلات حسية فريدة وعلاجات تقليدية.',
    ),
    'est.s5.full': LocalePair(
      es: 'Mythic Oriental Spa transporta a los huéspedes en un viaje multisensorial por antiguos rituales de bienestar oriental, con aceites esenciales raros y técnicas tradicionales.',
      ar: 'ينقل ميثيك أورينتال سبا الضيوف في رحلة حسية عبر طقوس العافية الشرقية القديمة، باستخدام زيوت عطرية نادرة وتقنيات تقليدية.',
    ),

    // ─── Establishments: Day passes (dp1–dp5) ────────────────────────────────
    'est.dp1.short': LocalePair(
      es: 'Beach club exclusivo con piscinas de lujo, sesiones de DJ y gastronomía gourmet.',
      ar: 'نادي شاطئ حصري مع مسابح فاخرة وعروض دي جي ومطاعم راقية.',
    ),
    'est.dp1.full': LocalePair(
      es: 'Vive la experiencia definitiva de pase de día de lujo en Nikki Beach. Disfruta de un ambiente vibrante, tumbonas premium y entretenimiento de clase mundial.',
      ar: 'عِش تجربة التذكرة اليومية الفاخرة النهائية في نيكي بيتش. استمتع بأجواء نابضة وكراسي استلقاء مميزة وترفيه عالمي المستوى.',
    ),
    'est.dp2.short': LocalePair(
      es: 'Histórico beach club en Casablanca con varias piscinas y acceso directo al océano.',
      ar: 'نادي شاطئ تاريخي في الدار البيضاء مع عدة مسابح ووصول مباشر للمحيط.',
    ),
    'est.dp2.full': LocalePair(
      es: 'Establecimiento legendario en Casablanca, Tahiti Beach Club ofrece un amplio espacio con varias piscinas, instalaciones deportivas y acceso directo a la playa.',
      ar: 'مؤسسة أسطورية في الدار البيضاء، يقدم تاهيتي بيتش كلوب مساحة واسعة مع عدة مسابح ومرافق رياضية ووصول مباشر للشاطئ.',
    ),
    'est.dp3.short': LocalePair(
      es: 'Enorme complejo de piscinas al aire libre con ambiente festivo a las afueras de Marrakech.',
      ar: 'مجمع مسابح ضخم في الهواء الطلق بأجواء احتفالية خارج مراكش.',
    ),
    'est.dp3.full': LocalePair(
      es: 'La Plage Rouge cuenta con una de las piscinas más grandes de África, con DJs en vivo, artistas y un ambiente animado perfecto para grupos.',
      ar: 'تضم لا بلاج روج واحدة من أكبر المسابح في أفريقيا، مع دي جي مباشر وفنانين وأجواء حيوية مثالية للمجموعات.',
    ),
    'est.dp4.short': LocalePair(
      es: 'Centro de fitness y piscina premium con impresionantes vistas a la Mezquita Hassan II.',
      ar: 'مركز لياقة ومسبح فاخر مع إطلالات مذهلة على مسجد الحسن الثاني.',
    ),
    'est.dp4.full': LocalePair(
      es: 'Combina entrenamiento y relajación en este club costero premium con piscina de agua de mar climatizada, gimnasio moderno y centro de bienestar.',
      ar: 'اجمع بين التمرين والاسترخاء في هذا النادي الساحلي الفاخر مع مسبح مياه بحر مدفأ وصالة رياضية حديثة ومركز عافية.',
    ),
    'est.dp5.name': LocalePair(
      es: 'Oasiria Parque Acuático',
      ar: 'أواسيريا بارك مائي',
    ),
    'est.dp5.short': LocalePair(
      es: 'Parque acuático familiar con piscina de olas, toboganes y jardines exuberantes.',
      ar: 'حديقة مائية عائلية مع مسبح أمواج ومنزلقات وحدائق خضراء.',
    ),
    'est.dp5.full': LocalePair(
      es: 'Perfecto para familias, Oasiria es el principal parque acuático de Marrakech, con hectáreas de jardines, numerosos toboganes y la piscina de olas más grande de África.',
      ar: 'مثالي للعائلات، أواسيريا هو الحديقة المائية الرائدة في مراكش، مع هكتارات من الحدائق ومنزلقات عديدة وأكبر مسبح أمواج في أفريقيا.',
    ),

    // ─── Establishments: Spectacles (ev1–ev5) ────────────────────────────────
    'est.ev1.name': LocalePair(
      es: 'Festival Oasis',
      ar: 'مهرجان أواسيس',
    ),
    'est.ev1.short': LocalePair(
      es: 'Festival de música electrónica en los bellos paisajes de Marrakech.',
      ar: 'مهرجان موسيقى إلكترونية في المناظر الطبيعية الخلابة لمراكش.',
    ),
    'est.ev1.full': LocalePair(
      es: 'Oasis Festival es una auténtica experiencia de música electrónica marroquí, con DJs internacionales, artes visuales impactantes y cultura vibrante.',
      ar: 'مهرجان أواسيس تجربة أصيلة للموسيقى الإلكترونية المغربية، مع دي جي دوليين وفنون بصرية مذهلة وثقافة نابضة.',
    ),
    'est.ev2.short': LocalePair(
      es: 'Festival internacional anual de jazz y música contemporánea en Casablanca.',
      ar: 'مهرجان دولي سنوي للجاز والموسيقى المعاصرة في الدار البيضاء.',
    ),
    'est.ev2.full': LocalePair(
      es: 'Jazzablanca reúne a artistas de jazz, soul, rock y pop de clase mundial para una celebración musical inolvidable de varios días en el corazón de Casablanca.',
      ar: 'يجمع جازابلانكا فنانين عالميين في الجاز والسول والروك والبوب لاحتفال موسيقي لا يُنسى على مدار عدة أيام في قلب الدار البيضاء.',
    ),
    'est.ev3.name': LocalePair(
      es: 'Festival de Cine de Marrakech',
      ar: 'مهرجان مراكش السينمائي',
    ),
    'est.ev3.short': LocalePair(
      es: 'Prestigioso festival internacional de cine que atrae a estrellas del cine mundial.',
      ar: 'مهرجان سينمائي دولي مرموق يجذب نجوم السينما العالمية.',
    ),
    'est.ev3.full': LocalePair(
      es: 'El Festival Internacional de Cine de Marrakech es un gran evento que rinde homenaje a lo mejor del cine mundial y marroquí, con proyecciones públicas en la plaza Jemaa el-Fnaa.',
      ar: 'مهرجان مراكش السينمائي الدولي حدث كبير يكرّم أفضل السينما العالمية والمغربية، مع عروض عامة في ساحة جامع الفنا.',
    ),
    'est.ev4.name': LocalePair(
      es: 'Feria de Arte Casa',
      ar: 'معرض فن الدار البيضاء',
    ),
    'est.ev4.short': LocalePair(
      es: 'Exposición de arte contemporáneo con galerías africanas e internacionales.',
      ar: 'معرض فن معاصر يعرض معارض أفريقية ودولية.',
    ),
    'est.ev4.full': LocalePair(
      es: 'Casa Art Fair es un evento cultural de primer nivel que reúne a coleccionistas, galerías y entusiastas para celebrar el arte contemporáneo en el norte de África.',
      ar: 'معرض فن الدار البيضاء حدث ثقافي رائد يجمع جامعي الفن والمعارض والهواة للاحتفال بالفن المعاصر في شمال أفريقيا.',
    ),
    'est.ev5.short': LocalePair(
      es: 'Festival underground de música electrónica y artes al pie del Atlas.',
      ar: 'مهرجان موسيقى إلكترونية وفنون تحت الأرض عند سفح الأطلس.',
    ),
    'est.ev5.full': LocalePair(
      es: 'Atlas Electronic es un festival vanguardista que fusiona música electrónica de vanguardia con actuaciones tradicionales marroquíes de Gnawa en un entorno eco-lodge.',
      ar: 'أطلس إلكترونيك مهرجان رائد يمزج الموسيقى الإلكترونية المتطورة مع عروض الجناوة المغربية التقليدية في إطار إيكو لودج.',
    ),

    // ─── Establishments: Concierge (vip1–vip2) ───────────────────────────────
    'est.vip1.short': LocalePair(
      es: 'Fast-track VIP en aeropuerto, chófer de lujo y reservas lifestyle de última hora.',
      ar: 'مسار سريع VIP في المطار وسائق فاخر وحجوزات نمط حياة في اللحظة الأخيرة.',
    ),
    'est.vip1.full': LocalePair(
      es: 'Atlas Elite Concierge coordina llegadas premium al aeropuerto, vehículos de lujo con chófer, seguridad privada y reservas difíciles de conseguir en Casablanca y Marrakech.',
      ar: 'ينسق أطلس إيليت كونسيرج وصولات المطار المميزة ومركبات فاخرة مع سائق وأمن خاص وحجوزات يصعب الحصول عليها في الدار البيضاء ومراكش.',
    ),
    'est.vip2.short': LocalePair(
      es: 'Mesas de nightlife, personal shopper, chóferes privados y conserjería por chat a medida.',
      ar: 'طاولات الحياة الليلية ومساعد تسوق وسائقون خاصون وكونسيرج عبر الدردشة.',
    ),
    'est.vip2.full': LocalePair(
      es: 'Un servicio de acceso privado para viajeros que necesitan mesas premium, citas de personal shopper, chóferes y soporte local disponible por chat.',
      ar: 'مكتب وصول خاص للمسافرين الذين يحتاجون طاولات مميزة ومواعيد تسوق وسائقين ودعماً محلياً متاحاً عبر الدردشة.',
    ),

    // ─── Establishments: Corporate (corp1–corp2) ─────────────────────────────
    'est.corp1.short': LocalePair(
      es: 'Salas de reuniones, almuerzos de equipo y paquetes de bienestar para empresas en crecimiento.',
      ar: 'قاعات اجتماعات وغداء الفريق وباقات عافية للشركات النامية.',
    ),
    'est.corp1.full': LocalePair(
      es: 'Workhaus Casablanca ofrece salas de reuniones reservables, almuerzos de equipo con catering y paquetes recurrentes de bienestar para equipos marroquíes modernos.',
      ar: 'يوفر وركهاوس الدار البيضاء قاعات اجتماعات قابلة للحجز وغداء فريق مع تموين وباقات عافية متكررة مصممة للفرق المغربية الحديثة.',
    ),
    'est.corp2.short': LocalePair(
      es: 'Retiros organizados, talleres ejecutivos y experiencias de beneficios para empleados.',
      ar: 'رحلات خارجية منظمة وورش تنفيذية وتجارب مزايا الموظفين.',
    ),
    'est.corp2.full': LocalePair(
      es: 'Marrakech Retreat Lab crea jornadas corporativas premium con espacios de reunión, cenas privadas, actividades y complementos de bienestar para equipos y directivos.',
      ar: 'يبني مراكش ريتريت لاب أياماً مؤسسية فاخرة مع مساحات اجتماعات وعشاء خاص وأنشطة وخيارات عافية للفرق ومجموعات القيادة.',
    ),

    // ─── Establishments: Services (svc1–svc2) ────────────────────────────────
    'est.svc1.short': LocalePair(
      es: 'Limpieza del hogar, recogida de tintorería, cuidado de niños y asistencia lifestyle diaria.',
      ar: 'تنظيف منزلي واستلام المكواة ورعاية الأطفال ودعم نمط الحياة اليومي.',
    ),
    'est.svc1.full': LocalePair(
      es: 'Maison Privee Services coordina servicios fiables de hogar y estilo de vida, incluyendo limpieza, recogida de ropa, cuidado infantil y de mascotas para hogares ocupados.',
      ar: 'تنسق ميزون بريفي سيرفيس خدمات منزلية ونمط حياة موثوقة، بما في ذلك التنظيف واستلام الغسيل ورعاية الأطفال والحيوانات الأليفة للأسر المشغولة.',
    ),
    'est.svc2.short': LocalePair(
      es: 'Cenas Chef\'s Table, talleres de arte, azoteas privadas y menús degustación.',
      ar: 'عشاء طاولة الشيف وورش فنية وأسطح خاصة وقوائم تذوق.',
    ),
    'est.svc2.full': LocalePair(
      es: 'Rooftop Atelier Marrakech crea experiencias lifestyle íntimas, desde cenas Chef\'s Table y azoteas al atardecer hasta talleres de arte y menús degustación privados.',
      ar: 'يصنع روفتوب أتيليه مراكش تجارب نمط حياة حميمة، من طاولة الشيف وأسطح الغروب إلى ورش الفن وقوائم التذوق الخاصة.',
    ),

    // ─── Service items ─────────────────────────────────────────────────────
    'svc.sv-h1-1.name': LocalePair(
      es: 'Riad clásico',
      ar: 'رياض كلاسيكي',
    ),
    'svc.sv-h1-1.short': LocalePair(
      es: 'Un riad privado de un dormitorio con patio, piscina pequeña y solárium en la azotea.',
      ar: 'رياض خاص بغرفة نوم واحدة مع فناء ومسبح صغير وتراس شمسي على السطح.',
    ),
    'svc.sv-h1-2.name': LocalePair(
      es: 'Gran riad',
      ar: 'رياض كبير',
    ),
    'svc.sv-h1-2.short': LocalePair(
      es: 'Un espacioso riad de tres dormitorios con piscina privada, servicio de mayordomo y terraza en la azotea.',
      ar: 'رياض واسع بثلاث غرف نوم مع مسبح خاص وخدمة كبير وتراس على السطح.',
    ),
    'svc.sv-h2-1.name': LocalePair(
      es: 'Habitación superior',
      ar: 'غرفة سوبيريور',
    ),
    'svc.sv-h2-1.short': LocalePair(
      es: 'Elegante habitación con vistas a los jardines, cama king y baño de mármol.',
      ar: 'غرفة أنيقة تطل على الحدائق مع سرير كينغ وحمام رخامي.',
    ),
    'svc.sv-h2-2.name': LocalePair(
      es: 'Suite orientale',
      ar: 'جناح أورينتال',
    ),
    'svc.sv-h2-2.short': LocalePair(
      es: 'Lujosa suite con decoración marroquí, salón independiente y vistas al jardín.',
      ar: 'جناح فاخر بديكور مغربي وصالة منفصلة وإطلالة على الحديقة.',
    ),
    'svc.sv-h3-1.name': LocalePair(
      es: 'Habitación deluxe',
      ar: 'غرفة ديلوكس',
    ),
    'svc.sv-h3-1.short': LocalePair(
      es: 'Habitación contemporánea con vistas al océano, baño de mármol y comodidades premium.',
      ar: 'غرفة معاصرة بإطلالة على المحيط وحمام رخامي ووسائل راحة فاخرة.',
    ),
    'svc.sv-h3-2.name': LocalePair(
      es: 'Suite océano',
      ar: 'جناح المحيط',
    ),
    'svc.sv-h3-2.short': LocalePair(
      es: 'Amplia suite con vistas panorámicas al Atlántico, salón y servicio de mayordomo.',
      ar: 'جناح واسع بإطلالات بانورامية على الأطلسي وصالة وخدمة كبير.',
    ),
    'svc.sv-h4-1.name': LocalePair(
      es: 'Habitación clásica',
      ar: 'غرفة كلاسيكية',
    ),
    'svc.sv-h4-1.short': LocalePair(
      es: 'Habitación refinada con vistas a la ciudad y la ropa de cama distintiva de Sofitel.',
      ar: 'غرفة راقية بإطلالة على المدينة وفراش سوفيتيل المميز.',
    ),
    'svc.sv-h4-2.name': LocalePair(
      es: 'Suite prestige',
      ar: 'جناح برستيج',
    ),
    'svc.sv-h4-2.short': LocalePair(
      es: 'Generosa suite con salón independiente y vistas panorámicas del skyline de Casablanca.',
      ar: 'جناح واسع بصالة منفصلة وإطلالات بانورامية على أفق الدار البيضاء.',
    ),
    'svc.sv-h5-1.name': LocalePair(
      es: 'Habitación estándar',
      ar: 'غرفة قياسية',
    ),
    'svc.sv-h5-1.short': LocalePair(
      es: 'Acogedora habitación con decoración marroquí tradicional y vistas al patio.',
      ar: 'غرفة مريحة بديكور مغربي تقليدي وإطلالة على الفناء.',
    ),
    'svc.sv-h5-2.name': LocalePair(
      es: 'Suite con terraza',
      ar: 'جناح مع تراس',
    ),
    'svc.sv-h5-2.short': LocalePair(
      es: 'Amplia suite con terraza privada con vistas a los tejados de la medina.',
      ar: 'جناح واسع مع تراس خاص يطل على أسطح المدينة القديمة.',
    ),
    'svc.sv-r1-1.name': LocalePair(
      es: 'Reserva de mesa',
      ar: 'حجز طاولة',
    ),
    'svc.sv-r1-1.short': LocalePair(
      es: 'Reserva una mesa en el exuberante patio jardín.',
      ar: 'احجز طاولة في الفناء الحدائقي الخضراء.',
    ),
    'svc.sv-r1-2.name': LocalePair(
      es: 'Cena privada en el jardín',
      ar: 'عشاء خاص في الحديقة',
    ),
    'svc.sv-r1-2.short': LocalePair(
      es: 'Experiencia exclusiva de cena privada en el jardín para hasta 8 invitados.',
      ar: 'تجربة عشاء خاصة حصرية في الحديقة لما يصل إلى 8 ضيوف.',
    ),
    'svc.sv-r2-1.name': LocalePair(
      es: 'Reserva de mesa',
      ar: 'حجز طاولة',
    ),
    'svc.sv-r2-1.short': LocalePair(
      es: 'Reserva una mesa en el histórico patio jardín.',
      ar: 'احجز طاولة في الفناء الحدائقي التاريخي.',
    ),
    'svc.sv-r3-1.name': LocalePair(
      es: 'Reserva de mesa',
      ar: 'حجز طاولة',
    ),
    'svc.sv-r3-1.short': LocalePair(
      es: 'Reserva una mesa en la azotea con vistas a la medina.',
      ar: 'احجز طاولة على السطح مع إطلالة على المدينة القديمة.',
    ),
    'svc.sv-r3-2.name': LocalePair(
      es: 'Evento privado en azotea',
      ar: 'فعالية خاصة على السطح',
    ),
    'svc.sv-r3-2.short': LocalePair(
      es: 'Espacio privado para eventos en azotea para hasta 20 invitados.',
      ar: 'مساحة فعاليات خاصة على السطح لما يصل إلى 20 ضيفاً.',
    ),
    'svc.sv-r4-1.name': LocalePair(
      es: 'Reserva para cena',
      ar: 'حجز عشاء',
    ),
    'svc.sv-r4-1.short': LocalePair(
      es: 'Reserva una mesa en el icónico comedor Art Déco.',
      ar: 'احجز طاولة في قاعة الطعام الأيقونية بأسلوب آرت ديكو.',
    ),
    'svc.sv-r5-1.name': LocalePair(
      es: 'Reserva para cena',
      ar: 'حجز عشاء',
    ),
    'svc.sv-r5-1.short': LocalePair(
      es: 'Reserva una mesa con vistas al océano para alta gastronomía.',
      ar: 'احجز طاولة بإطلالة على البحر لتناول طعام فاخر.',
    ),
    'svc.sv-r5-2.name': LocalePair(
      es: 'Menú degustación',
      ar: 'قائمة تذوق',
    ),
    'svc.sv-r5-2.short': LocalePair(
      es: 'Menú degustación de varios platos de temporada con maridaje de vinos.',
      ar: 'قائمة تذوق متعددة الأطباق موسمية مع تنسيق النبيذ.',
    ),
    'svc.sv-r6-1.name': LocalePair(
      es: 'Reserva de mesa',
      ar: 'حجز طاولة',
    ),
    'svc.sv-r6-1.short': LocalePair(
      es: 'Reserva una mesa a la luz de las velas junto a la piscina.',
      ar: 'احجز طاولة مضاءة بالشموع بجانب المسبح.',
    ),
    'svc.sv-r7-1.name': LocalePair(
      es: 'Reserva de mesa',
      ar: 'حجز طاولة',
    ),
    'svc.sv-r7-1.short': LocalePair(
      es: 'Reserva un mostrador de sushi o una mesa de comedor.',
      ar: 'احجز مقعداً في بار السوشي أو طاولة طعام.',
    ),
    'svc.sv-s1-1.name': LocalePair(
      es: 'Hammam tradicional',
      ar: 'حمام تقليدي',
    ),
    'svc.sv-s1-1.short': LocalePair(
      es: 'Auténtico ritual de hammam con exfoliación con jabón negro y envoltura de rhassoul.',
      ar: 'طقس حمام أصيل مع تقشير بصابون أسود ولفافة راسول.',
    ),
    'svc.sv-s1-2.name': LocalePair(
      es: 'Paquete hammam real',
      ar: 'باقة الحمام الملكية',
    ),
    'svc.sv-s1-2.short': LocalePair(
      es: 'Experiencia completa de hammam con masaje, facial y ceremonia del té.',
      ar: 'تجربة حمام كاملة مع تدليك وعلاج للوجه وحفل الشاي.',
    ),
    'svc.sv-s2-1.name': LocalePair(
      es: 'Masaje signature',
      ar: 'تدليك مميز',
    ),
    'svc.sv-s2-1.short': LocalePair(
      es: 'Masaje a medida de 60 minutos con aceites premium.',
      ar: 'تدليك مخصص لمدة 60 دقيقة بزيوت فاخرة.',
    ),
    'svc.sv-s2-2.name': LocalePair(
      es: 'Facial de lujo',
      ar: 'علاج وجه فاخر',
    ),
    'svc.sv-s2-2.short': LocalePair(
      es: 'Tratamiento facial rejuvenecedor con productos de cuidado de la piel franceses.',
      ar: 'علاج وجه منعش بمنتجات العناية بالبشرة الفرنسية.',
    ),
    'svc.sv-s3-1.name': LocalePair(
      es: 'Hammam y gommage',
      ar: 'حمام وتقشير',
    ),
    'svc.sv-s3-1.short': LocalePair(
      es: 'Hammam tradicional con exfoliación corporal completa y masaje con aceite de argán.',
      ar: 'حمام تقليدي مع تقشير كامل للجسم وتدليك بزيت الأركان.',
    ),
    'svc.sv-s3-2.name': LocalePair(
      es: 'Paquete spa día completo',
      ar: 'باقة سبا ليوم كامل',
    ),
    'svc.sv-s3-2.short': LocalePair(
      es: 'Día completo de spa con hammam, masaje, facial y almuerzo.',
      ar: 'يوم سبا كامل مع حمام وتدليك وعلاج للوجه وغداء.',
    ),
    'svc.sv-s4-1.name': LocalePair(
      es: 'Masaje sueco',
      ar: 'تدليك سويدي',
    ),
    'svc.sv-s4-1.short': LocalePair(
      es: 'Masaje clásico de relajación con aceites aromáticos.',
      ar: 'تدليك استرخاء كلاسيكي بزيوت عطرية.',
    ),
    'svc.sv-s4-2.name': LocalePair(
      es: 'Masaje de tejido profundo',
      ar: 'تدليك الأنسجة العميقة',
    ),
    'svc.sv-s4-2.short': LocalePair(
      es: 'Masaje terapéutico de tejido profundo para aliviar la tensión muscular.',
      ar: 'تدليك علاجي للأنسجة العميقة لتخفيف توتر العضلات.',
    ),
    'svc.sv-s5-1.name': LocalePair(
      es: 'Masaje oriental',
      ar: 'تدليك شرقي',
    ),
    'svc.sv-s5-1.short': LocalePair(
      es: 'Masaje oriental tradicional con aceites esenciales calientes.',
      ar: 'تدليك شرقي تقليدي بزيوت عطرية دافئة.',
    ),
    'svc.sv-s5-2.name': LocalePair(
      es: 'Viaje de aromaterapia',
      ar: 'رحلة العلاج بالروائح',
    ),
    'svc.sv-s5-2.short': LocalePair(
      es: 'Tratamiento multisensorial de aromaterapia con mezclas de aceites personalizadas.',
      ar: 'علاج حسي متعدد بالروائح مع مزيج زيوت مخصص.',
    ),
    'svc.dp1-s1.name': LocalePair(
      es: 'Pase de día estándar',
      ar: 'تذكرة يومية قياسية',
    ),
    'svc.dp1-s1.short': LocalePair(
      es: 'Acceso de día completo a piscinas, tumbonas e instalaciones del beach club.',
      ar: 'وصول ليوم كامل إلى المسابح وكراسي الاستلقاء ومرافق نادي الشاطئ.',
    ),
    'svc.dp2-s1.name': LocalePair(
      es: 'Pase de acceso a la playa',
      ar: 'تذكرة الوصول للشاطئ',
    ),
    'svc.dp2-s1.short': LocalePair(
      es: 'Pase de día con acceso a piscina, playa e instalaciones deportivas.',
      ar: 'تذكرة يومية مع وصول للمسبح والشاطئ والمرافق الرياضية.',
    ),
    'svc.dp3-s1.name': LocalePair(
      es: 'Pase fiesta en piscina',
      ar: 'تذكرة حفلة المسبح',
    ),
    'svc.dp3-s1.short': LocalePair(
      es: 'Pase de día con acceso a la piscina y entretenimiento con DJ.',
      ar: 'تذكرة يومية تشمل الوصول للمسبح وترفيه دي جي.',
    ),
    'svc.dp4-s1.name': LocalePair(
      es: 'Pase de día wellness',
      ar: 'تذكرة يوم العافية',
    ),
    'svc.dp4-s1.short': LocalePair(
      es: 'Gimnasio, piscina climatizada e instalaciones de spa durante un día completo.',
      ar: 'صالة رياضية ومسبح مدفأ ومرافق سبا ليوم كامل.',
    ),
    'svc.dp5-s1.name': LocalePair(
      es: 'Entrada al parque acuático',
      ar: 'دخول الحديقة المائية',
    ),
    'svc.dp5-s1.short': LocalePair(
      es: 'Acceso de día completo a todos los toboganes acuáticos y la piscina de olas.',
      ar: 'وصول ليوم كامل لجميع المنزلقات المائية ومسبح الأمواج.',
    ),
    'svc.ev1-s1.name': LocalePair(
      es: 'Entrada general',
      ar: 'دخول عام',
    ),
    'svc.ev1-s1.short': LocalePair(
      es: 'Pase de festival de un día con acceso a todos los escenarios.',
      ar: 'تذكرة مهرجان ليوم واحد مع وصول لجميع المسرحات.',
    ),
    'svc.ev2-s1.name': LocalePair(
      es: 'Pase día 1',
      ar: 'تذكرة اليوم الأول',
    ),
    'svc.ev2-s1.short': LocalePair(
      es: 'Acceso a todas las actuaciones y escenarios del día 1.',
      ar: 'وصول لجميع عروض ومسرحات اليوم الأول.',
    ),
    'svc.ev3-s1.name': LocalePair(
      es: 'Entrada noche de apertura',
      ar: 'تذكرة ليلة الافتتاح',
    ),
    'svc.ev3-s1.short': LocalePair(
      es: 'Proyección de gala en la alfombra roja de la noche de apertura.',
      ar: 'عرض افتتاح على السجادة الحمراء وحفل الافتتاح.',
    ),
    'svc.ev4-s1.name': LocalePair(
      es: 'Vista previa VIP',
      ar: 'معاينة VIP',
    ),
    'svc.ev4-s1.short': LocalePair(
      es: 'Acceso exclusivo de vista previa antes de la apertura al público.',
      ar: 'وصول حصري للمعاينة قبل الافتتاح العام.',
    ),
    'svc.ev5-s1.name': LocalePair(
      es: 'Pase de fin de semana',
      ar: 'تذكرة نهاية الأسبوع',
    ),
    'svc.ev5-s1.short': LocalePair(
      es: 'Acceso completo de fin de semana a todas las actuaciones del festival.',
      ar: 'وصول كامل لعطلة نهاية الأسبوع لجميع عروض المهرجان.',
    ),
    'svc.vip1-s1.name': LocalePair(
      es: 'Fast-track en aeropuerto',
      ar: 'المسار السريع في المطار',
    ),
    'svc.vip1-s1.short': LocalePair(
      es: 'Llegada prioritaria al aeropuerto con asistencia fast-track en inmigración.',
      ar: 'وصول أولوي للمطار مع مساعدة المسار السريع في الجوازات.',
    ),
    'svc.vip1-s2.name': LocalePair(
      es: 'Chófer de lujo',
      ar: 'سائق فاخر',
    ),
    'svc.vip1-s2.short': LocalePair(
      es: 'Chófer privado con vehículo de lujo durante 4 horas.',
      ar: 'سائق خاص مع مركبة فاخرة لمدة 4 ساعات.',
    ),
    'svc.vip2-s1.name': LocalePair(
      es: 'Mesa VIP nightlife',
      ar: 'طاولة VIP للحياة الليلية',
    ),
    'svc.vip2-s1.short': LocalePair(
      es: 'Mesa VIP reservada en locales premium de vida nocturna.',
      ar: 'طاولة VIP محجوزة في أرقى أماكن الحياة الليلية.',
    ),
    'svc.corp1-s1.name': LocalePair(
      es: 'Sala de reuniones media jornada',
      ar: 'قاعة اجتماعات نصف يوم',
    ),
    'svc.corp1-s1.short': LocalePair(
      es: 'Alquiler de sala de reuniones por media jornada con equipos AV y café.',
      ar: 'إيجار قاعة اجتماعات لنصف يوم مع معدات سمعية بصرية وقهوة.',
    ),
    'svc.corp1-s2.name': LocalePair(
      es: 'Pack almuerzo de equipo',
      ar: 'باقة غداء الفريق',
    ),
    'svc.corp1-s2.short': LocalePair(
      es: 'Almuerzo de equipo con catering para hasta 15 personas.',
      ar: 'غداء فريق مع تموين لما يصل إلى 15 شخصاً.',
    ),
    'svc.corp2-s1.name': LocalePair(
      es: 'Día offsite ejecutivo',
      ar: 'يوم خارجي تنفيذي',
    ),
    'svc.corp2-s1.short': LocalePair(
      es: 'Offsite de día completo con espacio de reuniones y actividades curadas.',
      ar: 'يوم خارجي كامل مع مساحة اجتماعات وأنشطة منظمة.',
    ),
    'svc.svc1-s1.name': LocalePair(
      es: 'Visita de limpieza del hogar',
      ar: 'زيارة تنظيف منزلي',
    ),
    'svc.svc1-s1.short': LocalePair(
      es: 'Servicio profesional de limpieza del hogar de hasta 3 horas.',
      ar: 'خدمة تنظيف منزلي احترافية لمدة تصل إلى 3 ساعات.',
    ),
    'svc.svc1-s2.name': LocalePair(
      es: 'Recogida de tintorería',
      ar: 'استلام المكواة',
    ),
    'svc.svc1-s2.short': LocalePair(
      es: 'Recogida y entrega de ropa en 24 horas.',
      ar: 'استلام وتسليم الغسيل خلال 24 ساعة.',
    ),
    'svc.svc2-s1.name': LocalePair(
      es: 'Cena Chef\'s Table',
      ar: 'عشاء طاولة الشيف',
    ),
    'svc.svc2-s1.short': LocalePair(
      es: 'Íntima cena Chef\'s Table para hasta 6 invitados.',
      ar: 'عشاء حميم على طاولة الشيف لما يصل إلى 6 ضيوف.',
    ),

    // ─── Bookings ────────────────────────────────────────────────────────────
    'booking.bk-2026-001.service': LocalePair(
      es: 'Reserva para cena',
      ar: 'حجز عشاء',
    ),
    'booking.bk-2026-001.notes': LocalePair(
      es: 'Se prefiere mesa en el jardín.',
      ar: 'يُفضَّل طاولة في الحديقة.',
    ),
    'booking.bk-2026-002.service': LocalePair(
      es: 'Suite prestige',
      ar: 'جناح برستيج',
    ),
    'booking.bk-2026-002.notes': LocalePair(
      es: 'Se solicitó llegada tardía.',
      ar: 'طُلب وصول متأخر.',
    ),
    'booking.bk-2026-003.service': LocalePair(
      es: 'Ritual de hammam y masaje',
      ar: 'طقس الحمام والتدليك',
    ),
    'booking.bk-2026-003.notes': LocalePair(
      es: '',
      ar: '',
    ),

    // ─── Cities ──────────────────────────────────────────────────────────────
    'city.Marrakesh.name': LocalePair(
      es: 'Marrakech',
      ar: 'مراكش',
    ),
    'city.Casablanca.name': LocalePair(
      es: 'Casablanca',
      ar: 'الدار البيضاء',
    ),
  };

  static String? resolve(String key, AppLanguage language) {
    final LocalePair? pair = _strings[key];
    if (pair == null && language != AppLanguage.fr) return null;
    return switch (language) {
      AppLanguage.es => pair?.es,
      AppLanguage.ar => pair?.ar,
      AppLanguage.fr => MockContentRegistryFr.strings[key],
      AppLanguage.en => null,
    };
  }
}

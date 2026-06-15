import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/core/i18n/app_language.dart';

/// Home footer copy aligned with the Reserva web `footer.tsx`.
class FooterStrings {
  const FooterStrings({
    required this.description,
    required this.legal,
    required this.partner,
    required this.contact,
    required this.privacy,
    required this.terms,
    required this.cookie,
    required this.becomeHost,
    required this.partnerLogin,
    required this.rights,
    required this.createdBy,
    required this.address,
  });

  final String description;
  final String legal;
  final String partner;
  final String contact;
  final String privacy;
  final String terms;
  final String cookie;
  final String becomeHost;
  final String partnerLogin;
  final String rights;
  final String createdBy;
  final String address;

  static const String phoneNumber = '+212 704 749 027';

  static FooterStrings of(AppLanguage language) => switch (language) {
    AppLanguage.fr => _fr,
    AppLanguage.es => _es,
    AppLanguage.ar => _ar,
    AppLanguage.en => _en,
  };

  static const FooterStrings _en = FooterStrings(
    description:
        'Reserva is a premier super app for lifestyle bookings, from restaurants and wellness to travel, leisure, concierge, and corporate experiences.',
    legal: 'Legal',
    partner: 'Partner',
    contact: 'Contact Us',
    privacy: 'Privacy Policy',
    terms: 'Terms & Conditions',
    cookie: 'Cookie Policy',
    becomeHost: 'Become a host',
    partnerLogin: 'Partner Login',
    rights: 'All rights reserved.',
    createdBy: 'Created by',
    address: 'Marrakesh, Morocco',
  );

  static const FooterStrings _fr = FooterStrings(
    description:
        'Reserva est une super application lifestyle pour réserver restaurants, bien-être, voyage, loisirs, conciergerie et expériences corporate.',
    legal: 'Légal',
    partner: 'Partenaire',
    contact: 'Contactez-nous',
    privacy: 'Politique de confidentialité',
    terms: 'Conditions générales',
    cookie: 'Politique des cookies',
    becomeHost: 'Devenir hôte',
    partnerLogin: 'Connexion partenaire',
    rights: 'Tous droits réservés.',
    createdBy: 'Créé par',
    address: 'Marrakech, Maroc',
  );

  static const FooterStrings _es = FooterStrings(
    description:
        'Reserva es una superapp lifestyle para reservar restaurantes, bienestar, viajes, ocio, conserjería y experiencias corporativas.',
    legal: 'Legal',
    partner: 'Socio',
    contact: 'Contáctanos',
    privacy: 'Política de privacidad',
    terms: 'Términos y condiciones',
    cookie: 'Política de cookies',
    becomeHost: 'Conviértete en anfitrión',
    partnerLogin: 'Acceso socios',
    rights: 'Todos los derechos reservados.',
    createdBy: 'Creado por',
    address: 'Marrakech, Marruecos',
  );

  static const FooterStrings _ar = FooterStrings(
    description:
        'ريزيرفا هي تطبيق شامل مميز لحجوزات نمط الحياة، من المطاعم والعافية إلى السفر والترفيه والكونسيرج والتجارب المؤسسية.',
    legal: 'قانوني',
    partner: 'شريك',
    contact: 'اتصل بنا',
    privacy: 'سياسة الخصوصية',
    terms: 'الشروط والأحكام',
    cookie: 'سياسة ملفات تعريف الارتباط',
    becomeHost: 'كن مضيفاً',
    partnerLogin: 'دخول الشركاء',
    rights: 'جميع الحقوق محفوظة.',
    createdBy: 'أنشئ بواسطة',
    address: 'مراكش، المغرب',
  );
}

/// External links opened from the home footer.
abstract final class FooterUrls {
  static const String siteBase = 'https://reserva.ma';
  static const String privacy = 'https://reserva.ma/privacy-policy';
  static const String terms = 'https://reserva.ma/terms-and-conditions';
  static const String cookie = 'https://reserva.ma/cookie-policy';
  static const String becomeHost = 'https://reserva.ma/become-host';
  static const String partnerLogin = 'https://reserva-back-office.vercel.app/';
}

final footerStringsProvider = Provider<FooterStrings>((ref) {
  return FooterStrings.of(ref.watch(languageProvider));
});

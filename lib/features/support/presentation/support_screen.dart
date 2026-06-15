import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reservamobile/app/theme/app_colors.dart';
import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:reservamobile/core/i18n/app_strings.dart';
import 'package:reservamobile/core/i18n/localized_value.dart';
import 'package:reservamobile/core/widgets/app_scaffold.dart';
import 'package:reservamobile/core/widgets/ui_kit.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings t = ref.watch(stringsProvider);
    final AppLanguage lang = ref.watch(languageProvider);
    String s({required String en, required String fr, required String es, required String ar}) =>
        localizedPick(lang, en: en, fr: fr, es: es, ar: ar);

    return AppScaffold(
      title: t.contactSupport,
      padding: const EdgeInsets.fromLTRB(
        kScreenPaddingHorizontal,
        6,
        kScreenPaddingHorizontal,
        40,
      ),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FDF8),
            borderRadius: BorderRadius.circular(kRadiusSm),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                s(
                  en: 'Need help?',
                  fr: 'Besoin d\'aide ?',
                  es: '¿Necesitas ayuda?',
                  ar: 'هل تحتاج مساعدة؟',
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF15803D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                s(
                  en: 'Contact our support team and we will get back to you quickly.',
                  fr: 'Contactez notre équipe support et nous vous répondrons rapidement.',
                  es: 'Contacta a nuestro equipo de soporte y te responderemos pronto.',
                  ar: 'تواصل مع فريق الدعم وسنرد عليك بسرعة.',
                ),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF15803D),
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  _ContactChip(
                    icon: Icons.email_outlined,
                    label: 'contact@reserva.ma',
                    onTap: () => _launch('mailto:contact@reserva.ma'),
                  ),
                  _ContactChip(
                    icon: Icons.call_outlined,
                    label: '+212 704 749 027',
                    onTap: () => _launch('tel:+212704749027'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameCtrl,
                      decoration: _dec(
                        s(en: 'First name *', fr: 'Prénom *', es: 'Nombre *', ar: 'الاسم الأول *'),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameCtrl,
                      decoration: _dec(s(en: 'Last name', fr: 'Nom', es: 'Apellido', ar: 'اسم العائلة')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: _dec('Email *'),
                validator: (v) => (v == null || !v.contains('@')) ? 'Invalid email' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: _dec(s(en: 'Phone', fr: 'Téléphone', es: 'Teléfono', ar: 'الهاتف')),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _subjectCtrl,
                decoration: _dec(s(en: 'Subject', fr: 'Sujet', es: 'Asunto', ar: 'الموضوع')),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _messageCtrl,
                minLines: 4,
                maxLines: 6,
                decoration: _dec(s(en: 'Message *', fr: 'Message *', es: 'Mensaje *', ar: 'الرسالة *')).copyWith(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kRadiusSm),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: _sending ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.textPrimary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  _sending
                      ? s(en: 'Sending...', fr: 'Envoi...', es: 'Enviando...', ar: 'جارٍ الإرسال...')
                      : s(en: 'Send message', fr: 'Envoyer le message', es: 'Enviar mensaje', ar: 'إرسال الرسالة'),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _openWhatsApp,
                icon: SvgPicture.asset(
                  'assets/images/whatsapp.svg',
                  width: 16,
                  height: 16,
                ),
                label: Text(
                  s(
                    en: 'Contact on WhatsApp',
                    fr: 'Contacter sur WhatsApp',
                    es: 'Contactar por WhatsApp',
                    ar: 'التواصل عبر واتساب',
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF16A34A),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0FDF4),
                  side: const BorderSide(color: Color(0xFF86EFAC)),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kRadiusSm),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _dec(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFF9CA3AF),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Future<void> _launch(String raw) async {
    final uri = Uri.parse(raw);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openWhatsApp() async {
    final msg = Uri.encodeComponent(_messageCtrl.text.trim().isEmpty ? 'Hello Reserva support' : _messageCtrl.text.trim());
    await _launch('https://wa.me/212704749027?text=$msg');
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() => _sending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message sent successfully')),
    );
    _firstNameCtrl.clear();
    _lastNameCtrl.clear();
    _emailCtrl.clear();
    _phoneCtrl.clear();
    _subjectCtrl.clear();
    _messageCtrl.clear();
  }
}

class _ContactChip extends StatelessWidget {
  const _ContactChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kRadiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(kRadiusSm),
          border: Border.all(color: const Color(0xFF86EFAC)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 14, color: const Color(0xFF15803D)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF15803D),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

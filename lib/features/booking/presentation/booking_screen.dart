import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/app/theme/app_colors.dart';
import 'package:reservamobile/core/auth/auth_session_controller.dart';
import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:reservamobile/core/i18n/app_strings.dart';
import 'package:reservamobile/core/i18n/labels.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/providers/reserva_providers.dart';
import 'package:reservamobile/core/widgets/app_scaffold.dart';
import 'package:reservamobile/core/widgets/ui_kit.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({
    super.key,
    required this.establishmentId,
    this.initialServiceId,
  });

  final String establishmentId;
  final String? initialServiceId;

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  DateTime? _checkOutDate;
  String _time = '19:30';
  int _guests = 2;
  String _notes = '';
  String? _serviceId;
  bool _saving = false;

  // Category-specific state.
  String _seating = 'indoor';
  String _occasion = '';
  String _dietary = '';
  String _therapist = 'no_preference';
  bool _contraindications = false;
  bool _needTowels = false;
  int _kids = 0;
  String _flightNumber = '';
  String _pickupLocation = '';
  String _companyName = '';
  int _teamSize = 8;
  String _serviceAddress = '';

  static const List<String> _timeSlots = <String>[
    '09:00', '10:30', '12:00', '13:30', '15:00', '16:30', '18:00', '19:30', '21:00',
  ];

  double _total(ServiceItem service) {
    const multiplyTypes = <String>{'ticket', 'day_pass', 'team_lunch'};
    if (multiplyTypes.contains(service.serviceType)) {
      return service.price * _guests;
    }
    return service.price;
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings t = ref.watch(stringsProvider);
    final AppLanguage lang = ref.watch(languageProvider);
    final estAsync = ref.watch(establishmentByIdProvider(widget.establishmentId));
    final servicesAsync = ref.watch(servicesProvider(widget.establishmentId));

    return estAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('$err'))),
      data: (establishment) {
        if (establishment == null) {
          return Scaffold(appBar: AppBar(), body: const Center(child: Text('Not found')));
        }
        return servicesAsync.when(
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (err, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('$err'))),
          data: (services) {
            if (services.isEmpty) {
              return AppScaffold(
                title: establishment.localizedName(lang),
                body: const Center(child: Text('No services available')),
              );
            }
            _serviceId ??= widget.initialServiceId ?? services.first.id;
            final ServiceItem service = services.firstWhere(
              (s) => s.id == _serviceId,
              orElse: () => services.first,
            );
            if (_guests < service.minPeople) _guests = service.minPeople;
            if (_guests > service.maxPeople) _guests = service.maxPeople;

            return _buildForm(context, t, lang, establishment, services, service);
          },
        );
      },
    );
  }

  Widget _buildForm(
    BuildContext context,
    AppStrings t,
    AppLanguage lang,
    Establishment establishment,
    List<ServiceItem> services,
    ServiceItem service,
  ) {
    return AppScaffold(
      title: establishment.localizedName(lang),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
      children: <Widget>[
        // Service selection
        Text(t.reservationOptions,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        ...services.map((s) => _ServiceOption(
              service: s,
              selected: s.id == _serviceId,
              lang: lang,
              t: t,
              onTap: () => setState(() => _serviceId = s.id),
            )),
        const SizedBox(height: 20),

        // Date
        _FieldLabel(label: t.date),
        _PickerTile(
          icon: Icons.calendar_today_outlined,
          label: _formatDate(_date),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _date,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) setState(() => _date = picked);
          },
        ),
        const SizedBox(height: 16),

        // Time
        _FieldLabel(label: t.time),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _timeSlots
              .map((slot) => _Selectable(
                    label: slot,
                    selected: _time == slot,
                    onTap: () => setState(() => _time = slot),
                  ))
              .toList(growable: false),
        ),
        const SizedBox(height: 16),

        // Guests stepper
        _FieldLabel(label: t.guests),
        _Stepper(
          value: _guests,
          min: service.minPeople,
          max: service.maxPeople,
          onChanged: (v) => setState(() => _guests = v),
        ),
        const SizedBox(height: 20),

        // Category-specific fields
        _CategoryFields(
          category: establishment.category,
          t: t,
          checkOutDate: _checkOutDate,
          onPickCheckOut: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _date.add(const Duration(days: 1)),
              firstDate: _date.add(const Duration(days: 1)),
              lastDate: _date.add(const Duration(days: 365)),
            );
            if (picked != null) setState(() => _checkOutDate = picked);
          },
          seating: _seating,
          onSeating: (v) => setState(() => _seating = v),
          occasion: _occasion,
          onOccasion: (v) => _occasion = v,
          dietary: _dietary,
          onDietary: (v) => _dietary = v,
          therapist: _therapist,
          onTherapist: (v) => setState(() => _therapist = v),
          contraindications: _contraindications,
          onContraindications: (v) => setState(() => _contraindications = v),
          needTowels: _needTowels,
          onNeedTowels: (v) => setState(() => _needTowels = v),
          kids: _kids,
          onKids: (v) => _kids = v,
          flightNumber: _flightNumber,
          onFlightNumber: (v) => _flightNumber = v,
          pickupLocation: _pickupLocation,
          onPickupLocation: (v) => _pickupLocation = v,
          companyName: _companyName,
          onCompanyName: (v) => _companyName = v,
          teamSize: _teamSize,
          onTeamSize: (v) => _teamSize = v,
          serviceAddress: _serviceAddress,
          onServiceAddress: (v) => _serviceAddress = v,
        ),

        // Special requests
        _FieldLabel(label: '${t.specialRequests} (${t.optional})'),
        TextField(
          maxLines: 3,
          decoration: _inputDecoration(t.specialRequests),
          onChanged: (v) => _notes = v.trim(),
        ),
        const SizedBox(height: 24),

        // Total + submit
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(kRadius),
          ),
          child: Row(
            children: <Widget>[
              Text(t.total, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                service.price > 0 ? formatMad(_total(service), currency: service.currency) : t.onRequest,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _saving ? null : () => _submit(context, t, establishment, service),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textPrimary,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
          child: Text(
            service.instantBooking ? t.reserve : t.requestBooking,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Future<void> _submit(
    BuildContext context,
    AppStrings t,
    Establishment establishment,
    ServiceItem service,
  ) async {
    final authState = ref.read(authSessionProvider);
    if (!authState.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.logIn)));
      context.push(AppRoute.login);
      return;
    }
    setState(() => _saving = true);
    await ref.read(reservaRepositoryProvider).createBooking(
          establishment: establishment,
          service: service,
          bookingDate: _date,
          startTime: _time,
          guestCount: _guests,
          totalPriceMad: _total(service),
          notes: _composeNotes(establishment.category),
        );
    ref.invalidate(userBookingsProvider);
    if (!context.mounted) return;
    setState(() => _saving = false);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(t.bookingConfirmedTitle),
        content: Text(t.bookingConfirmedBody),
        actions: <Widget>[
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (context.mounted) context.pop();
  }

  String _composeNotes(EstablishmentCategory category) {
    final parts = <String>[if (_notes.isNotEmpty) _notes];
    switch (category) {
      case EstablishmentCategory.restaurants:
        if (_occasion.isNotEmpty) parts.add('occasion=$_occasion');
        if (_dietary.isNotEmpty) parts.add('dietary=$_dietary');
        parts.add('seating=$_seating');
      case EstablishmentCategory.wellness:
        parts.add('therapist=$_therapist');
        parts.add('contraindications=$_contraindications');
      case EstablishmentCategory.voyage:
        if (_checkOutDate != null) parts.add('checkout=${_formatDate(_checkOutDate!)}');
      case EstablishmentCategory.dayPasses:
        parts.add('need_towels=$_needTowels');
        parts.add('kids=$_kids');
      case EstablishmentCategory.conciergerie:
        if (_pickupLocation.isNotEmpty) parts.add('pickup=$_pickupLocation');
        if (_flightNumber.isNotEmpty) parts.add('flight=$_flightNumber');
      case EstablishmentCategory.corporate:
        if (_companyName.isNotEmpty) parts.add('company=$_companyName');
        parts.add('team_size=$_teamSize');
      case EstablishmentCategory.services:
        if (_serviceAddress.isNotEmpty) parts.add('service_address=$_serviceAddress');
      case EstablishmentCategory.spectacles:
        parts.add('event_time=$_time');
    }
    return parts.where((p) => p.trim().isNotEmpty).join(' | ');
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

InputDecoration _inputDecoration(String hint) => InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadius),
        borderSide: BorderSide.none,
      ),
    );

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
      );
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 18, color: AppColors.textPrimary),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _Selectable extends StatelessWidget {
  const _Selectable({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _RoundIcon(icon: Icons.remove, enabled: value > min, onTap: () => onChanged(value - 1)),
          Text('$value', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          _RoundIcon(icon: Icons.add, enabled: value < max, onTap: () => onChanged(value + 1)),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.enabled, required this.onTap});
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: enabled ? AppColors.textPrimary : const Color(0xFFE0E0E0),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}

class _ServiceOption extends StatelessWidget {
  const _ServiceOption({
    required this.service,
    required this.selected,
    required this.lang,
    required this.t,
    required this.onTap,
  });
  final ServiceItem service;
  final bool selected;
  final AppLanguage lang;
  final AppStrings t;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(kRadius),
          border: Border.all(
            color: selected ? AppColors.textPrimary : const Color(0xFFE5E5E5),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.textPrimary : const Color(0xFFBDBDBD),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(service.localizedName(lang),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                    service.localizedShortDescription(lang),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF737373)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              service.price > 0 ? formatMad(service.price, currency: service.currency) : t.free,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

/// Per-category extra fields, mirroring the web booking forms.
class _CategoryFields extends StatelessWidget {
  const _CategoryFields({
    required this.category,
    required this.t,
    required this.checkOutDate,
    required this.onPickCheckOut,
    required this.seating,
    required this.onSeating,
    required this.occasion,
    required this.onOccasion,
    required this.dietary,
    required this.onDietary,
    required this.therapist,
    required this.onTherapist,
    required this.contraindications,
    required this.onContraindications,
    required this.needTowels,
    required this.onNeedTowels,
    required this.kids,
    required this.onKids,
    required this.flightNumber,
    required this.onFlightNumber,
    required this.pickupLocation,
    required this.onPickupLocation,
    required this.companyName,
    required this.onCompanyName,
    required this.teamSize,
    required this.onTeamSize,
    required this.serviceAddress,
    required this.onServiceAddress,
  });

  final EstablishmentCategory category;
  final AppStrings t;
  final DateTime? checkOutDate;
  final VoidCallback onPickCheckOut;
  final String seating;
  final ValueChanged<String> onSeating;
  final String occasion;
  final ValueChanged<String> onOccasion;
  final String dietary;
  final ValueChanged<String> onDietary;
  final String therapist;
  final ValueChanged<String> onTherapist;
  final bool contraindications;
  final ValueChanged<bool> onContraindications;
  final bool needTowels;
  final ValueChanged<bool> onNeedTowels;
  final int kids;
  final ValueChanged<int> onKids;
  final String flightNumber;
  final ValueChanged<String> onFlightNumber;
  final String pickupLocation;
  final ValueChanged<String> onPickupLocation;
  final String companyName;
  final ValueChanged<String> onCompanyName;
  final int teamSize;
  final ValueChanged<int> onTeamSize;
  final String serviceAddress;
  final ValueChanged<String> onServiceAddress;

  @override
  Widget build(BuildContext context) {
    final List<Widget> fields = <Widget>[];
    switch (category) {
      case EstablishmentCategory.voyage:
        fields
          ..add(_FieldLabel(label: t.checkOut))
          ..add(_PickerTile(
            icon: Icons.calendar_today_outlined,
            label: checkOutDate == null
                ? t.date
                : '${checkOutDate!.year}-${checkOutDate!.month.toString().padLeft(2, '0')}-${checkOutDate!.day.toString().padLeft(2, '0')}',
            onTap: onPickCheckOut,
          ));
      case EstablishmentCategory.restaurants:
        fields
          ..add(_FieldLabel(label: t.seating))
          ..add(Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final option in const <String>['indoor', 'outdoor', 'rooftop', 'terrace'])
                _Selectable(
                  label: prettyToken(option),
                  selected: seating == option,
                  onTap: () => onSeating(option),
                ),
            ],
          ))
          ..add(const SizedBox(height: 16))
          ..add(TextField(
            decoration: _inputDecoration('Occasion'),
            onChanged: onOccasion,
          ))
          ..add(const SizedBox(height: 12))
          ..add(TextField(
            decoration: _inputDecoration(t.dietaryOptions),
            onChanged: onDietary,
          ));
      case EstablishmentCategory.wellness:
        fields
          ..add(_FieldLabel(label: t.therapists))
          ..add(Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final option in const <String>['no_preference', 'female', 'male'])
                _Selectable(
                  label: prettyToken(option),
                  selected: therapist == option,
                  onTap: () => onTherapist(option),
                ),
            ],
          ))
          ..add(_CheckRow(
            label: t.healthNotice,
            value: contraindications,
            onChanged: onContraindications,
          ));
      case EstablishmentCategory.dayPasses:
        fields
          ..add(_CheckRow(label: t.towelsProvided, value: needTowels, onChanged: onNeedTowels))
          ..add(_FieldLabel(label: t.kidsAllowed))
          ..add(_Stepper(value: kids, min: 0, max: 10, onChanged: onKids));
      case EstablishmentCategory.conciergerie:
        fields
          ..add(_FieldLabel(label: 'Pickup'))
          ..add(TextField(decoration: _inputDecoration('Pickup location'), onChanged: onPickupLocation))
          ..add(const SizedBox(height: 12))
          ..add(TextField(decoration: _inputDecoration('Flight number'), onChanged: onFlightNumber));
      case EstablishmentCategory.corporate:
        fields
          ..add(_FieldLabel(label: 'Company'))
          ..add(TextField(decoration: _inputDecoration('Company name'), onChanged: onCompanyName))
          ..add(const SizedBox(height: 16))
          ..add(_FieldLabel(label: 'Team size'))
          ..add(_Stepper(value: teamSize, min: 2, max: 40, onChanged: onTeamSize));
      case EstablishmentCategory.services:
        fields
          ..add(_FieldLabel(label: 'Address'))
          ..add(TextField(decoration: _inputDecoration('Service address'), onChanged: onServiceAddress));
      case EstablishmentCategory.spectacles:
        break;
    }

    if (fields.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ...fields,
        const SizedBox(height: 20),
      ],
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.label, required this.value, required this.onChanged});
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: Row(
          children: <Widget>[
            Icon(
              value ? Icons.check_box : Icons.check_box_outline_blank,
              color: value ? AppColors.textPrimary : const Color(0xFFBDBDBD),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          ],
        ),
      ),
    );
  }
}

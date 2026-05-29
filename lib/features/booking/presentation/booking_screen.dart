import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/core/auth/auth_session_controller.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/providers/reserva_providers.dart';
import 'package:reservamobile/core/widgets/scroll_aware_scaffold.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key, required this.establishmentId});

  final String establishmentId;

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  DateTime? _checkOutDate;
  String _time = '19:30';
  int _guests = 2;
  String _notes = '';
  String? _serviceId;
  bool _saving = false;
  String _occasion = '';
  String _dietary = '';
  String _seatingPreference = 'indoor';
  String _therapistPreference = 'no_preference';
  bool _hasContraindications = false;
  bool _needTowels = false;
  int _kidsCount = 0;
  String _flightNumber = '';
  String _pickupLocation = '';
  String _companyName = '';
  int _teamSize = 8;
  String _serviceAddress = '';

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(reservaRepositoryProvider);
    final authState = ref.watch(authSessionProvider);

    return FutureBuilder<List<Object?>>(
      future: Future.wait([
        repository.getEstablishmentById(widget.establishmentId),
        repository.getServicesForEstablishment(widget.establishmentId),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final establishment = snapshot.data![0] as Establishment?;
        final services = snapshot.data![1] as List<ServiceItem>;
        _serviceId ??= services.isNotEmpty ? services.first.id : null;

        if (establishment == null) {
          return const ScrollAwareScaffold(
            title: 'Booking',
            body: Center(child: Text('Establishment not found')),
          );
        }

        return ScrollAwareScaffold(
          title: 'Book ${establishment.name}',
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _serviceId,
                  decoration: const InputDecoration(
                    labelText: 'Service',
                    border: OutlineInputBorder(),
                  ),
                  items: services
                      .map(
                        (s) => DropdownMenuItem<String>(
                          value: s.id,
                          child: Text('${s.name} • ${s.priceMad} MAD'),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) => setState(() => _serviceId = value),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Date'),
                  subtitle: Text(
                    '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
                  ),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: () async {
                    final selected = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (selected != null) {
                      setState(() => _date = selected);
                    }
                  },
                ),
                TextFormField(
                  initialValue: _time,
                  decoration: const InputDecoration(
                    labelText: 'Start time',
                    border: OutlineInputBorder(),
                    hintText: 'e.g. 20:00',
                  ),
                  onChanged: (value) => _time = value.trim(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: '2',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Guests',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _guests = int.tryParse(value) ?? 1,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Special notes',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _notes = value.trim(),
                ),
                const SizedBox(height: 12),
                _CategorySpecificFields(
                  category: establishment.category,
                  checkOutDate: _checkOutDate,
                  onPickCheckOutDate: (date) =>
                      setState(() => _checkOutDate = date),
                  seatingPreference: _seatingPreference,
                  onSeatingPreferenceChanged: (value) =>
                      setState(() => _seatingPreference = value),
                  occasion: _occasion,
                  onOccasionChanged: (value) => _occasion = value,
                  dietary: _dietary,
                  onDietaryChanged: (value) => _dietary = value,
                  therapistPreference: _therapistPreference,
                  onTherapistPreferenceChanged: (value) =>
                      setState(() => _therapistPreference = value),
                  hasContraindications: _hasContraindications,
                  onContraindicationsChanged: (value) =>
                      setState(() => _hasContraindications = value ?? false),
                  needTowels: _needTowels,
                  onNeedTowelsChanged: (value) =>
                      setState(() => _needTowels = value ?? false),
                  kidsCount: _kidsCount,
                  onKidsCountChanged: (value) =>
                      _kidsCount = int.tryParse(value) ?? 0,
                  flightNumber: _flightNumber,
                  onFlightNumberChanged: (value) =>
                      _flightNumber = value.trim(),
                  pickupLocation: _pickupLocation,
                  onPickupLocationChanged: (value) =>
                      _pickupLocation = value.trim(),
                  companyName: _companyName,
                  onCompanyNameChanged: (value) => _companyName = value.trim(),
                  teamSize: _teamSize,
                  onTeamSizeChanged: (value) =>
                      _teamSize = int.tryParse(value) ?? 1,
                  serviceAddress: _serviceAddress,
                  onServiceAddressChanged: (value) =>
                      _serviceAddress = value.trim(),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _saving
                      ? null
                      : () async {
                          if (_serviceId == null) {
                            return;
                          }
                          if (!authState.isLoggedIn) {
                            if (!context.mounted) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please login before booking'),
                              ),
                            );
                            context.push(AppRoute.login);
                            return;
                          }
                          setState(() => _saving = true);
                          await repository.createBooking(
                            establishmentId: widget.establishmentId,
                            serviceId: _serviceId!,
                            bookingDate: _date,
                            startTime: _time,
                            guestCount: _guests,
                            notes: _composeNotes(establishment.category),
                          );
                          ref.invalidate(userBookingsProvider);
                          if (!context.mounted) {
                            return;
                          }
                          setState(() => _saving = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Booking created successfully'),
                            ),
                          );
                          context.pop();
                        },
                  child: Text(_saving ? 'Saving...' : 'Confirm booking'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _composeNotes(EstablishmentCategory category) {
    final parts = <String>[if (_notes.isNotEmpty) _notes];

    switch (category) {
      case EstablishmentCategory.restaurants:
        parts.add('occasion=$_occasion');
        parts.add('dietary=$_dietary');
        parts.add('seating=$_seatingPreference');
        break;
      case EstablishmentCategory.wellness:
        parts.add('therapist=$_therapistPreference');
        parts.add('contraindications=$_hasContraindications');
        break;
      case EstablishmentCategory.voyage:
        if (_checkOutDate != null) {
          parts.add(
            'checkout=${_checkOutDate!.year}-${_checkOutDate!.month.toString().padLeft(2, '0')}-${_checkOutDate!.day.toString().padLeft(2, '0')}',
          );
        }
        break;
      case EstablishmentCategory.dayPasses:
        parts.add('need_towels=$_needTowels');
        parts.add('kids=$_kidsCount');
        break;
      case EstablishmentCategory.conciergerie:
        parts.add('pickup=$_pickupLocation');
        parts.add('flight=$_flightNumber');
        break;
      case EstablishmentCategory.corporate:
        parts.add('company=$_companyName');
        parts.add('team_size=$_teamSize');
        break;
      case EstablishmentCategory.services:
        parts.add('service_address=$_serviceAddress');
        break;
      case EstablishmentCategory.spectacles:
        parts.add('event_time=$_time');
        break;
    }

    return parts.where((part) => part.trim().isNotEmpty).join(' | ');
  }
}

class _CategorySpecificFields extends StatelessWidget {
  const _CategorySpecificFields({
    required this.category,
    required this.checkOutDate,
    required this.onPickCheckOutDate,
    required this.seatingPreference,
    required this.onSeatingPreferenceChanged,
    required this.occasion,
    required this.onOccasionChanged,
    required this.dietary,
    required this.onDietaryChanged,
    required this.therapistPreference,
    required this.onTherapistPreferenceChanged,
    required this.hasContraindications,
    required this.onContraindicationsChanged,
    required this.needTowels,
    required this.onNeedTowelsChanged,
    required this.kidsCount,
    required this.onKidsCountChanged,
    required this.flightNumber,
    required this.onFlightNumberChanged,
    required this.pickupLocation,
    required this.onPickupLocationChanged,
    required this.companyName,
    required this.onCompanyNameChanged,
    required this.teamSize,
    required this.onTeamSizeChanged,
    required this.serviceAddress,
    required this.onServiceAddressChanged,
  });

  final EstablishmentCategory category;
  final DateTime? checkOutDate;
  final ValueChanged<DateTime> onPickCheckOutDate;
  final String seatingPreference;
  final ValueChanged<String> onSeatingPreferenceChanged;
  final String occasion;
  final ValueChanged<String> onOccasionChanged;
  final String dietary;
  final ValueChanged<String> onDietaryChanged;
  final String therapistPreference;
  final ValueChanged<String> onTherapistPreferenceChanged;
  final bool hasContraindications;
  final ValueChanged<bool?> onContraindicationsChanged;
  final bool needTowels;
  final ValueChanged<bool?> onNeedTowelsChanged;
  final int kidsCount;
  final ValueChanged<String> onKidsCountChanged;
  final String flightNumber;
  final ValueChanged<String> onFlightNumberChanged;
  final String pickupLocation;
  final ValueChanged<String> onPickupLocationChanged;
  final String companyName;
  final ValueChanged<String> onCompanyNameChanged;
  final int teamSize;
  final ValueChanged<String> onTeamSizeChanged;
  final String serviceAddress;
  final ValueChanged<String> onServiceAddressChanged;

  @override
  Widget build(BuildContext context) {
    final title = switch (category) {
      EstablishmentCategory.restaurants => 'Restaurant preferences',
      EstablishmentCategory.wellness => 'Wellness preferences',
      EstablishmentCategory.voyage => 'Stay details',
      EstablishmentCategory.dayPasses => 'Day pass details',
      EstablishmentCategory.conciergerie => 'Concierge details',
      EstablishmentCategory.spectacles => 'Event details',
      EstablishmentCategory.corporate => 'Corporate details',
      EstablishmentCategory.services => 'Service details',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            ...switch (category) {
              EstablishmentCategory.restaurants => [
                DropdownButtonFormField<String>(
                  initialValue: seatingPreference,
                  decoration: const InputDecoration(
                    labelText: 'Seating preference',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'indoor', child: Text('Indoor')),
                    DropdownMenuItem(value: 'outdoor', child: Text('Outdoor')),
                    DropdownMenuItem(value: 'rooftop', child: Text('Rooftop')),
                  ],
                  onChanged: (value) =>
                      onSeatingPreferenceChanged(value ?? 'indoor'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: occasion,
                  decoration: const InputDecoration(
                    labelText: 'Occasion',
                    border: OutlineInputBorder(),
                    hintText: 'Birthday, anniversary...',
                  ),
                  onChanged: onOccasionChanged,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: dietary,
                  decoration: const InputDecoration(
                    labelText: 'Dietary preferences',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: onDietaryChanged,
                ),
              ],
              EstablishmentCategory.wellness => [
                DropdownButtonFormField<String>(
                  initialValue: therapistPreference,
                  decoration: const InputDecoration(
                    labelText: 'Therapist preference',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'no_preference',
                      child: Text('No preference'),
                    ),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                  ],
                  onChanged: (value) =>
                      onTherapistPreferenceChanged(value ?? 'no_preference'),
                ),
                CheckboxListTile(
                  value: hasContraindications,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('I have contraindications'),
                  onChanged: onContraindicationsChanged,
                ),
              ],
              EstablishmentCategory.voyage => [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Check-out date'),
                  subtitle: Text(
                    checkOutDate == null
                        ? 'Select date'
                        : '${checkOutDate!.year}-${checkOutDate!.month.toString().padLeft(2, '0')}-${checkOutDate!.day.toString().padLeft(2, '0')}',
                  ),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: () async {
                    final selected = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 2)),
                      firstDate: DateTime.now().add(const Duration(days: 1)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (selected != null) {
                      onPickCheckOutDate(selected);
                    }
                  },
                ),
              ],
              EstablishmentCategory.dayPasses => [
                CheckboxListTile(
                  value: needTowels,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Need towels'),
                  onChanged: onNeedTowelsChanged,
                ),
                TextFormField(
                  initialValue: kidsCount.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Kids count',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: onKidsCountChanged,
                ),
              ],
              EstablishmentCategory.conciergerie => [
                TextFormField(
                  initialValue: pickupLocation,
                  decoration: const InputDecoration(
                    labelText: 'Pickup location',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: onPickupLocationChanged,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: flightNumber,
                  decoration: const InputDecoration(
                    labelText: 'Flight number (optional)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: onFlightNumberChanged,
                ),
              ],
              EstablishmentCategory.spectacles => [
                const Text('Event details follow selected date/time above.'),
              ],
              EstablishmentCategory.corporate => [
                TextFormField(
                  initialValue: companyName,
                  decoration: const InputDecoration(
                    labelText: 'Company name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: onCompanyNameChanged,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: teamSize.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Team size',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: onTeamSizeChanged,
                ),
              ],
              EstablishmentCategory.services => [
                TextFormField(
                  initialValue: serviceAddress,
                  decoration: const InputDecoration(
                    labelText: 'Service address',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: onServiceAddressChanged,
                ),
              ],
            },
          ],
        ),
      ),
    );
  }
}

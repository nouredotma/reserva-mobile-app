import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/app/theme/app_colors.dart';
import 'package:reservamobile/core/assets/app_assets.dart';
import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:reservamobile/core/i18n/app_strings.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/providers/reserva_providers.dart';
import 'package:reservamobile/core/widgets/app_network_image.dart';
import 'package:reservamobile/core/widgets/ui_kit.dart';
import 'package:reservamobile/features/notifications/presentation/notifications_screen.dart';
import 'package:reservamobile/features/shell/shell_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _adults = 0;
  int _children = 0;
  EstablishmentCategory? _selectedCategory = EstablishmentCategory.restaurants;
  String? _selectedCityId;

  void _openSearch({EstablishmentCategory? category, String? cityId}) {
    final notifier = ref.read(searchFiltersProvider.notifier);
    notifier.clear();
    if (category != null) notifier.setCategory(category);
    if (cityId != null) notifier.setCity(cityId);
    notifier.setDate(_selectedDate);
    notifier.setTime(_selectedTime == null
        ? null
        : '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}');
    notifier.setGuests(adults: _adults, children: _children);
    ref.read(shellTabProvider.notifier).state = 1;
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings t = ref.watch(stringsProvider);
    final AppLanguage lang = ref.watch(languageProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final citiesAsync = ref.watch(citiesProvider);
    final featuredAsync = ref.watch(featuredEstablishmentsProvider);

    final Size screenSize = MediaQuery.sizeOf(context);
    final bool isShortDevice = screenSize.height < 760;
    final double heroHeight = screenSize.height * 0.60;
    final double contentTopOffset =
        (heroHeight - kToolbarHeight - (isShortDevice ? 20 : 8)).clamp(0.0, heroHeight);
    final double mainContentLift = isShortDevice ? -8 : -14;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: <Widget>[
            SizedBox(
              height: heroHeight + MediaQuery.viewPaddingOf(context).top,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(AppAssets.login, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(0x73000000),
                          Color(0x29000000),
                          Color(0x05000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              bottom: false,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: false,
                    floating: false,
                    snap: false,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    title: Image.asset(
                      AppAssets.logoWhite,
                      height: 34,
                      fit: BoxFit.contain,
                      semanticLabel: 'Reserva logo',
                    ),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.navBar,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: IconButton(
                            tooltip: t.notifications,
                            iconSize: 21,
                            visualDensity: VisualDensity.compact,
                            splashRadius: 21,
                            color: AppColors.navBarIcon,
                            onPressed: () => context.push(AppRoute.notifications),
                            icon: Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                const Icon(Icons.notifications_outlined),
                                if (hasUnreadNotifications)
                                  Positioned(
                                    right: -1,
                                    top: -1,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.navBar, width: 1),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: contentTopOffset),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        child: Align(
                          alignment: const Alignment(0, -0.18),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  t.homeHeroTagline,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _HeroMobileFilter(
                                categoriesAsync: categoriesAsync,
                                citiesAsync: citiesAsync,
                                language: lang,
                                strings: t,
                                selectedDate: _selectedDate,
                                selectedTime: _selectedTime,
                                adults: _adults,
                                children: _children,
                                selectedCategory: _selectedCategory,
                                selectedCityId: _selectedCityId,
                                onCategoryChanged: (value) {
                                  setState(() => _selectedCategory = value);
                                },
                                onCityChanged: (value) {
                                  setState(() => _selectedCityId = value);
                                },
                                onDateChanged: (value) {
                                  setState(() => _selectedDate = value);
                                },
                                onTimeChanged: (value) {
                                  setState(() => _selectedTime = value);
                                },
                                onGuestsChanged: (adults, children) {
                                  setState(() {
                                    _adults = adults;
                                    _children = children;
                                  });
                                },
                                onSearchTap: () => _openSearch(
                                  category: _selectedCategory,
                                  cityId: _selectedCityId,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: Offset(0, mainContentLift),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 20, 12, 120),
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(kRadius)),
                        ),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          categoriesAsync.when(
                            data: (categories) => _CategoriesGrid(
                              categories: categories,
                              language: lang,
                              onTap: (c) => _openSearch(category: c.key),
                            ),
                            loading: () => const _CategoriesGridSkeleton(),
                            error: (err, _) => Text('${t.loadError}: $err'),
                          ),
                          const SizedBox(height: 24),
                          _CitiesSectionHeader(
                            title: t.homeCitiesTitle,
                            subtitle: t.homeCitiesSubtitle,
                          ),
                          const SizedBox(height: 6),
                          citiesAsync.when(
                            data: (cities) => Column(
                              children: cities
                                  .map(
                                    (city) => _CityCard(
                                      city: city,
                                      language: lang,
                                      onTap: () => _openSearch(cityId: city.id),
                                    ),
                                  )
                                  .toList(growable: false),
                            ),
                            loading: () => const _CitiesListSkeleton(),
                            error: (err, _) => Text('${t.loadError}: $err'),
                          ),
                          const SizedBox(height: 24),
                          HomeSectionTitle(title: t.homeFeaturedTitle),
                          featuredAsync.when(
                            data: (items) {
                              final double cardWidth = MediaQuery.sizeOf(context).width * 0.85;
                              final double carouselHeight = cardWidth * 10 / 16 + 76;
                              return SizedBox(
                                height: carouselHeight,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,
                                  children: items
                                      .map(
                                        (item) => FeaturedCard(
                                          width: cardWidth,
                                          establishment: item,
                                          onTap: () => context.push(AppRoute.detail(item.id)),
                                        ),
                                      )
                                      .toList(growable: false),
                                ),
                              );
                            },
                            loading: () => const _FeaturedCarouselSkeleton(),
                            error: (err, _) => Text('${t.loadError}: $err'),
                          ),
                        ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroMobileFilter extends StatelessWidget {
  const _HeroMobileFilter({
    required this.categoriesAsync,
    required this.citiesAsync,
    required this.language,
    required this.strings,
    required this.selectedDate,
    required this.selectedTime,
    required this.adults,
    required this.children,
    required this.selectedCategory,
    required this.selectedCityId,
    required this.onCategoryChanged,
    required this.onCityChanged,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onGuestsChanged,
    required this.onSearchTap,
  });

  final AsyncValue<List<Category>> categoriesAsync;
  final AsyncValue<List<City>> citiesAsync;
  final AppLanguage language;
  final AppStrings strings;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final int adults;
  final int children;
  final EstablishmentCategory? selectedCategory;
  final String? selectedCityId;
  final ValueChanged<EstablishmentCategory> onCategoryChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<DateTime?> onDateChanged;
  final ValueChanged<TimeOfDay?> onTimeChanged;
  final void Function(int adults, int children) onGuestsChanged;
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    final int totalGuests = adults + children;
    final EstablishmentCategory effectiveCategory =
        selectedCategory ?? EstablishmentCategory.restaurants;
    final bool showTime = effectiveCategory != EstablishmentCategory.voyage &&
        effectiveCategory != EstablishmentCategory.spectacles;
    final String dateLabel = selectedDate == null
        ? strings.date
        : '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}';
    final String timeLabel = selectedTime == null
        ? strings.time
        : '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';
    final String guestsLabel = totalGuests == 0 ? strings.guests : '$totalGuests ${strings.guests}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        categoriesAsync.when(
          data: (categories) => _HeroCategoryGrid(
            categories: categories,
            language: language,
            selectedCategory: selectedCategory,
            onTap: onCategoryChanged,
          ),
          loading: () => const _HeroCategorySkeleton(),
          error: (_, _) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kRadiusLg),
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _HeroFilterButton(
                icon: Icons.location_on_outlined,
                label: _resolveCityLabel(citiesAsync, selectedCityId),
                onTap: () => _openCityPicker(context),
              ),
              const SizedBox(height: 6),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _HeroFilterButton(
                      icon: Icons.calendar_today_outlined,
                      label: dateLabel,
                      onTap: () => _pickDate(context),
                    ),
                  ),
                  if (showTime) ...<Widget>[
                    const SizedBox(width: 8),
                    Expanded(
                      child: _HeroFilterButton(
                        icon: Icons.schedule_outlined,
                        label: timeLabel,
                        onTap: () => _pickTime(context),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              _HeroFilterButton(
                icon: Icons.group_outlined,
                label: guestsLabel,
                onTap: () => _openGuestsSheet(context),
              ),
              const SizedBox(height: 6),
              FilledButton.icon(
                onPressed: onSearchTap,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textPrimary,
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                icon: const Icon(Icons.search, size: 18),
                label: Text(strings.searchTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _resolveCityLabel(AsyncValue<List<City>> citiesAsync, String? cityId) {
    if (cityId == null) return strings.allCities;
    final cities = citiesAsync.valueOrNull;
    if (cities == null) return strings.allCities;
    for (final city in cities) {
      if (city.id == cityId) return city.localizedName(language);
    }
    return strings.allCities;
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initial = selectedDate ?? now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) onDateChanged(picked);
  }

  Future<void> _pickTime(BuildContext context) async {
    int hour = selectedTime?.hour ?? TimeOfDay.now().hour;
    int minute = selectedTime?.minute ?? TimeOfDay.now().minute;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusMd)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E5E5),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Select time',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _TimeUnitPicker(
                          value: hour.toString().padLeft(2, '0'),
                          label: 'H',
                          onMinus: () => setSheetState(() => hour = (hour - 1 + 24) % 24),
                          onPlus: () => setSheetState(() => hour = (hour + 1) % 24),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(':', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                        ),
                        _TimeUnitPicker(
                          value: minute.toString().padLeft(2, '0'),
                          label: 'M',
                          onMinus: () => setSheetState(() => minute = (minute - 5 + 60) % 60),
                          onPlus: () => setSheetState(() => minute = (minute + 5) % 60),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              onTimeChanged(null);
                              Navigator.of(context).pop();
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.textPrimary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            child: const Text('Clear'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              onTimeChanged(TimeOfDay(hour: hour, minute: minute));
                              Navigator.of(context).pop();
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openGuestsSheet(BuildContext context) async {
    int draftAdults = adults;
    int draftChildren = children;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusMd)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E5E5),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(strings.guests, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 18),
                    _GuestCounterRow(
                      label: 'Adults',
                      subtitle: '13+',
                      count: draftAdults,
                      onMinus: () => setSheetState(() => draftAdults = (draftAdults - 1).clamp(0, 99)),
                      onPlus: () => setSheetState(() => draftAdults = (draftAdults + 1).clamp(0, 99)),
                    ),
                    const SizedBox(height: 12),
                    _GuestCounterRow(
                      label: 'Children',
                      subtitle: '2-12',
                      count: draftChildren,
                      onMinus: () => setSheetState(() => draftChildren = (draftChildren - 1).clamp(0, 99)),
                      onPlus: () => setSheetState(() => draftChildren = (draftChildren + 1).clamp(0, 99)),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          onGuestsChanged(draftAdults, draftChildren);
                          Navigator.of(context).pop();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        ),
                        child: Text(strings.apply),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openCityPicker(BuildContext context) async {
    final List<City>? cities = citiesAsync.valueOrNull;
    if (cities == null) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusMd)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  strings.allCities,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      _CityOptionTile(
                        label: strings.allCities,
                        selected: selectedCityId == null,
                        onTap: () {
                          onCityChanged(null);
                          Navigator.of(context).pop();
                        },
                      ),
                      ...cities.map(
                        (city) => _CityOptionTile(
                          label: city.localizedName(language),
                          selected: selectedCityId == city.id,
                          onTap: () {
                            onCityChanged(city.id);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroCategoryGrid extends StatelessWidget {
  const _HeroCategoryGrid({
    required this.categories,
    required this.language,
    required this.selectedCategory,
    required this.onTap,
  });

  final List<Category> categories;
  final AppLanguage language;
  final EstablishmentCategory? selectedCategory;
  final ValueChanged<EstablishmentCategory> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 3;
        final double itemWidth = (constraints.maxWidth - (spacing * 3)) / 4;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: categories.map((category) {
            final bool selected = selectedCategory == category.key;
            final String rawLabel = category.localizedLabel(language).trim();
            final Set<EstablishmentCategory> forceTwoLines = <EstablishmentCategory>{
              EstablishmentCategory.wellness,
              EstablishmentCategory.conciergerie,
              EstablishmentCategory.corporate,
              EstablishmentCategory.spectacles,
            };
            final String displayLabel = forceTwoLines.contains(category.key)
                ? rawLabel.replaceAll(' & ', '\n& ')
                : rawLabel;

            return SizedBox(
              width: itemWidth,
              height: 34,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => onTap(category.key),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.textPrimary : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: selected ? AppColors.textPrimary : const Color(0xFFE5E5E5),
                    ),
                  ),
                  child: Text(
                    displayLabel,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      color: selected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(growable: false),
        );
      },
    );
  }
}

class _HeroFilterButton extends StatelessWidget {
  const _HeroFilterButton({
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
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 16, color: const Color(0xFF737373)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCategorySkeleton extends StatelessWidget {
  const _HeroCategorySkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 3;
        final double itemWidth = (constraints.maxWidth - (spacing * 3)) / 4;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List<Widget>.generate(
            8,
            (_) => SizedBox(
              width: itemWidth,
              height: 34,
              child: const AppSkeletonBox(height: double.infinity),
            ),
          ),
        );
      },
    );
  }
}

class _TimeUnitPicker extends StatelessWidget {
  const _TimeUnitPicker({
    required this.value,
    required this.label,
    required this.onMinus,
    required this.onPlus,
  });

  final String value;
  final String label;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: onPlus,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.all(2),
            child: Icon(Icons.keyboard_arrow_up_rounded, size: 18),
          ),
        ),
        Container(
          width: 44,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(kRadiusSm),
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        InkWell(
          onTap: onMinus,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.all(2),
            child: Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: Color(0xFF737373)),
        ),
      ],
    );
  }
}

class _GuestCounterRow extends StatelessWidget {
  const _GuestCounterRow({
    required this.label,
    required this.subtitle,
    required this.count,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final String subtitle;
  final int count;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF737373))),
            ],
          ),
        ),
        IconButton(
          onPressed: onMinus,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text('$count', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        IconButton(
          onPressed: onPlus,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

class _CityOptionTile extends StatelessWidget {
  const _CityOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(kRadiusSm),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF5F5F5) : Colors.transparent,
          borderRadius: BorderRadius.circular(kRadiusSm),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (selected) const Icon(Icons.check, size: 16),
          ],
        ),
      ),
    );
  }
}

class _CitiesSectionHeader extends StatelessWidget {
  const _CitiesSectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              height: 1.15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              height: 1.2,
              color: Color(0xFF737373),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesGridSkeleton extends StatelessWidget {
  const _CategoriesGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.38,
      ),
      itemBuilder: (_, _) => const AppSkeletonBox(
        height: double.infinity,
      ),
    );
  }
}

class _CitiesListSkeleton extends StatelessWidget {
  const _CitiesListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[
        AppSkeletonBox(height: 200),
        SizedBox(height: 14),
        AppSkeletonBox(height: 200),
      ],
    );
  }
}

class _FeaturedCarouselSkeleton extends StatelessWidget {
  const _FeaturedCarouselSkeleton();

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.sizeOf(context).width * 0.85;
    final double carouselHeight = cardWidth * 10 / 16 + 76;
    return SizedBox(
      height: carouselHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        children: const <Widget>[
          SizedBox(width: 1),
          AppSkeletonBox(width: 280, height: double.infinity),
          SizedBox(width: 12),
          AppSkeletonBox(width: 280, height: double.infinity),
        ],
      ),
    );
  }
}

class _CategoriesGrid extends StatelessWidget {
  const _CategoriesGrid({
    required this.categories,
    required this.language,
    required this.onTap,
  });

  final List<Category> categories;
  final AppLanguage language;
  final ValueChanged<Category> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.38,
      ),
      itemBuilder: (context, index) {
        final Category category = categories[index];
        return GestureDetector(
          onTap: () => onTap(category),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kRadiusSm),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                AppNetworkImage(url: category.image),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color(0x1A000000),
                        Color(0x33000000),
                        Color(0x1A000000),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          category.localizedLabel(language),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          category.localizedDescription(language),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.82),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CityCard extends StatelessWidget {
  const _CityCard({required this.city, required this.language, required this.onTap});

  final City city;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(bottom: 14),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(kRadiusSm)),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(city.image, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.transparent, Colors.black87],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    city.localizedName(language),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    city.localizedRegion(language),
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 14,
              top: 14,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_outward, size: 18, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

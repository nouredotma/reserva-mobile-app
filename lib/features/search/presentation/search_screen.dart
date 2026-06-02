import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/app/theme/app_colors.dart';
import 'package:reservamobile/core/data/cuisines.dart';
import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:reservamobile/core/i18n/app_strings.dart';
import 'package:reservamobile/core/i18n/labels.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/providers/reserva_providers.dart';
import 'package:reservamobile/core/repositories/reserva_repository.dart';
import 'package:reservamobile/core/widgets/app_scaffold.dart';
import 'package:reservamobile/core/widgets/ui_kit.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _adults = 0;
  int _children = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings t = ref.watch(stringsProvider);
    final AppLanguage lang = ref.watch(languageProvider);
    final filters = ref.watch(searchFiltersProvider);
    final citiesAsync = ref.watch(citiesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final resultsAsync = ref.watch(searchedEstablishmentsProvider);
    final notifier = ref.read(searchFiltersProvider.notifier);
    final String cityLabel = citiesAsync.maybeWhen(
      data: (cities) {
        if (filters.cityId == null) return t.allCities;
        for (final city in cities) {
          if (city.id == filters.cityId) return city.localizedName(lang);
        }
        return t.allCities;
      },
      orElse: () => t.allCities,
    );
    final String dateLabel = _selectedDate == null
        ? t.date
        : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}';
    final String timeLabel = _selectedTime == null
        ? t.time
        : '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
    final int totalGuests = _adults + _children;
    final String guestsLabel = totalGuests == 0
        ? t.guests
        : '$totalGuests ${t.guests}';

    // Keep the text field synced when filters are cleared externally.
    if (_controller.text != filters.query) {
      _controller.value = TextEditingValue(
        text: filters.query,
        selection: TextSelection.collapsed(offset: filters.query.length),
      );
    }

    return AppScaffold(
      title: t.searchTitle,
      padding: kScreenContentPadding,
      actions: <Widget>[
        IconButton(
          tooltip: t.filters,
          iconSize: AppScaffold.toolbarIconSize,
          onPressed: () => _openFilterSheet(context, t, lang),
          icon: Badge(
            isLabelVisible: filters.hasActiveFilters,
            child: const Icon(Icons.tune),
          ),
        ),
      ],
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              _TopFilterButton(
                icon: Icons.location_on_outlined,
                label: cityLabel,
                onTap: () => _openCityPicker(citiesAsync, filters.cityId, notifier, lang, t),
              ),
              const SizedBox(width: 8),
              _TopFilterButton(
                icon: Icons.calendar_today_outlined,
                label: dateLabel,
                onTap: _pickDate,
              ),
              const SizedBox(width: 8),
              _TopFilterButton(
                icon: Icons.schedule_outlined,
                label: timeLabel,
                onTap: _pickTime,
              ),
              const SizedBox(width: 8),
              _TopFilterButton(
                icon: Icons.group_outlined,
                label: guestsLabel,
                onTap: () => _openGuestsSheet(t),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Category pills
        categoriesAsync.when(
          data: (categories) => _PillRow(
            children: <Widget>[
              FilterPill(
                label: t.allCategories,
                selected: filters.category == null,
                onTap: () => notifier.setCategory(null),
              ),
              ...categories.map((c) => FilterPill(
                    label: c.localizedLabel(lang),
                    icon: categoryIcon(c.key),
                    selected: filters.category == c.key,
                    onTap: () => notifier.setCategory(
                      filters.category == c.key ? null : c.key,
                    ),
                  )),
            ],
          ),
          loading: () => const _FilterPillsSkeleton(),
          error: (err, _) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 18),
        resultsAsync.when(
          data: (results) {
            if (results.isEmpty) {
              return _EmptyState(t: t, onClear: notifier.clear);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    '${results.length} ${results.length == 1 ? t.result : t.results}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF737373),
                    ),
                  ),
                ),
                ...results.map((item) => EstablishmentCard(
                      establishment: item,
                      onTap: () => context.push(AppRoute.detail(item.id)),
                    )),
              ],
            );
          },
          loading: () => const _SearchResultsSkeleton(),
          error: (err, _) => Text('${t.loadError}: $err'),
        ),
      ],
    );
  }

  Future<void> _openFilterSheet(
    BuildContext context,
    AppStrings t,
    AppLanguage lang,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusMd)),
      ),
      builder: (context) => _FilterSheet(
        t: t,
        lang: lang,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime initial = _selectedDate ?? now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: const DatePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(kRadiusMd)),
              ),
              dayStyle: TextStyle(fontSize: 12),
              weekdayStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              headerHeadlineStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              headerHelpStyle: TextStyle(fontSize: 11),
            ),
            textTheme: Theme.of(context).textTheme.copyWith(
                  bodyLarge: const TextStyle(fontSize: 13),
                  bodyMedium: const TextStyle(fontSize: 12),
                ),
            visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    int hour = _selectedTime?.hour ?? TimeOfDay.now().hour;
    int minute = _selectedTime?.minute ?? TimeOfDay.now().minute;

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
                    Text(
                      'Select time',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
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
                              setState(() => _selectedTime = null);
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
                              setState(() => _selectedTime = TimeOfDay(hour: hour, minute: minute));
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

  Future<void> _openGuestsSheet(AppStrings t) async {
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
                    Text(t.guests, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 18),
                    _GuestCounterRow(
                      label: 'Adults',
                      subtitle: '13+',
                      count: _adults,
                      onMinus: () => setSheetState(() => _adults = (_adults - 1).clamp(0, 99)),
                      onPlus: () => setSheetState(() => _adults = (_adults + 1).clamp(0, 99)),
                    ),
                    const SizedBox(height: 12),
                    _GuestCounterRow(
                      label: 'Children',
                      subtitle: '2-12',
                      count: _children,
                      onMinus: () => setSheetState(() => _children = (_children - 1).clamp(0, 99)),
                      onPlus: () => setSheetState(() => _children = (_children + 1).clamp(0, 99)),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        ),
                        child: Text(t.apply),
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

  Future<void> _openCityPicker(
    AsyncValue<List<City>> citiesAsync,
    String? selectedCityId,
    SearchFiltersNotifier notifier,
    AppLanguage lang,
    AppStrings t,
  ) async {
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
                  t.allCities,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      _CityOptionTile(
                        label: t.allCities,
                        selected: selectedCityId == null,
                        onTap: () {
                          notifier.setCity(null);
                          Navigator.of(context).pop();
                        },
                      ),
                      ...cities.map(
                        (city) => _CityOptionTile(
                          label: city.localizedName(lang),
                          selected: selectedCityId == city.id,
                          onTap: () {
                            notifier.setCity(city.id);
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

class _PillRow extends StatelessWidget {
  const _PillRow({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: children.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) => children[index],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.t, required this.onClear});
  final AppStrings t;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: <Widget>[
            const Icon(Icons.search_off, size: 48, color: Color(0xFFBDBDBD)),
            const SizedBox(height: 12),
            Text(t.noResults,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(t.noResultsHint,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFF737373))),
            const SizedBox(height: 16),
            TextButton(onPressed: onClear, child: Text(t.clearFilters)),
          ],
        ),
      ),
    );
  }
}

class _FilterSheet extends ConsumerStatefulWidget {
  const _FilterSheet({
    required this.t,
    required this.lang,
    required this.onClose,
  });
  final AppStrings t;
  final AppLanguage lang;
  final VoidCallback onClose;

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final filters = ref.read(searchFiltersProvider);
    _searchController = TextEditingController(text: filters.query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final lang = widget.lang;
    final filters = ref.watch(searchFiltersProvider);
    final notifier = ref.read(searchFiltersProvider.notifier);

    if (_searchController.text != filters.query) {
      _searchController.value = TextEditingValue(
        text: filters.query,
        selection: TextSelection.collapsed(offset: filters.query.length),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.82,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    t.filters,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                InkWell(
                  onTap: widget.onClose,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.search, color: Color(0xFF737373)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: t.searchPlaceholder,
                        border: InputBorder.none,
                        hintStyle: const TextStyle(color: Color(0xFF737373)),
                      ),
                      onChanged: notifier.setQuery,
                    ),
                  ),
                  if (filters.query.isNotEmpty)
                    GestureDetector(
                      onTap: () => notifier.setQuery(''),
                      child: const Icon(Icons.close, size: 18, color: Color(0xFF737373)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Subcategory (depends on selected category)
            if (filters.category != null) ...<Widget>[
              _GroupLabel(label: t.allTypes),
              ref.watch(subcategoriesProvider(filters.category!)).when(
                    data: (subs) => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        _SelectChip(
                          label: t.allTypes,
                          selected: filters.subcategory == null,
                          onTap: () => notifier.setSubcategory(null),
                        ),
                        ...subs.map((s) => _SelectChip(
                              label: s.localizedLabel(lang),
                              selected: filters.subcategory == s.key,
                              onTap: () => notifier.setSubcategory(
                                filters.subcategory == s.key ? null : s.key,
                              ),
                            )),
                      ],
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (err, _) => const SizedBox.shrink(),
                  ),
              const SizedBox(height: 20),
            ],

            // Cuisine (restaurants only)
            if (filters.category == EstablishmentCategory.restaurants) ...<Widget>[
              _GroupLabel(label: t.cuisine),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  _SelectChip(
                    label: t.allCuisines,
                    selected: filters.cuisine == null,
                    onTap: () => notifier.setCuisine(null),
                  ),
                  ...const <String>['moroccan', 'mediterranean', 'french', 'italian', 'japanese', 'seafood', 'fusion']
                      .map((key) => _SelectChip(
                            label: cuisineLabel(key, lang),
                            selected: filters.cuisine == key,
                            onTap: () => notifier.setCuisine(
                              filters.cuisine == key ? null : key,
                            ),
                          )),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Rating
            _GroupLabel(label: t.minimumRating),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                _SelectChip(
                  label: t.anyRating,
                  selected: filters.minRating == null,
                  onTap: () => notifier.setMinRating(null),
                ),
                ...const <double>[4.0, 4.5, 4.8].map((r) => _SelectChip(
                      label: '${r.toStringAsFixed(1)}+',
                      selected: filters.minRating == r,
                      onTap: () => notifier.setMinRating(
                        filters.minRating == r ? null : r,
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 20),

            // Sort
            _GroupLabel(label: t.sortBy),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                _SelectChip(label: t.recommended, selected: filters.sort == SortOption.recommended, onTap: () => notifier.setSort(SortOption.recommended)),
                _SelectChip(label: t.highestRating, selected: filters.sort == SortOption.rating, onTap: () => notifier.setSort(SortOption.rating)),
                _SelectChip(label: t.priceLowHigh, selected: filters.sort == SortOption.priceLowHigh, onTap: () => notifier.setSort(SortOption.priceLowHigh)),
                _SelectChip(label: t.priceHighLow, selected: filters.sort == SortOption.priceHighLow, onTap: () => notifier.setSort(SortOption.priceHighLow)),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      notifier.clear();
                      Navigator.of(context).pop();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.textPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(t.reset),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(t.apply),
                  ),
                ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopFilterButton extends StatelessWidget {
  const _TopFilterButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(kRadiusMd),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 16, color: const Color(0xFF737373)),
            const SizedBox(width: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
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

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SelectChip extends StatelessWidget {
  const _SelectChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
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

class _FilterPillsSkeleton extends StatelessWidget {
  const _FilterPillsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const <Widget>[
          AppSkeletonBox(width: 110, height: 36, radius: 999),
          SizedBox(width: 8),
          AppSkeletonBox(width: 90, height: 36, radius: 999),
          SizedBox(width: 8),
          AppSkeletonBox(width: 128, height: 36, radius: 999),
        ],
      ),
    );
  }
}

class _SearchResultsSkeleton extends StatelessWidget {
  const _SearchResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppSkeletonBox(width: 120, height: 14),
        SizedBox(height: 12),
        AppSkeletonBox(height: 260),
        SizedBox(height: 14),
        AppSkeletonBox(height: 260),
      ],
    );
  }
}

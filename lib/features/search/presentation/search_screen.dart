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

    // Keep the text field synced when filters are cleared externally.
    if (_controller.text != filters.query) {
      _controller.value = TextEditingValue(
        text: filters.query,
        selection: TextSelection.collapsed(offset: filters.query.length),
      );
    }

    return AppScaffold(
      title: t.searchTitle,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
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
                  controller: _controller,
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
        const SizedBox(height: 16),
        // City pills
        citiesAsync.when(
          data: (cities) => _PillRow(
            children: <Widget>[
              FilterPill(
                label: t.allCities,
                selected: filters.cityId == null,
                onTap: () => notifier.setCity(null),
              ),
              ...cities.map((city) => FilterPill(
                    label: city.localizedName(lang),
                    selected: filters.cityId == city.id,
                    onTap: () => notifier.setCity(city.id),
                  )),
            ],
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 10),
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
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
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
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          ),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _FilterSheet(t: t, lang: lang),
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
        separatorBuilder: (_, __) => const SizedBox(width: 8),
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

class _FilterSheet extends ConsumerWidget {
  const _FilterSheet({required this.t, required this.lang});
  final AppStrings t;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);
    final notifier = ref.read(searchFiltersProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
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
            Text(t.filters,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
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
                    error: (_, __) => const SizedBox.shrink(),
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
                  child: OutlinedButton(
                    onPressed: () {
                      notifier.clear();
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
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

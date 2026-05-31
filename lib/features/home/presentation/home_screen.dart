import 'package:flutter/material.dart';
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
import 'package:reservamobile/core/widgets/app_scaffold.dart';
import 'package:reservamobile/core/widgets/ui_kit.dart';
import 'package:reservamobile/features/shell/shell_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _openSearch(WidgetRef ref, {EstablishmentCategory? category, String? cityId}) {
    final notifier = ref.read(searchFiltersProvider.notifier);
    notifier.clear();
    if (category != null) notifier.setCategory(category);
    if (cityId != null) notifier.setCity(cityId);
    ref.read(shellTabProvider.notifier).state = 1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings t = ref.watch(stringsProvider);
    final AppLanguage lang = ref.watch(languageProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final citiesAsync = ref.watch(citiesProvider);
    final featuredAsync = ref.watch(featuredEstablishmentsProvider);

    return AppScaffold(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
      titleWidget: Image.asset(
        AppAssets.logo,
        height: 34,
        fit: BoxFit.contain,
        semanticLabel: 'Reserva logo',
      ),
      actions: <Widget>[
        IconButton(
          tooltip: t.notifications,
          iconSize: AppScaffold.toolbarIconSize,
          onPressed: () => context.push(AppRoute.notifications),
          icon: const Icon(Icons.notifications_outlined),
        ),
      ],
      children: <Widget>[
        _SearchBar(hint: t.homeSearchHint, onTap: () => _openSearch(ref)),
        const SizedBox(height: 24),
        SectionHeader(
          title: t.homeCategoriesTitle,
          action: t.seeAll,
          onAction: () => _openSearch(ref),
        ),
        categoriesAsync.when(
          data: (categories) => _CategoriesGrid(
            categories: categories,
            language: lang,
            onTap: (c) => _openSearch(ref, category: c.key),
          ),
          loading: () => const _Loader(),
          error: (err, _) => Text('${t.loadError}: $err'),
        ),
        const SizedBox(height: 28),
        SectionHeader(title: t.homeCitiesTitle),
        Text(
          t.homeCitiesSubtitle,
          style: const TextStyle(fontSize: 13, color: Color(0xFF737373)),
        ),
        const SizedBox(height: 14),
        citiesAsync.when(
          data: (cities) => Column(
            children: cities
                .map((city) => _CityCard(
                      city: city,
                      language: lang,
                      onTap: () => _openSearch(ref, cityId: city.id),
                    ))
                .toList(growable: false),
          ),
          loading: () => const _Loader(),
          error: (err, _) => Text('${t.loadError}: $err'),
        ),
        const SizedBox(height: 28),
        SectionHeader(
          title: t.homeFeaturedTitle,
          action: t.seeAll,
          onAction: () => _openSearch(ref),
        ),
        featuredAsync.when(
          data: (items) => SizedBox(
            height: 230,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              children: items
                  .map((item) => FeaturedCard(
                        establishment: item,
                        onTap: () => context.push(AppRoute.detail(item.id)),
                      ))
                  .toList(growable: false),
            ),
          ),
          loading: () => const _Loader(),
          error: (err, _) => Text('${t.loadError}: $err'),
        ),
      ],
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader();
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.hint, required this.onTap});
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: <Widget>[
            const Icon(Icons.search, color: Color(0xFF737373)),
            const SizedBox(width: 12),
            Text(hint, style: const TextStyle(color: Color(0xFF737373), fontSize: 15)),
          ],
        ),
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
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final Category category = categories[index];
        return GestureDetector(
          onTap: () => onTap(category),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kRadiusLg),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                AppNetworkImage(url: category.image),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Colors.transparent, Colors.black54],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      category.localizedLabel(language),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
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
        height: 150,
        margin: const EdgeInsets.only(bottom: 14),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(kRadiusLg)),
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

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
      padding: kScreenContentPadding,
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
        categoriesAsync.when(
          data: (categories) => _CategoriesGrid(
            categories: categories,
            language: lang,
            onTap: (c) => _openSearch(ref, category: c.key),
          ),
          loading: () => const _Loader(),
          error: (err, _) => Text('${t.loadError}: $err'),
        ),
        const SizedBox(height: 24),
        _CitiesSectionHeader(
          title: t.homeCitiesTitle,
          subtitle: t.homeCitiesSubtitle,
        ),
        const SizedBox(height: 14),
        citiesAsync.when(
          data: (cities) => Column(
            children: cities
                .map(
                  (city) => _CityCard(
                    city: city,
                    language: lang,
                    onTap: () => _openSearch(ref, cityId: city.id),
                  ),
                )
                .toList(growable: false),
          ),
          loading: () => const _Loader(),
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
          loading: () => const _Loader(),
          error: (err, _) => Text('${t.loadError}: $err'),
        ),
      ],
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
      padding: const EdgeInsets.only(bottom: 12),
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

class _Loader extends StatelessWidget {
  const _Loader();
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
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
        childAspectRatio: 1.38,
      ),
      itemBuilder: (context, index) {
        final Category category = categories[index];
        return GestureDetector(
          onTap: () => onTap(category),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kRadiusMd),
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
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(kRadiusMd)),
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

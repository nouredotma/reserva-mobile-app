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

    final Size screenSize = MediaQuery.sizeOf(context);
    final double heroHeight = screenSize.height * 0.40;
    final double overlap = 28;
    final double contentTopOffset = (heroHeight - kToolbarHeight - overlap).clamp(0.0, heroHeight);

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
                    child: SizedBox(
                      height: contentTopOffset,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 120),
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
                              onTap: (c) => _openSearch(ref, category: c.key),
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
                                      onTap: () => _openSearch(ref, cityId: city.id),
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
                ],
              ),
            ),
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

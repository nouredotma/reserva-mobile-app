import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/app/theme/app_colors.dart';
import 'package:reservamobile/core/data/mock/mock_data.dart';
import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:reservamobile/core/i18n/app_strings.dart';
import 'package:reservamobile/core/i18n/labels.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/widgets/app_network_image.dart';

const double kRadius = 18;
const double kRadiusLg = 24;
/// Matches web `rounded-xl` (12px).
const double kRadiusSm = 12;
/// Matches web `rounded-2xl` (16px).
const double kRadiusMd = 16;

/// Reusable skeleton loader with a subtle shimmer sweep.
class AppSkeletonBox extends StatelessWidget {
  const AppSkeletonBox({
    super.key,
    this.width,
    this.height = 14,
    this.radius = kRadiusSm,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: -1, end: 2),
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment(-1.0 + value, 0),
                end: Alignment(1.0 + value, 0),
                colors: const <Color>[
                  Color(0xFFECECEC),
                  Color(0xFFF7F7F7),
                  Color(0xFFECECEC),
                ],
                stops: const <double>[0.1, 0.45, 0.9],
              ).createShader(rect);
            },
            blendMode: BlendMode.srcATop,
            child: Container(
              width: width,
              height: height,
              color: const Color(0xFFECECEC),
            ),
          );
        },
      ),
    );
  }
}

/// Homepage section title — mirrors web `text-xl font-medium tracking-tight`.
class HomeSectionTitle extends StatelessWidget {
  const HomeSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.3,
          height: 1.2,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.rating, this.reviewCount, this.compact = false});

  final double rating;
  final int? reviewCount;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(Icons.star_rounded, size: 16, color: AppColors.primary),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        if (reviewCount != null && !compact) ...<Widget>[
          const SizedBox(width: 3),
          Text(
            '($reviewCount)',
            style: const TextStyle(fontSize: 12, color: Color(0xFF737373)),
          ),
        ],
      ],
    );
  }
}

/// Pill-style filter chip used across home and search.
class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.textPrimary : const Color(0xFFE5E5E5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(icon, size: 16, color: selected ? Colors.white : AppColors.textPrimary),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal establishment card — matches web homepage `ListingCard`.
class FeaturedCard extends ConsumerWidget {
  const FeaturedCard({
    super.key,
    required this.establishment,
    required this.width,
    required this.onTap,
  });

  final Establishment establishment;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double featuredImageRadius = 10;
    final AppLanguage lang = ref.watch(languageProvider);
    final City? city = cityById(establishment.cityId);
    final String priceDisplay = establishment.priceLevel;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(kRadiusSm),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(featuredImageRadius),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    AppNetworkImage(url: establishment.coverImage),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: _ImageOverlayPill(
                        label: categoryLabel(establishment.category, lang),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: _FeaturedRatingPill(rating: establishment.rating),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    establishment.localizedName(lang),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.2,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFF737373),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          city?.localizedName(lang) ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF737373),
                            height: 1.2,
                          ),
                        ),
                      ),
                      if (priceDisplay.isNotEmpty)
                        Text(
                          priceDisplay,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                    ],
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

class _FeaturedRatingPill extends StatelessWidget {
  const _FeaturedRatingPill({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.star_rounded, size: 12, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageOverlayPill extends StatelessWidget {
  const _ImageOverlayPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width establishment card used in search results & category lists.
class EstablishmentCard extends ConsumerWidget {
  const EstablishmentCard({super.key, required this.establishment, required this.onTap});

  final Establishment establishment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLanguage lang = ref.watch(languageProvider);
    final strings = ref.watch(stringsProvider);
    final City? city = cityById(establishment.cityId);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(kRadiusSm),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(kRadiusSm),
                    child: _SearchCardImageCarousel(images: establishment.allImages),
                  ),
                ),
                if (establishment.isFeatured)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        strings.featured,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(Icons.star_rounded, size: 12, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          establishment.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          establishment.localizedName(lang),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        categoryLabel(establishment.category, lang),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8A8A8A),
                          height: 1.2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    establishment.localizedShortDescription(lang),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF525252), height: 1.35),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 1),
                        child: Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF737373)),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${city?.localizedName(lang) ?? ''}${establishment.address.isNotEmpty ? ' · ${establishment.address}' : ''}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF737373), height: 1.2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        establishment.priceLevel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ],
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

class _SearchCardImageCarousel extends StatefulWidget {
  const _SearchCardImageCarousel({required this.images});

  final List<String> images;

  @override
  State<_SearchCardImageCarousel> createState() => _SearchCardImageCarouselState();
}

class _SearchCardImageCarouselState extends State<_SearchCardImageCarousel> {
  late final PageController _controller;
  int _currentIndex = 0;
  late int _pageIndex;

  @override
  void initState() {
    super.initState();
    _pageIndex = _hasLoop ? 1 : 0;
    _controller = PageController(initialPage: _pageIndex);
  }

  @override
  void didUpdateWidget(covariant _SearchCardImageCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.images.length != widget.images.length) {
      _pageIndex = _hasLoop ? 1 : 0;
      _currentIndex = 0;
      if (_controller.hasClients) {
        _controller.jumpToPage(_pageIndex);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }
    final List<String> loopedImages =
        _hasLoop ? <String>[images.last, ...images, images.first] : images;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        PageView.builder(
          controller: _controller,
          itemCount: loopedImages.length,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) => AppNetworkImage(url: loopedImages[index]),
        ),
        if (images.length > 1)
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _CarouselArrowButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: _goPrevious,
                ),
                _CarouselArrowButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: _goNext,
                ),
              ],
            ),
          ),
        if (images.length > 1)
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: index == _currentIndex ? Colors.white : Colors.white.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _goPrevious() {
    if (!mounted) return;
    _controller.previousPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _goNext() {
    if (!mounted) return;
    _controller.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  bool get _hasLoop => widget.images.length > 1;

  void _onPageChanged(int page) {
    if (!_hasLoop) {
      if (mounted) setState(() => _currentIndex = page);
      return;
    }

    _pageIndex = page;
    if (page == 0) {
      _currentIndex = widget.images.length - 1;
      if (mounted) setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_controller.hasClients) return;
        _pageIndex = widget.images.length;
        _controller.jumpToPage(_pageIndex);
      });
      return;
    }

    if (page == widget.images.length + 1) {
      _currentIndex = 0;
      if (mounted) setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_controller.hasClients) return;
        _pageIndex = 1;
        _controller.jumpToPage(_pageIndex);
      });
      return;
    }

    if (mounted) setState(() => _currentIndex = page - 1);
  }
}

class _CarouselArrowButton extends StatelessWidget {
  const _CarouselArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.28),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
          ),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/app/theme/app_colors.dart';
import 'package:reservamobile/core/data/cuisines.dart';
import 'package:reservamobile/core/data/mock/mock_data.dart';
import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:reservamobile/core/i18n/app_strings.dart';
import 'package:reservamobile/core/i18n/labels.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/providers/reserva_providers.dart';
import 'package:reservamobile/core/widgets/app_network_image.dart';
import 'package:reservamobile/core/widgets/ui_kit.dart';
import 'package:reservamobile/features/detail/presentation/widgets/location_map.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, required this.establishmentId});

  final String establishmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings t = ref.watch(stringsProvider);
    final estAsync = ref.watch(establishmentByIdProvider(establishmentId));

    return estAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('${t.loadError}: $err')),
      ),
      data: (establishment) {
        if (establishment == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Not found')),
          );
        }
        return _DetailView(establishment: establishment);
      },
    );
  }
}

class _DetailView extends ConsumerWidget {
  const _DetailView({required this.establishment});

  final Establishment establishment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings t = ref.watch(stringsProvider);
    final AppLanguage lang = ref.watch(languageProvider);
    final servicesAsync = ref.watch(servicesProvider(establishment.id));
    final reviewsAsync = ref.watch(reviewsProvider(establishment.id));
    final detailsAsync = ref.watch(establishmentDetailsProvider(establishment));
    final City? city = cityById(establishment.cityId);
    final images = establishment.allImages;

    final double? minPrice = servicesAsync.maybeWhen(
      data: (services) {
        final priced = services.where((s) => s.price > 0).map((s) => s.price).toList();
        if (priced.isEmpty) return null;
        priced.sort();
        return priced.first;
      },
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(child: _Gallery(images: images)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      categoryLabel(establishment.category, lang),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    establishment.localizedName(lang),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.1),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      RatingBadge(rating: establishment.rating, reviewCount: establishment.reviewCount),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF737373)),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          city?.localizedName(lang) ?? '',
                          style: const TextStyle(fontSize: 13, color: Color(0xFF737373)),
                        ),
                      ),
                      Text(
                        establishment.priceLevel,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    establishment.localizedFullDescription(lang),
                    style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF404040)),
                  ),
                  const SizedBox(height: 20),
                  if (establishment.tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: establishment.tags
                          .map((tag) => _Tag(label: prettyToken(tag)))
                          .toList(growable: false),
                    ),
                  const SizedBox(height: 8),
                  // Category-specific details
                  detailsAsync.when(
                    data: (d) => _CategoryDetails(
                      establishment: establishment,
                      details: d,
                      t: t,
                      lang: lang,
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (err, _) => const SizedBox.shrink(),
                  ),
                  // Services
                  const SizedBox(height: 8),
                  SectionHeader(title: t.reservationOptions),
                  servicesAsync.when(
                    data: (services) => Column(
                      children: services
                          .map((s) => _ServiceTile(
                                service: s,
                                lang: lang,
                                t: t,
                                onBook: () => context.push(
                                  AppRoute.booking(establishment.id),
                                  extra: s.id,
                                ),
                              ))
                          .toList(growable: false),
                    ),
                    loading: () => const _MiniLoader(),
                    error: (err, _) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 12),
                  // Location
                  SectionHeader(title: t.location),
                  Text(
                    establishment.address,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF525252)),
                  ),
                  const SizedBox(height: 12),
                  LocationMap(coordinates: establishment.coordinates),
                  const SizedBox(height: 24),
                  // Reviews
                  _ReviewsPreview(
                    establishmentId: establishment.id,
                    reviewsAsync: reviewsAsync,
                    t: t,
                    lang: lang,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BookingBar(
        t: t,
        minPrice: minPrice,
        onBook: () => context.push(AppRoute.booking(establishment.id)),
      ),
    );
  }
}

class _Gallery extends StatefulWidget {
  const _Gallery({required this.images});
  final List<String> images;

  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: 320,
          width: double.infinity,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) => AppNetworkImage(url: widget.images[i]),
          ),
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top + 8,
          left: 12,
          child: _CircleButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.of(context).maybePop(),
          ),
        ),
        if (widget.images.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                widget.images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _index ? 18 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: i == _index ? Colors.white : Colors.white60,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF404040))),
    );
  }
}

class _MiniLoader extends StatelessWidget {
  const _MiniLoader();
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.service,
    required this.lang,
    required this.t,
    required this.onBook,
  });

  final ServiceItem service;
  final AppLanguage lang;
  final AppStrings t;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(kRadius),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  service.localizedName(lang),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                service.price > 0 ? formatMad(service.price, currency: service.currency) : t.free,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            service.localizedShortDescription(lang),
            style: const TextStyle(fontSize: 13, color: Color(0xFF525252), height: 1.35),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              if (service.durationMinutes != null) ...<Widget>[
                const Icon(Icons.schedule, size: 14, color: Color(0xFF737373)),
                const SizedBox(width: 4),
                Text('${service.durationMinutes} ${t.min}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF737373))),
                const SizedBox(width: 12),
              ],
              const Icon(Icons.group_outlined, size: 14, color: Color(0xFF737373)),
              const SizedBox(width: 4),
              Text('${service.minPeople}-${service.maxPeople}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF737373))),
              const Spacer(),
              FilledButton(
                onPressed: onBook,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: Text(
                  service.instantBooking ? t.bookNow : t.requestBooking,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookingBar extends StatelessWidget {
  const _BookingBar({required this.t, required this.minPrice, required this.onBook});
  final AppStrings t;
  final double? minPrice;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.paddingOf(context).bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEDEDED))),
      ),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(minPrice == null ? t.freeReservation : t.startingFrom,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF737373))),
              if (minPrice != null)
                Text(formatMad(minPrice!),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ],
          ),
          const Spacer(),
          FilledButton(
            onPressed: onBook,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
            child: Text(t.bookNow, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ─── Category-specific detail sections ──────────────────────────────────────

class _CategoryDetails extends StatelessWidget {
  const _CategoryDetails({
    required this.establishment,
    required this.details,
    required this.t,
    required this.lang,
  });

  final Establishment establishment;
  final EstablishmentDetails details;
  final AppStrings t;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    final List<Widget> sections = <Widget>[];

    final voyage = details.voyage;
    final restaurant = details.restaurant;
    final wellness = details.wellness;
    final dayPass = details.dayPass;
    final spectacles = details.spectacles;
    final experience = details.experience;

    if (voyage != null) {
      sections
        ..add(_InfoGrid(rows: <MapEntry<String, String>>[
          MapEntry(t.checkIn, voyage.checkInTime),
          MapEntry(t.checkOut, voyage.checkOutTime),
          MapEntry(t.roomTypes, '${voyage.totalRooms}'),
          MapEntry('${voyage.starRating}★', prettyToken(voyage.propertyType)),
        ]))
        ..add(_ChipSection(title: t.amenities, items: voyage.amenities.map(prettyToken).toList()))
        ..add(_ChipSection(title: t.languages, items: voyage.languagesSpoken.map(prettyToken).toList()))
        ..add(_HouseRules(rules: voyage.houseRules, t: t))
        ..add(_Cancellation(policy: voyage.cancellationPolicy, t: t));
    } else if (restaurant != null) {
      sections
        ..add(_ChipSection(
          title: t.cuisine,
          items: restaurant.cuisineType.map((c) => cuisineLabel(c, lang)).toList(),
        ))
        ..add(_InfoGrid(rows: <MapEntry<String, String>>[
          MapEntry(t.seats, '${restaurant.totalSeats}'),
          MapEntry(t.avgDuration, '${restaurant.averageMealDuration} ${t.min}'),
          MapEntry(t.walkIns, restaurant.acceptsWalkins ? t.yes : t.no),
          MapEntry(t.alcohol, restaurant.alcoholServed ? t.yes : t.no),
        ]))
        ..add(_ChipSection(title: t.seating, items: restaurant.seatingOptions.map(prettyToken).toList()))
        ..add(_ChipSection(title: t.dietaryOptions, items: restaurant.dietaryOptions.map(prettyToken).toList()))
        ..add(_OpeningHours(hours: restaurant.openingHours, t: t, lang: lang))
        ..add(_Cancellation(policy: restaurant.cancellationPolicy, t: t));
    } else if (wellness != null) {
      sections
        ..add(_ChipSection(title: t.facilities, items: wellness.facilities.map(prettyToken).toList()))
        ..add(_ChipSection(title: t.productsUsed, items: wellness.productsUsed.map(prettyToken).toList()))
        ..add(_InfoGrid(rows: <MapEntry<String, String>>[
          MapEntry(t.therapists, wellness.therapistGenderAvailable.map(prettyToken).join(', ')),
          MapEntry(t.couplesAvailable, wellness.coupleTreatments ? t.yes : t.no),
        ]))
        ..add(_OpeningHours(hours: wellness.openingHours, t: t, lang: lang));
      if (wellness.generalContraindications != null) {
        sections.add(_NoticeCard(title: t.healthNotice, body: wellness.generalContraindications!));
      }
      sections.add(_Cancellation(policy: wellness.cancellationPolicy, t: t));
    } else if (dayPass != null) {
      sections
        ..add(_ChipSection(title: t.facilitiesIncluded, items: dayPass.facilitiesIncluded.map(prettyToken).toList()))
        ..add(_InfoGrid(rows: <MapEntry<String, String>>[
          MapEntry(t.kidsAllowed, dayPass.kidsAllowed ? t.yes : t.no),
          MapEntry(t.towelsProvided, dayPass.towelsProvided ? t.yes : t.no),
        ]))
        ..add(_OpeningHours(hours: dayPass.openingHours, t: t, lang: lang))
        ..add(_Cancellation(policy: dayPass.cancellationPolicy, t: t));
    } else if (spectacles != null) {
      sections
        ..add(_InfoGrid(rows: <MapEntry<String, String>>[
          MapEntry(t.category, spectacles.eventType),
          MapEntry(t.date, spectacles.date),
          MapEntry(t.time, '${spectacles.startTime} - ${spectacles.endTime}'),
          if (spectacles.ageRestriction != null) MapEntry('Age', spectacles.ageRestriction!),
        ]))
        ..add(_Cancellation(policy: spectacles.cancellationPolicy, t: t));
    } else if (experience != null) {
      sections
        ..add(_ChipSection(
          title: t.details,
          items: experience.localizedHighlights(lang),
        ))
        ..add(_NoticeCard(title: t.availability, body: experience.localizedAvailabilityNote(lang)))
        ..add(_Cancellation(policy: experience.cancellationPolicy, t: t));
    }

    if (sections.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 16),
        ...sections,
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.rows});
  final List<MapEntry<String, String>> rows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: rows
            .map((r) => SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 40 - 12) / 2,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(kRadius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(r.key,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF737373))),
                        const SizedBox(height: 4),
                        Text(r.value,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ))
            .toList(growable: false),
      ),
    );
  }
}

class _ChipSection extends StatelessWidget {
  const _ChipSection({required this.title, required this.items});
  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((i) => _Tag(label: i)).toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _OpeningHours extends StatelessWidget {
  const _OpeningHours({required this.hours, required this.t, required this.lang});
  final Map<String, OpeningHours> hours;
  final AppStrings t;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    final days = orderedDays(hours.keys);
    if (days.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(lang.isFrench ? 'Horaires' : 'Opening hours',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ...days.map((d) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(dayName(d, lang),
                          style: const TextStyle(fontSize: 13, color: Color(0xFF525252))),
                    ),
                    Text('${hours[d]!.open} - ${hours[d]!.close}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _HouseRules extends StatelessWidget {
  const _HouseRules({required this.rules, required this.t});
  final Map<String, bool> rules;
  final AppStrings t;

  @override
  Widget build(BuildContext context) {
    if (rules.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(t.houseRules, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ...rules.entries.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: <Widget>[
                    Icon(e.value ? Icons.check_circle_outline : Icons.cancel_outlined,
                        size: 16, color: e.value ? const Color(0xFF16A34A) : const Color(0xFFB91C1C)),
                    const SizedBox(width: 8),
                    Text(
                      '${prettyToken(e.key)}: ${e.value ? t.yes : t.no}',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF525252)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(kRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(fontSize: 13, color: Color(0xFF525252), height: 1.4)),
        ],
      ),
    );
  }
}

class _Cancellation extends StatelessWidget {
  const _Cancellation({required this.policy, required this.t});
  final String policy;
  final AppStrings t;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(t.cancellationPolicy,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(policy,
              style: const TextStyle(fontSize: 13, color: Color(0xFF525252), height: 1.4)),
        ],
      ),
    );
  }
}

class _ReviewsPreview extends StatelessWidget {
  const _ReviewsPreview({
    required this.establishmentId,
    required this.reviewsAsync,
    required this.t,
    required this.lang,
  });

  final String establishmentId;
  final AsyncValue<List<ReviewItem>> reviewsAsync;
  final AppStrings t;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    return reviewsAsync.when(
      data: (reviews) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionHeader(
              title: t.customerReviews,
              action: reviews.isEmpty ? null : t.seeAll,
              onAction: () => context.push(AppRoute.reviews(establishmentId)),
            ),
            if (reviews.isEmpty)
              Text(t.noReviews, style: const TextStyle(fontSize: 13, color: Color(0xFF737373)))
            else
              ...reviews.take(2).map((r) => _ReviewCard(review: r, lang: lang, t: t)),
          ],
        );
      },
      loading: () => const _MiniLoader(),
      error: (err, _) => const SizedBox.shrink(),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.lang, required this.t});
  final ReviewItem review;
  final AppLanguage lang;
  final AppStrings t;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(kRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(review.userAvatar),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(review.userName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    if (review.isVerified)
                      Text(t.verified,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF16A34A))),
                  ],
                ),
              ),
              RatingBadge(rating: review.rating, compact: true),
            ],
          ),
          const SizedBox(height: 10),
          Text(review.localizedTitle(lang),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(review.localizedContent(lang),
              style: const TextStyle(fontSize: 13, color: Color(0xFF525252), height: 1.4)),
        ],
      ),
    );
  }
}

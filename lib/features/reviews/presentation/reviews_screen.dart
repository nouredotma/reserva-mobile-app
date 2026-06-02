import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/app/theme/app_colors.dart';
import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:reservamobile/core/i18n/app_strings.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/providers/reserva_providers.dart';
import 'package:reservamobile/core/widgets/app_scaffold.dart';
import 'package:reservamobile/core/widgets/ui_kit.dart';

class ReviewsScreen extends ConsumerStatefulWidget {
  const ReviewsScreen({super.key, required this.establishmentId});

  final String establishmentId;

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  double _rating = 5;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppStrings t) async {
    if (_contentController.text.trim().isEmpty) return;
    setState(() => _submitting = true);
    await ref.read(reservaRepositoryProvider).addReview(
          establishmentId: widget.establishmentId,
          rating: _rating,
          title: _titleController.text.trim().isEmpty
              ? (t.customerReviews)
              : _titleController.text.trim(),
          content: _contentController.text.trim(),
        );
    ref.invalidate(reviewsProvider(widget.establishmentId));
    _titleController.clear();
    _contentController.clear();
    if (!mounted) return;
    setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings t = ref.watch(stringsProvider);
    final AppLanguage lang = ref.watch(languageProvider);
    final reviewsAsync = ref.watch(reviewsProvider(widget.establishmentId));

    return AppScaffold(
      title: t.customerReviews,
      padding: const EdgeInsets.fromLTRB(
        kScreenPaddingHorizontal,
        4,
        kScreenPaddingHorizontal,
        40,
      ),
      children: <Widget>[
        // Rating selector
        Row(
          children: List<Widget>.generate(5, (i) {
            final value = i + 1;
            return GestureDetector(
              onTap: () => setState(() => _rating = value.toDouble()),
              child: Icon(
                value <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                color: AppColors.primary,
                size: 34,
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: lang.isFrench ? 'Titre' : 'Title',
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kRadius),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _contentController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: lang.isFrench ? 'Partagez votre expérience' : 'Share your experience',
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kRadius),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _submitting ? null : () => _submit(t),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textPrimary,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
          child: Text(lang.isFrench ? 'Envoyer' : 'Submit'),
        ),
        const SizedBox(height: 24),
        reviewsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Text('${t.loadError}: $err'),
          data: (reviews) {
            if (reviews.isEmpty) {
              return Text(t.noReviews, style: const TextStyle(color: Color(0xFF737373)));
            }
            return Column(
              children: reviews.map((r) => _ReviewItemCard(review: r, lang: lang, t: t)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ReviewItemCard extends StatelessWidget {
  const _ReviewItemCard({required this.review, required this.lang, required this.t});
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
              CircleAvatar(radius: 18, backgroundImage: NetworkImage(review.userAvatar)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(review.userName,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
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

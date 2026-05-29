import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/providers/reserva_providers.dart';
import 'package:reservamobile/core/widgets/scroll_aware_scaffold.dart';

class ReviewsScreen extends ConsumerStatefulWidget {
  const ReviewsScreen({super.key, required this.establishmentId});

  final String establishmentId;

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 5;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(reservaRepositoryProvider);
    return FutureBuilder<List<ReviewItem>>(
      future: repository.getReviewsForEstablishment(widget.establishmentId),
      builder: (context, snapshot) {
        final reviews = snapshot.data ?? const <ReviewItem>[];
        return ScrollAwareScaffold(
          title: 'Reviews',
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Write a review',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<double>(
                initialValue: _rating,
                items: const [
                  DropdownMenuItem(value: 5, child: Text('5.0')),
                  DropdownMenuItem(value: 4, child: Text('4.0')),
                  DropdownMenuItem(value: 3, child: Text('3.0')),
                  DropdownMenuItem(value: 2, child: Text('2.0')),
                  DropdownMenuItem(value: 1, child: Text('1.0')),
                ],
                onChanged: (value) => setState(() => _rating = value ?? 5),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reviewController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Share your experience',
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () async {
                  if (_reviewController.text.trim().isEmpty) {
                    return;
                  }
                  await repository.addReview(
                    establishmentId: widget.establishmentId,
                    rating: _rating,
                    content: _reviewController.text.trim(),
                  );
                  _reviewController.clear();
                  if (!mounted) {
                    return;
                  }
                  setState(() {});
                },
                child: const Text('Submit review'),
              ),
              const SizedBox(height: 20),
              Text(
                'All reviews',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator())
              else if (reviews.isEmpty)
                const Text('No reviews yet.')
              else
                ...reviews.map(
                  (review) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(
                        '${review.userName} • ${review.rating.toStringAsFixed(1)}',
                      ),
                      subtitle: Text(review.content),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

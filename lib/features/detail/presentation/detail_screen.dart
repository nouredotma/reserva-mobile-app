import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/providers/reserva_providers.dart';
import 'package:reservamobile/core/widgets/scroll_aware_scaffold.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, required this.establishmentId});

  final String establishmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(reservaRepositoryProvider);

    return FutureBuilder<List<Object?>>(
      future: Future.wait([
        repository.getEstablishmentById(establishmentId),
        repository.getServicesForEstablishment(establishmentId),
        repository.getReviewsForEstablishment(establishmentId),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final data = snapshot.data!;
        final establishment = data[0] as Establishment?;
        final services = data[1] as List<ServiceItem>;
        final reviews = data[2] as List<ReviewItem>;

        if (establishment == null) {
          return const ScrollAwareScaffold(
            title: 'Detail',
            body: Center(child: Text('Establishment not found')),
          );
        }

        return ScrollAwareScaffold(
          title: establishment.name,
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                establishment.shortDescription,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Text('Category: ${establishment.category.name}'),
              Text('Subcategory: ${establishment.subcategory}'),
              Text('City: ${establishment.cityName}'),
              Text('Address: ${establishment.address}'),
              Text(
                'Rating: ${establishment.rating} (${establishment.reviewCount} reviews)',
              ),
              const SizedBox(height: 18),
              Text('Services', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...services.map((service) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(service.name),
                  subtitle: Text('${service.durationMinutes} min'),
                  trailing: Text('${service.priceMad} MAD'),
                );
              }),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () =>
                    context.push(AppRoute.booking(establishmentId)),
                child: const Text('Book now'),
              ),
              TextButton(
                onPressed: () =>
                    context.push(AppRoute.reviews(establishmentId)),
                child: Text('See all reviews (${reviews.length})'),
              ),
            ],
          ),
        );
      },
    );
  }
}

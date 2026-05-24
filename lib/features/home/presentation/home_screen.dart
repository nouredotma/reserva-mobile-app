import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/core/assets/app_assets.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/providers/reserva_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final featuredAsync = ref.watch(featuredEstablishmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(AppAssets.logo, width: 120, fit: BoxFit.contain),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Discover top places',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            'Home, search, detail, booking, account, and reviews are now wired with mock data.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Text('Categories', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          categoriesAsync.when(
            data: (categories) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories
                  .map(
                    (item) => ActionChip(
                      label: Text(item.label),
                      onPressed: () {
                        ref
                            .read(searchFiltersProvider.notifier)
                            .setCategory(item.key);
                        ref.read(searchFiltersProvider.notifier).setQuery('');
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Failed to load categories: $err'),
          ),
          const SizedBox(height: 24),
          Text('Featured', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          featuredAsync.when(
            data: (items) => Column(
              children: items
                  .map(
                    (item) => _FeaturedCard(
                      item: item,
                      onTap: () => context.push(AppRoute.detail(item.id)),
                    ),
                  )
                  .toList(growable: false),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Failed to load featured: $err'),
          ),
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.item, required this.onTap});

  final Establishment item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(item.name),
        subtitle: Text(
          '${item.cityName} • ${item.subcategory} • ${item.priceLevel}',
        ),
        trailing: Text(item.rating.toStringAsFixed(1)),
        onTap: onTap,
      ),
    );
  }
}

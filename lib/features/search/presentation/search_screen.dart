import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/core/config/mapbox_config.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/providers/reserva_providers.dart';
import 'package:reservamobile/features/search/presentation/search_map_section.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);
    final citiesAsync = ref.watch(citiesProvider);
    final resultsAsync = ref.watch(searchedEstablishmentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Search by name, subcategory, city',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: ref.read(searchFiltersProvider.notifier).setQuery,
          ),
          const SizedBox(height: 12),
          citiesAsync.when(
            data: (cities) => DropdownButtonFormField<String?>(
              initialValue: filters.cityId,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All cities'),
                ),
                ...cities.map(
                  (city) => DropdownMenuItem<String?>(
                    value: city.id,
                    child: Text(city.name),
                  ),
                ),
              ],
              onChanged: ref.read(searchFiltersProvider.notifier).setCity,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Failed to load cities: $err'),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.map_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    MapboxConfig.isConfigured
                        ? 'Mapbox token configured for upcoming map search.'
                        : 'Mapbox token missing.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<EstablishmentCategory?>(
            initialValue: filters.category,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem<EstablishmentCategory?>(
                value: null,
                child: Text('All categories'),
              ),
              DropdownMenuItem(
                value: EstablishmentCategory.restaurants,
                child: Text('Restaurants'),
              ),
              DropdownMenuItem(
                value: EstablishmentCategory.wellness,
                child: Text('Wellness'),
              ),
              DropdownMenuItem(
                value: EstablishmentCategory.voyage,
                child: Text('Voyage'),
              ),
              DropdownMenuItem(
                value: EstablishmentCategory.dayPasses,
                child: Text('Day Passes'),
              ),
              DropdownMenuItem(
                value: EstablishmentCategory.conciergerie,
                child: Text('Concierge'),
              ),
              DropdownMenuItem(
                value: EstablishmentCategory.spectacles,
                child: Text('Spectacles'),
              ),
              DropdownMenuItem(
                value: EstablishmentCategory.corporate,
                child: Text('Corporate'),
              ),
              DropdownMenuItem(
                value: EstablishmentCategory.services,
                child: Text('Services'),
              ),
            ],
            onChanged: ref.read(searchFiltersProvider.notifier).setCategory,
          ),
          const SizedBox(height: 18),
          Text('Results', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          resultsAsync.when(
            data: (results) {
              if (results.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text('No matches found.'),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SearchMapSection(
                    results: results,
                    onSelect: (item) => context.push(AppRoute.detail(item.id)),
                  ),
                  const SizedBox(height: 10),
                  ...results.map(
                    (item) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(
                          '${item.cityName} • ${item.subcategory}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(AppRoute.detail(item.id)),
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Search failed: $err'),
          ),
        ],
      ),
    );
  }
}

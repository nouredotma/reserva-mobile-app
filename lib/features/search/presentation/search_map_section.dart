import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:reservamobile/core/config/mapbox_config.dart';
import 'package:reservamobile/core/models/app_models.dart';

class SearchMapSection extends StatelessWidget {
  const SearchMapSection({
    super.key,
    required this.results,
    required this.onSelect,
  });

  final List<Establishment> results;
  final ValueChanged<Establishment> onSelect;

  @override
  Widget build(BuildContext context) {
    if (!MapboxConfig.isConfigured) {
      return const SizedBox.shrink();
    }

    final points = results
        .map((item) => (item: item, point: _pointFor(item)))
        .toList(growable: false);

    final markers = points
        .map(
          (entry) => Marker(
            point: entry.point,
            width: 44,
            height: 44,
            child: GestureDetector(
              onTap: () => onSelect(entry.item),
              child: const Icon(
                Icons.location_on,
                color: Color(0xFFFFC900),
                size: 34,
              ),
            ),
          ),
        )
        .toList(growable: false);

    final center = points.isEmpty
        ? const LatLng(33.5731, -7.5898)
        : points.first.point;

    return SizedBox(
      height: 260,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: 10.5,
            minZoom: 5,
            maxZoom: 17,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}@2x?access_token=${MapboxConfig.accessToken}',
              userAgentPackageName: 'com.reserva.mobile',
            ),
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 50,
                size: const Size(42, 42),
                markers: markers,
                builder: (context, clusterMarkers) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC900),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Text(
                      clusterMarkers.length.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

LatLng _pointFor(Establishment item) {
  final cityBase = item.cityId == 'marrakesh'
      ? const LatLng(31.6295, -7.9811)
      : const LatLng(33.5731, -7.5898);
  final hash = item.id.codeUnits.fold<int>(0, (acc, code) => acc + code);
  final latOffset = ((hash % 7) - 3) * 0.01;
  final lngOffset = (((hash ~/ 3) % 7) - 3) * 0.01;
  return LatLng(cityBase.latitude + latOffset, cityBase.longitude + lngOffset);
}

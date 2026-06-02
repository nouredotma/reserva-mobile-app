import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:reservamobile/app/theme/app_colors.dart';
import 'package:reservamobile/core/config/mapbox_config.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/widgets/ui_kit.dart';

/// Single-establishment location map shown on the detail page.
class LocationMap extends StatelessWidget {
  const LocationMap({super.key, required this.coordinates});

  final Coordinates coordinates;

  @override
  Widget build(BuildContext context) {
    final LatLng point = LatLng(coordinates.lat, coordinates.lng);
    final Widget map = ClipRRect(
      borderRadius: BorderRadius.circular(kRadiusSm),
      child: SizedBox(
        height: 200,
        child: MapboxConfig.isConfigured
            ? FlutterMap(
                options: MapOptions(
                  initialCenter: point,
                  initialZoom: 13.5,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                  ),
                ),
                children: <Widget>[
                  TileLayer(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}@2x?access_token=${MapboxConfig.accessToken}',
                    userAgentPackageName: 'com.reserva.mobile',
                  ),
                  MarkerLayer(
                    markers: <Marker>[
                      Marker(
                        point: point,
                        width: 44,
                        height: 44,
                        child: const Icon(Icons.location_on,
                            color: AppColors.primary, size: 38),
                      ),
                    ],
                  ),
                ],
              )
            : Container(
                color: const Color(0xFFEDEDED),
                alignment: Alignment.center,
                child: const Icon(Icons.map_outlined,
                    size: 40, color: Color(0xFF9E9E9E)),
              ),
      ),
    );
    return map;
  }
}

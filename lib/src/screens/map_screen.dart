import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../services/local_data_service.dart';
import '../models/waste_point.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pos;

  @override
  void initState() {
    super.initState();
    _ensureLocation();
  }

  Future<void> _ensureLocation() async {
    final perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.deniedForever) return;
    final p = await Geolocator.getCurrentPosition();
    setState(() => _pos = LatLng(p.latitude, p.longitude));
  }

  @override
  Widget build(BuildContext context) {
    final points = DataService.instance.wastePointsList;
    final center = _pos ?? (points.isNotEmpty ? LatLng(points.first.lat, points.first.lng) : const LatLng(12.3714, -1.5197)); 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des points de collecte'),
        backgroundColor: Colors.green[700],
        titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      body: FlutterMap(
        options: MapOptions(initialCenter: center, initialZoom: 13),
        children: [
          TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.example.ecocollect'),
          MarkerLayer(markers: [
            if (_pos != null)
              Marker(point: _pos!, width: 40, height: 40, child: const Icon(Icons.my_location, size: 32)),
            for (final w in points)
              Marker(
                point: LatLng(w.lat, w.lng),
                width: 50, height: 50,
                child: Tooltip(
                  message: "${w.name}\n${w.accepts}",
                  child: InkWell(
                    onTap: () => showDialog(context: context, builder: (_) => _WastePointDialog(w: w)),
                    child: const Icon(Icons.location_on, size: 40),
                  ),
                ),
              ),
          ]),
        ],
      ),
    );
  }
}

class _WastePointDialog extends StatelessWidget {
  final WastePoint w;
  const _WastePointDialog({required this.w});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(w.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(w.address),
          const SizedBox(height: 6),
          Text("Déchets acceptés: ${w.accepts}"),
          const SizedBox(height: 6),
          Text("Horaires: ${w.hours}"),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
      ],
    );
  }
}

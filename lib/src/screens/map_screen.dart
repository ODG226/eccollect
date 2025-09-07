import 'package:ecocollect/src/services/waste_point_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/local_data_service.dart';
import '../models/waste_point.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pos;
  String? id;

  List<WastePoint> points = [];

  @override
  void initState() {
    super.initState();
    _ensureLocation();
    _getPrefs();
    _fetchData();
  }

  Future<void> _fetchData() async
  {
    try
    {
      var data = await WastePointService().fetchWastePoints();
      DataService.instance.wastePointsList = data;
      setState(() {
        points = data;
      });
    }
    catch(e)
    {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Impossible de charger les points de collecte')));
    }
  }

  Future<void> _getPrefs() async
  {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
  }

  Future<void> _ensureLocation() async {
    final perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.deniedForever) return;
    final p = await Geolocator.getCurrentPosition();
    setState(() => _pos = LatLng(p.latitude, p.longitude));
  }

  void _sendCurrentPosition()
  {
    showDialog(context: context, builder: (context) => AlertDialog(
        title: const Text('Envoyer ma position actuelle'),
        content: const Text('Êtes-vous sûr de vouloir votre position actuelle comme point de reference pour le ramassage d\'ordure ?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
          TextButton(onPressed: () async 
          {
            try
            {
              if([id, _pos].contains(null))
              {
                Navigator.of(context).pop();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Identifiants ou position indefinie')));
              }
              {
                await WastePointService().saveOrUpdateUserPoint(id: id!, geolocation: _pos!);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La position a ete sauvegardée.')));
              }
            
            }
            catch(e)
            {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Impossible de sauvegarder les donnees')));
            }
            Navigator.of(context).pop();
          }, child: const Text('Envoyer')),
        ],
      ));
  }

  @override
  Widget build(BuildContext context) {
    //final points = DataService.instance.wastePointsList;
    final center = _pos ?? (points.isNotEmpty ? LatLng(points.first.lat, points.first.long) : const LatLng(12.3714, -1.5197)); 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des points de collecte'),
        backgroundColor: Colors.green[700],
        titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      body: Stack(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(initialCenter: center, initialZoom: 13),
              children: [
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.example.ecocollect'),
                MarkerLayer(markers: [
                  if (_pos != null)
                    Marker(point: _pos!, width: 40, height: 40, child: const Icon(Icons.my_location, size: 32)),
                  for (final w in points)
                    Marker(
                      point: LatLng(w.lat, w.long),
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
                Positioned(
                  bottom: 24,
                  left: 12,
                  child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    height: 42,
                    width: MediaQuery.of(context).size.width - 24,
                    child: InkWell(
                      onTap: ()
                      {
                        _sendCurrentPosition();
                      },
                      child: Center(child: Text("Envoyer ma position actuelle", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                    )
                    ))
              ],
            ),
          ),
        
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

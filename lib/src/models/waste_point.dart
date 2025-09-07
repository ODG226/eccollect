import 'dart:convert';

class WastePoint {
  final String id;
  final String name;
  final double lat;
  final double long;
  final String type; // bin, center
  final String address;
  final String accepts; // plastics, paper, etc.
  final String hours;

  WastePoint({
    required this.id,
    required this.name,
    required this.lat,
    required this.long,
    required this.type,
    required this.address,
    required this.accepts,
    required this.hours,
  });

  factory WastePoint.fromMap(Map<String, dynamic> m) => WastePoint(
    id: m['id'] ?? '',
    name: m['name'] ?? 'Point',
    lat: (m['lat'] ?? 0).toDouble(),
    long: (m['long'] ?? 0).toDouble(),
    type: m['type'] ?? 'bin',
    address: m['address'] ?? '',
    accepts: m['accepts'] ?? '',
    hours: m['hours'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'lat': lat,
    'long': long,
    'type': type,
    'address': address,
    'accepts': accepts,
    'hours': hours,
  };

  @override
  String toString()
  {
    return jsonEncode(toMap());
  }
}
